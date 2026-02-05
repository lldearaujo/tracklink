"""
Pydantic schemas for Analytics
"""
from pydantic import BaseModel
from typing import Optional, Dict, List
from datetime import datetime


class LinkAnalytics(BaseModel):
    """
    Analytics for a specific link
    """
    link_id: int
    identifier: str
    total_clicks: int
    unique_ips: int
    clicks_by_device: Dict[str, int]
    clicks_by_browser: Dict[str, int]
    clicks_by_country: Dict[str, int]
    clicks_by_day: Dict[str, int]
    first_click: Optional[datetime]
    last_click: Optional[datetime]


class AnalyticsResponse(BaseModel):
    """
    General analytics response
    """
    total_links: int
    total_clicks: int
    unique_ips: int
    clicks_by_ponto: Dict[str, int]
    clicks_by_campanha: Dict[str, int]
    clicks_by_device: Dict[str, int]
    clicks_by_country: Dict[str, int]
    clicks_by_day: Dict[str, int]
    top_links: List[LinkAnalytics]
    period_start: Optional[datetime]
    period_end: Optional[datetime]
