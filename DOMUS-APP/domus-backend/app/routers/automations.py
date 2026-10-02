from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.database import get_db
from app.models.sql_models import Automation
from app.schemas.pydantic_schemas import AutomationRuleOut

router = APIRouter(prefix="/homes/{home_id}/automations", tags=["automations"])


@router.get("", response_model=list[AutomationRuleOut])
def list_rules(home_id: int, db: Session = Depends(get_db)):
    return db.query(Automation).filter_by(home_id=home_id).all()


@router.post("/{rule_key}/toggle", response_model=AutomationRuleOut)
def toggle_rule(home_id: int, rule_key: str, db: Session = Depends(get_db)):
    rule = db.query(Automation).filter_by(home_id=home_id, rule_key=rule_key).first()
    rule.enabled = not rule.enabled
    db.commit()
    return rule
