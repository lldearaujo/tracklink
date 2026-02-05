"""
Pydantic schemas for Link model
"""
from pydantic import BaseModel, HttpUrl, Field
from datetime import datetime
from typing import Optional


class LinkCreate(BaseModel):
    """
    Schema for creating a new link
    """
    identifier: str = Field(..., min_length=1, max_length=100, description="Identificador único do link")
    destination_url: HttpUrl = Field(..., description="URL de destino para redirecionamento")
    ponto_dooh: str = Field(..., min_length=1, max_length=200, description="Ponto DOOH")
    campanha: str = Field(..., min_length=1, max_length=200, description="Campanha do cliente")
    
    class Config:
        json_schema_extra = {
            "example": {
                "identifier": "promo-verao-2024",
                "destination_url": "https://example.com/promocao",
                "ponto_dooh": "Shopping Center Norte",
                "campanha": "Campanha Verão 2024"
            }
        }


class LinkResponse(BaseModel):
    """
    Schema for link response
    """
    id: int
    identifier: str
    destination_url: str
    ponto_dooh: str
    campanha: str
    created_at: datetime
    updated_at: datetime
    total_clicks: Optional[int] = 0
    
    class Config:
        from_attributes = True


class LinkList(BaseModel):
    """
    Schema for list of links
    """
    links: list[LinkResponse]
    total: int
