"""
Popula o banco com a MESMA planta e os MESMOS dados usados no protótipo front-end
(domus-app.html), para que backend e front concordem desde o primeiro teste.

Rodar com:  python -m app.seed
"""
from app.database import SessionLocal, engine, Base
from app.models.sql_models import Home, Room, Sensor, Device, RoomStatus, Automation

Base.metadata.create_all(bind=engine)

# name, area, x, z, w, d, sensors{key:(label,unit,value)}, devices{key:(label,state,on,off)}
ROOMS = {
    "sala":       ("Sala / Jantar", 24, 0, 0, 8, 3,
                    {"presenca": ("Presença", None, "Detectada"), "temp": ("Temperatura", "°C", "24.2"), "consumo": ("Consumo (AC)", "kWh", "0.6")},
                    {"luz": ("Iluminação", "Ligada", "Ligada", "Desligada"), "porta": ("Porta principal", "Fechada", "Aberta", "Fechada"), "janela": ("Janela", "Aberta", "Aberta", "Fechada")}),
    "cozinha":    ("Cozinha", 12, 8, 0, 4, 3,
                    {"presenca": ("Presença", None, "Não detectada"), "temp": ("Temperatura", "°C", "23.5"), "energia": ("Energia", "kWh", "1.1")}, {}),
    "quarto1":    ("Quarto 1", 12, 0, 3, 4.24, 2.83,
                    {"presenca": ("Presença", None, "Não detectada"), "temp": ("Temperatura", "°C", "22.8")},
                    {"luz": ("Iluminação", "Desligada", "Ligada", "Desligada")}),
    "escritorio": ("Escritório", 10, 4.24, 3, 3.52, 2.83,
                    {"presenca": ("Presença", None, "Detectada"), "energia": ("Energia", "kWh", "0.9"), "temp": ("Temperatura", "°C", "23.0")}, {}),
    "quarto2":    ("Quarto 2", 12, 7.76, 3, 4.24, 2.83,
                    {"presenca": ("Presença", None, "Não detectada"), "temp": ("Temperatura", "°C", "22.6"), "energia": ("Energia", "kWh", "0.3")}, {}),
    "banheiro":   ("Banheiro", 6, 0, 5.83, 1.44, 4.17,
                    {"agua": ("Água", "L/dia", "120"), "vazamento": ("Vazamento", None, "Não detectado")},
                    {"valvula": ("Válvula", "Aberta", "Aberta", "Fechada")}),
    "suite":      ("Suíte", 16, 1.44, 5.83, 3.84, 4.17,
                    {"presenca": ("Presença", None, "Detectada"), "temp": ("Temperatura", "°C", "23.8")}, {}),
    "banhosuite": ("Banho Suíte", 5, 5.28, 5.83, 1.2, 4.17,
                    {"agua": ("Água", "L/dia", "40")},
                    {"luz": ("Iluminação", "Desligada", "Ligada", "Desligada")}),
    "lavanderia": ("Lavanderia", 23, 6.48, 5.83, 5.52, 4.17,
                    {"agua": ("Água", "L/h", "0")},
                    {"maquina": ("Máq. lavar", "Parada", "Lavando", "Parada")}),
}

RULES = [
    ("valve", "Vazamento detectado → fechar válvula"),
    ("light", "Sem presença por 15 min → desligar luz"),
    ("clima", "Temp. > 27°C com presença → climatização"),
]


def seed():
    db = SessionLocal()
    home = Home(user_id=None, name="Casa ExpoTech", area_m2=120, width_m=12, depth_m=10)
    db.add(home)
    db.flush()  # pega home.id sem precisar commitar ainda

    for slug, (name, area, x, z, w, d, sensors, devices) in ROOMS.items():
        room = Room(home_id=home.id, slug=slug, name=name, area_m2=area,
                    pos_x=x, pos_z=z, width_m=w, depth_m=d)
        db.add(room)
        db.flush()

        db.add(RoomStatus(room_id=room.id, status="normal"))
        for key, (label, unit, value) in sensors.items():
            db.add(Sensor(room_id=room.id, key_name=key, label=label, unit=unit,
                           last_value=value, last_status="normal"))
        for key, (label, state, on_v, off_v) in devices.items():
            db.add(Device(room_id=room.id, key_name=key, label=label, state=state,
                           on_value=on_v, off_value=off_v))

    for rule_key, label in RULES:
        db.add(Automation(home_id=home.id, rule_key=rule_key, label=label, enabled=True))

    db.commit()
    print(f"Seed concluído. home_id = {home.id}")


if __name__ == "__main__":
    seed()
