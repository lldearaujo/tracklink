"""
Application configuration
"""
from pydantic_settings import BaseSettings
from typing import Optional, List, Union


class Settings(BaseSettings):
    """
    Application settings
    """
    # API Settings
    API_V1_STR: str = "/api"
    PROJECT_NAME: str = "Link Tracking System"
    
    # Database - PostgreSQL
    # Will be loaded from .env file or use default
    # Senha correta: S3v3r1n0_o1 (com 'o' minusculo)
    DATABASE_URL: str = "postgresql://tracking:S3v3r1n0_o1@72.60.63.29:32541/bd_tracking?sslmode=disable"
    
    # Security
    SECRET_KEY: str = "your-secret-key-change-in-production"
    
    # CORS - pode ser lista ou string separada por vírgulas
    CORS_ORIGINS: Union[List[str], str] = [
        "http://localhost:3000",
        "http://localhost:3001",
        "https://tracklink.ideiasobria.online",
        "https://docs.tracklink.ideiasobria.online",
        "https://dashboard.tracklink.ideiasobria.online",
    ]
    
    @property
    def cors_origins_list(self) -> List[str]:
        """Retorna CORS_ORIGINS como lista, convertendo string se necessário"""
        if isinstance(self.CORS_ORIGINS, str):
            return [origin.strip() for origin in self.CORS_ORIGINS.split(",")]
        return self.CORS_ORIGINS
    
    # GeoIP (optional - for location tracking)
    GEOIP_ENABLED: bool = False
    GEOIP_DB_PATH: Optional[str] = None
    
    class Config:
        env_file = ".env"
        case_sensitive = True


settings = Settings()
