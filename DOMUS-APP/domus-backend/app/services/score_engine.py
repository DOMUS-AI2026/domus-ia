"""
Porta para Python da mesma regra usada no protótipo front-end (computeScore em domus-app.html),
para que backend e front concordem sobre o cálculo do DOMUS SCORE.
"""
from sqlalchemy.orm import Session
from app.models.sql_models import RoomStatus


def compute_score(db: Session, home_id: int) -> dict:
    energia = agua = eficiencia = seguranca = sustentabilidade = comportamento = 100

    statuses = (
        db.query(RoomStatus)
        .join(RoomStatus.room)
        .filter_by(home_id=home_id)
        .all()
    )

    for rs in statuses:
        if rs.status == "critico":
            seguranca -= 20
            agua -= 25
            sustentabilidade -= 15
            eficiencia -= 10
        elif rs.status == "atencao":
            eficiencia -= 8
            comportamento -= 10
            energia -= 8
            sustentabilidade -= 5

    clamp = lambda v: max(0, min(100, round(v)))
    cats = {
        "energia": clamp(energia),
        "agua": clamp(agua),
        "eficiencia": clamp(eficiencia),
        "seguranca": clamp(seguranca),
        "sustentabilidade": clamp(sustentabilidade),
        "comportamento": clamp(comportamento),
    }
    overall = round(sum(cats.values()) / len(cats))
    return {"overall": overall, **cats}
