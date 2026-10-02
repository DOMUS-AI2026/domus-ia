from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from app.database import get_db
from app.models.sql_models import Alert, RoomStatus
from app.schemas.pydantic_schemas import AlertOut

router = APIRouter(prefix="/homes/{home_id}/alerts", tags=["alerts"])


@router.get("", response_model=list[AlertOut])
def list_alerts(home_id: int, db: Session = Depends(get_db)):
    """Só os não resolvidos — é a lista que vira o Alert Center."""
    return (db.query(Alert)
            .filter_by(home_id=home_id, resolved_at=None)
            .order_by(Alert.status.desc(), Alert.created_at.desc())
            .all())


@router.post("/{alert_id}/resolve")
def resolve_alert(home_id: int, alert_id: int, db: Session = Depends(get_db)):
    alert = db.query(Alert).filter_by(id=alert_id, home_id=home_id).first()
    if not alert:
        raise HTTPException(404, "Alerta não encontrado")
    alert.resolved_at = datetime.utcnow()
    alert.resolved_by = "manual"

    status_row = db.query(RoomStatus).filter_by(room_id=alert.room_id).first()
    if status_row:
        status_row.status = "normal"

    db.commit()
    return {"id": alert_id, "resolved": True}
