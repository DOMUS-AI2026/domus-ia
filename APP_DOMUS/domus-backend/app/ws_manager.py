from fastapi import WebSocket
from collections import defaultdict


class ConnectionManager:
    """Mantém a lista de clientes conectados por home_id e avisa todos quando algo muda.
    Usado pelo site e, futuramente, pelo app mobile — os dois recebem o mesmo aviso
    e reagem buscando o estado atualizado nos endpoints REST já existentes."""

    def __init__(self):
        self.active: dict[int, list[WebSocket]] = defaultdict(list)

    async def connect(self, home_id: int, ws: WebSocket):
        await ws.accept()
        self.active[home_id].append(ws)

    def disconnect(self, home_id: int, ws: WebSocket):
        if ws in self.active[home_id]:
            self.active[home_id].remove(ws)

    async def broadcast(self, home_id: int, message: dict):
        dead = []
        for ws in self.active[home_id]:
            try:
                await ws.send_json(message)
            except Exception:
                dead.append(ws)
        for ws in dead:
            self.disconnect(home_id, ws)


manager = ConnectionManager()
