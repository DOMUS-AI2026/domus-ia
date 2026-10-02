from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.services.score_engine import compute_score

router = APIRouter(prefix="/homes/{home_id}/score", tags=["score"])


@router.get("")
def get_score(home_id: int, db: Session = Depends(get_db)):
    """Recalculado sob demanda a partir do estado atual dos ambientes (sempre consistente)."""
    return compute_score(db, home_id)
