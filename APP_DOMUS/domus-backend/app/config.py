from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    mysql_url: str = "mysql+pymysql://domus_user:domus_pass@localhost:3306/domus_ai"
    mongo_url: str = "mongodb://localhost:27017"
    mongo_db: str = "domus_ai"
    frontend_origin: str = "http://localhost:5173"

    class Config:
        env_file = ".env"

settings = Settings()
