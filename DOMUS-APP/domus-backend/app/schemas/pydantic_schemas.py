from pydantic import BaseModel
from typing import Optional, Literal
from datetime import datetime

Status = Literal["normal", "atencao", "critico", "equipamento"]

class SensorOut(BaseModel):
    key_name: str
    label: str
    unit: Optional[str] = None
    last_value: str
    last_status: Status
    class Config: from_attributes = True

class DeviceOut(BaseModel):
    key_name: str
    label: str
    state: str
    on_value: str
    off_value: str
    class Config: from_attributes = True

class RoomOut(BaseModel):
    id: int
    slug: str
    name: str
    area_m2: float
    pos_x: float
    pos_z: float
    width_m: float
    depth_m: float
    status: Status = "normal"
    sensors: list[SensorOut] = []
    devices: list[DeviceOut] = []
    class Config: from_attributes = True

class DeviceCommand(BaseModel):
    action: Literal["on", "off", "toggle"]
    issued_by: Literal["user", "automation"] = "user"

class AlertOut(BaseModel):
    id: int
    room_id: int
    status: Literal["atencao", "critico"]
    message: str
    created_at: datetime
    resolved_at: Optional[datetime] = None
    class Config: from_attributes = True

class ScoreOut(BaseModel):
    overall: int
    energia: int
    agua: int
    eficiencia: int
    seguranca: int
    sustentabilidade: int
    comportamento: int
    computed_at: datetime
    class Config: from_attributes = True

class AutomationRuleOut(BaseModel):
    rule_key: str
    label: str
    enabled: bool
    class Config: from_attributes = True

class SimulationRequest(BaseModel):
    scenario: Literal[
        "vazamento", "alto_consumo", "ar_sem_presenca",
        "luz_sem_presenca", "porta_aberta", "consumo_normal", "restaurar"
    ]
    room_slug: Optional[str] = None
