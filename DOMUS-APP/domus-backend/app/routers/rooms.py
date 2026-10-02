from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.sql_models import Room, RoomStatus
from app.schemas.pydantic_schemas import RoomOut

router = APIRouter(prefix="/homes/{home_id}/rooms", tags=["rooms"])


@router.get("", response_model=list[RoomOut])
def list_rooms(home_id: int, db: Session = Depends(get_db)):
    """Estado completo da casa — é isso que alimenta a planta 2D e a cena 3D no front-end."""
    rooms = db.query(Room).filter_by(home_id=home_id).all()
    out = []
    for r in rooms:
        status = r.status.status if r.status else "normal"
        out.append(RoomOut(
            id=r.id, slug=r.slug, name=r.name, area_m2=float(r.area_m2),
            pos_x=float(r.pos_x), pos_z=float(r.pos_z),
            width_m=float(r.width_m), depth_m=float(r.depth_m),
            status=status, sensors=r.sensors, devices=r.devices,
        ))
    return out


@router.get("/{slug}", response_model=RoomOut)
def get_room(home_id: int, slug: str, db: Session = Depends(get_db)):
    r = db.query(Room).filter_by(home_id=home_id, slug=slug).first()
    if not r:
        raise HTTPException(404, "Ambiente não encontrado")
    status = r.status.status if r.status else "normal"
    return RoomOut(
        id=r.id, slug=r.slug, name=r.name, area_m2=float(r.area_m2),
        pos_x=float(r.pos_x), pos_z=float(r.pos_z),
        width_m=float(r.width_m), depth_m=float(r.depth_m),
        status=status, sensors=r.sensors, devices=r.devices,
    )
