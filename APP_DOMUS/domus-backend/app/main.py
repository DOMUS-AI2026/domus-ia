from fastapi import FastAPI, WebSocket, WebSocketDisconnect
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings
from app.ws_manager import manager
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


@app.websocket("/ws/homes/{home_id}")
async def ws_home(websocket: WebSocket, home_id: int):
    """
    O cliente só escuta — quando chega {"type":"rooms_changed"} (ou "alerts_changed",
    "score_changed"...), ele re-busca o endpoint REST correspondente. Isso evita ter
    que serializar e manter dois formatos de estado (WS e REST) sincronizados.
    """
    await manager.connect(home_id, websocket)
    try:
        while True:
            await websocket.receive_text()  # mantém a conexão viva; conteúdo ignorado
    except WebSocketDisconnect:
        manager.disconnect(home_id, websocket)
