from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from app.database import get_db
from app.models.sql_models import Room, Sensor, Device, RoomStatus, Alert
from app.schemas.pydantic_schemas import SimulationRequest
from app.mongo import simulation_events
from app.services.automation_engine import run_automations

# mesmo mapeamento cenário -> efeito usado no protótipo front-end (events{} em domus-app.html)
SCENARIOS = {
    "vazamento":       {"room": "banheiro",  "status": "critico", "sensors": {"vazamento": "Detectado", "agua": "280"}},
    "alto_consumo":    {"room": "cozinha",   "status": "atencao", "sensors": {"energia": "4.8"}},
    "ar_sem_presenca": {"room": "sala",      "status": "atencao", "sensors": {"presenca": "Não detectada", "consumo": "3.2"}},
    "luz_sem_presenca":{"room": "quarto1",   "status": "atencao", "sensors": {"luz": "Ligada", "presenca": "Não detectada"}},
    "porta_aberta":    {"room": "sala",      "status": "atencao", "sensors": {"porta": "Aberta"}},
    "consumo_normal":  {"room": "escritorio","status": "normal",  "sensors": {"energia": "1.2"}},
}

router = APIRouter(prefix="/homes/{home_id}/simulate", tags=["simulate"])


@router.post("")
async def simulate(home_id: int, req: SimulationRequest, db: Session = Depends(get_db)):
    """
    Dispara um cenário de demonstração (seção 22 do briefing). Usado nos botões
    'Simular vazamento', 'Simular alto consumo' etc. da tela SIMULADOR DOMUS AI.
    """
    if req.scenario == "restaurar":
        for room in db.query(Room).filter_by(home_id=home_id).all():
            if room.status:
                room.status.status = "normal"
        db.commit()
        await simulation_events.insert_one({"home_id": home_id, "scenario": "restaurar", "timestamp": datetime.utcnow()})
        return {"restored": True}

    scenario = SCENARIOS.get(req.scenario)
    if not scenario:
        raise HTTPException(400, "Cenário inválido")

    slug = req.room_slug or scenario["room"]
    room = db.query(Room).filter_by(home_id=home_id, slug=slug).first()
    if not room:
        raise HTTPException(404, "Ambiente não encontrado")

    for key, value in scenario["sensors"].items():
        sensor = next((s for s in room.sensors if s.key_name == key), None)
        device = next((d for d in room.devices if d.key_name == key), None)
        if sensor:
            sensor.last_value = value
        elif device:
            device.state = value

    if room.status:
        room.status.status = scenario["status"]

    if scenario["status"] in ("atencao", "critico"):
        db.add(Alert(home_id=home_id, room_id=room.id, status=scenario["status"],
                      message=f"Cenário simulado: {req.scenario}"))

    db.commit()
    await simulation_events.insert_one({
        "home_id": home_id, "room_id": room.id, "scenario": req.scenario, "timestamp": datetime.utcnow(),
    })
    await run_automations(db, home_id)
    return {"scenario": req.scenario, "room": slug, "status": scenario["status"]}
