from motor.motor_asyncio import AsyncIOMotorClient
from app.config import settings

mongo_client = AsyncIOMotorClient(settings.mongo_url)
mongo_db = mongo_client[settings.mongo_db]

# Coleções (seção 30 do briefing)
sensor_readings = mongo_db["sensor_readings"]   # leitura crua de cada sensor
telemetry = mongo_db["telemetry"]               # snapshot periódico da casa inteira
events = mongo_db["events"]                     # eventos de negócio (alerta aberto/fechado, automação)
device_logs = mongo_db["device_logs"]           # histórico de comandos em dispositivos
simulation_events = mongo_db["simulation_events"]  # disparos do simulador (uso ExpoTech)
