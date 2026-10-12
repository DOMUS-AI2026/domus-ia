from sqlalchemy import (Column, Integer, String, Boolean, DECIMAL, Enum,
                         TIMESTAMP, ForeignKey, func)
from sqlalchemy.orm import relationship
from app.database import Base

class Home(Base):
    __tablename__ = "homes"
    id = Column(Integer, primary_key=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    name = Column(String(120), default="Minha Casa")
    area_m2 = Column(DECIMAL(6, 2), nullable=False)
    width_m = Column(DECIMAL(5, 2), nullable=False)
    depth_m = Column(DECIMAL(5, 2), nullable=False)
    rooms = relationship("Room", back_populates="home", cascade="all, delete")

class Room(Base):
    __tablename__ = "rooms"
    id = Column(Integer, primary_key=True)
    home_id = Column(Integer, ForeignKey("homes.id"))
    slug = Column(String(40), nullable=False)     # 'banheiro', 'quarto1'...
    name = Column(String(80), nullable=False)
    area_m2 = Column(DECIMAL(6, 2), nullable=False)
    pos_x = Column(DECIMAL(6, 2), nullable=False)
    pos_z = Column(DECIMAL(6, 2), nullable=False)
    width_m = Column(DECIMAL(6, 2), nullable=False)
    depth_m = Column(DECIMAL(6, 2), nullable=False)

    home = relationship("Home", back_populates="rooms")
    sensors = relationship("Sensor", back_populates="room", cascade="all, delete")
    devices = relationship("Device", back_populates="room", cascade="all, delete")
    status = relationship("RoomStatus", back_populates="room", uselist=False, cascade="all, delete")

class Sensor(Base):
    __tablename__ = "sensors"
    id = Column(Integer, primary_key=True)
    room_id = Column(Integer, ForeignKey("rooms.id"))
    key_name = Column(String(40), nullable=False)   # 'temp','agua','vazamento'...
    label = Column(String(80), nullable=False)
    unit = Column(String(20))
    last_value = Column(String(40), nullable=False)
    last_status = Column(Enum("normal", "atencao", "critico", "equipamento"), default="normal")
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    room = relationship("Room", back_populates="sensors")

class Device(Base):
    __tablename__ = "devices"
    id = Column(Integer, primary_key=True)
    room_id = Column(Integer, ForeignKey("rooms.id"))
    key_name = Column(String(40), nullable=False)   # 'luz','valvula','maquina'...
    label = Column(String(80), nullable=False)
    state = Column(String(40), nullable=False)
    on_value = Column(String(40), nullable=False)
    off_value = Column(String(40), nullable=False)
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    room = relationship("Room", back_populates="devices")

class RoomStatus(Base):
    __tablename__ = "room_status"
    id = Column(Integer, primary_key=True)
    room_id = Column(Integer, ForeignKey("rooms.id"), unique=True)
    status = Column(Enum("normal", "atencao", "critico", "equipamento"), default="normal")
    updated_at = Column(TIMESTAMP, server_default=func.now(), onupdate=func.now())

    room = relationship("Room", back_populates="status")

class Automation(Base):
    __tablename__ = "automations"
    id = Column(Integer, primary_key=True)
    home_id = Column(Integer, ForeignKey("homes.id"))
    rule_key = Column(String(40), nullable=False)   # 'valve','light','clima'
    label = Column(String(160), nullable=False)
    enabled = Column(Boolean, default=True)

class Alert(Base):
    __tablename__ = "alerts"
    id = Column(Integer, primary_key=True)
    home_id = Column(Integer, ForeignKey("homes.id"))
    room_id = Column(Integer, ForeignKey("rooms.id"))
    status = Column(Enum("atencao", "critico"), nullable=False)
    message = Column(String(255), nullable=False)
    resolved_by = Column(Enum("manual", "automation"), nullable=True)
    created_at = Column(TIMESTAMP, server_default=func.now())
    resolved_at = Column(TIMESTAMP, nullable=True)

class Command(Base):
    __tablename__ = "commands"
    id = Column(Integer, primary_key=True)
    device_id = Column(Integer, ForeignKey("devices.id"))
    action = Column(String(40), nullable=False)
    issued_by = Column(Enum("user", "automation"), nullable=False)
    issued_at = Column(TIMESTAMP, server_default=func.now())
    result = Column(String(40), default="ok")

class DomusScore(Base):
    __tablename__ = "domus_score"
    id = Column(Integer, primary_key=True)
    home_id = Column(Integer, ForeignKey("homes.id"))
    overall = Column(Integer, nullable=False)
    energia = Column(Integer, nullable=False)
    agua = Column(Integer, nullable=False)
    eficiencia = Column(Integer, nullable=False)
    seguranca = Column(Integer, nullable=False)
    sustentabilidade = Column(Integer, nullable=False)
    comportamento = Column(Integer, nullable=False)
    computed_at = Column(TIMESTAMP, server_default=func.now())
