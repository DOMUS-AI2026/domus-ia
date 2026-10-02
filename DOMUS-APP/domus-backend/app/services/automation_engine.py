"""
Regras de automação (seção 26 do briefing). Mesma lógica do protótipo front-end
(automationRules em domus-app.html), agora do lado do servidor, para que o
comportamento seja idêntico não importa qual cliente (web ou app mobile) disparou o evento.

Cada regra: condição sobre um Room + ação que altera Sensor/Device/RoomStatus,
grava um evento em `events` (MongoDB) e um Command em `commands` (MySQL).
"""
from sqlalchemy.orm import Session
from datetime import datetime
from app.models.sql_models import Room, Sensor, Device, RoomStatus, Automation
from app.mongo import events as mongo_events


def _get_sensor(db: Session, room_id: int, key: str):
    return db.query(Sensor).filter_by(room_id=room_id, key_name=key).first()


def _get_device(db: Session, room_id: int, key: str):
    return db.query(Device).filter_by(room_id=room_id, key_name=key).first()


async def run_automations(db: Session, home_id: int):
    """Verifica e aplica todas as regras ativas. Chamado após qualquer alteração de estado."""
    rules = {a.rule_key: a for a in db.query(Automation).filter_by(home_id=home_id).all()}
    rooms = db.query(Room).filter_by(home_id=home_id).all()
    triggered = []

    for room in rooms:
        status_row = db.query(RoomStatus).filter_by(room_id=room.id).first()

        # 1) Vazamento detectado -> fechar válvula
        if rules.get("valve") and rules["valve"].enabled:
            vaz = _get_sensor(db, room.id, "vazamento")
            valv = _get_device(db, room.id, "valvula")
            if vaz and vaz.last_value == "Detectado" and valv:
                valv.state = valv.off_value  # "Fechada"
                vaz.last_value, vaz.last_status = "Não detectado", "normal"
                if status_row: status_row.status = "normal"
                triggered.append((room, "Vazamento detectado → fechar válvula"))

        # 2) Sem presença -> desligar luz
        if rules.get("light") and rules["light"].enabled:
            presenca = _get_sensor(db, room.id, "presenca")
            luz = _get_device(db, room.id, "luz")
            if presenca and luz and presenca.last_value == "Não detectada" and luz.state == luz.on_value:
                luz.state = luz.off_value
                if status_row and status_row.status == "atencao": status_row.status = "normal"
                triggered.append((room, "Sem presença → desligar luz"))

        # 3) Temp > 27 com presença -> climatização
        if rules.get("clima") and rules["clima"].enabled:
            temp = _get_sensor(db, room.id, "temp")
            presenca = _get_sensor(db, room.id, "presenca")
            if temp and presenca and presenca.last_value == "Detectada":
                try:
                    if float(temp.last_value) > 27:
                        temp.last_value, temp.last_status = "23.5", "normal"
                        if status_row and status_row.status == "atencao": status_row.status = "normal"
                        triggered.append((room, "Temp. alta com presença → climatização"))
                except ValueError:
                    pass

    db.commit()
    for room, label in triggered:
        await mongo_events.insert_one({
            "home_id": home_id, "room_id": room.id, "type": "automation",
            "message": label, "timestamp": datetime.utcnow(),
        })
    return triggered
