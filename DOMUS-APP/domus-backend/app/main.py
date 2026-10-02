from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.routers import rooms, devices, alerts, score, automations, simulate

app = FastAPI(
    title="DOMUS AI API",
    description="Backend do gêmeo digital residencial — alimenta o site e o futuro app mobile.",
    version="0.1.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=[settings.frontend_origin, "http://localhost:5173", "http://localhost:3000"],
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(rooms.router)
app.include_router(devices.router)
app.include_router(alerts.router)
app.include_router(score.router)
app.include_router(automations.router)
app.include_router(simulate.router)


@app.get("/health")
def health():
    return {"status": "ok", "service": "domus-ai-api"}
