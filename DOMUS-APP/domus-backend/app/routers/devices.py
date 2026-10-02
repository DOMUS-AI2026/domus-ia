from fastapi import APIRouter, Depends, HTTPException, BackgroundTasks
from sqlalchemy.orm import Session
from datetime import datetime
from app.database import get_db
from app.models.sql_models import Device, Room, Command
from app.schemas.pydantic_schemas import DeviceCommand
from app.mongo import device_logs
from app.services.automation_engine import run_automations

router = APIRouter(prefix="/homes/{home_id}/rooms/{slug}/devices/{key}", tags=["devices"])


@router.post("/command")
async def send_command(home_id: int, slug: str, key: str, cmd: DeviceCommand,
                        db: Session = Depends(get_db)):
    """
    Comando vindo do site OU do futuro app mobile. Como os dois falam com a mesma API,
    o estado fica sempre sincronizado nos dois lugares (seção 28 do briefing).
    """
    room = db.query(Room).filter_by(home_id=home_id, slug=slug).first()
    if not room:
        raise HTTPException(404, "Ambiente não encontrado")
    device = next((d for d in room.devices if d.key_name == key), None)
    if not device:
        raise HTTPException(404, "Dispositivo não encontrado")

    if cmd.action == "on":
        device.state = device.on_value
    elif cmd.action == "off":
        device.state = device.off_value
    else:  # toggle
        device.state = device.off_value if device.state == device.on_value else device.on_value

    db.add(Command(device_id=device.id, action=cmd.action, issued_by=cmd.issued_by))
    db.commit()

    await device_logs.insert_one({
        "device_id": device.id, "room_id": room.id, "action": cmd.action,
        "state": device.state, "issued_by": cmd.issued_by, "timestamp": datetime.utcnow(),
    })
    await run_automations(db, home_id)
    return {"key": key, "state": device.state}
