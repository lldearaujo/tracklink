"""
Pydantic schemas for Click model
"""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class ClickCreate(BaseModel):
    """
    Schema for creating a click (internal use)
    """
    link_id: int
    ip_address: Optional[str] = None
    user_agent: Optional[str] = None
    referrer: Optional[str] = None
    device_type: Optional[str] = None
    browser: Optional[str] = None
    operating_system: Optional[str] = None
    country: Optional[str] = None
    city: Optional[str] = None


class ClickResponse(BaseModel):
    """
    Schema for click response
    """
    id: int
    link_id: int
    ip_address: Optional[str]
    user_agent: Optional[str]
    referrer: Optional[str]
    device_type: Optional[str]
    browser: Optional[str]
    operating_system: Optional[str]
    country: Optional[str]
    city: Optional[str]
    clicked_at: datetime
    
    class Config:
        from_attributes = True
