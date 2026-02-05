"""
API endpoints for analytics and statistics
"""
from fastapi import APIRouter, Depends, Query
from datetime import datetime
from typing import Optional
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.schemas.analytics import AnalyticsResponse, LinkAnalytics
from app.services.analytics_service import AnalyticsService

router = APIRouter()


@router.get("/", response_model=AnalyticsResponse)
async def get_analytics(
    ponto_dooh: Optional[str] = Query(None, description="Filtrar por ponto DOOH"),
    campanha: Optional[str] = Query(None, description="Filtrar por campanha"),
    link_id: Optional[int] = Query(None, description="Filtrar por ID do link"),
    start_date: Optional[str] = Query(None, description="Data inicial (YYYY-MM-DD)"),
    end_date: Optional[str] = Query(None, description="Data final (YYYY-MM-DD)"),
    db: Session = Depends(get_db)
):
    """
    Get comprehensive analytics with filters
    """
    # Parse dates
    start_datetime = None
    end_datetime = None
    
    if start_date:
        try:
            start_datetime = datetime.strptime(start_date, "%Y-%m-%d")
        except ValueError:
            start_datetime = None
    
    if end_date:
        try:
            end_datetime = datetime.strptime(end_date, "%Y-%m-%d")
            # Set to end of day
            end_datetime = end_datetime.replace(hour=23, minute=59, second=59)
        except ValueError:
            end_datetime = None
    
    analytics = AnalyticsService.get_link_analytics(
        db=db,
        link_id=link_id,
        ponto_dooh=ponto_dooh,
        campanha=campanha,
        start_date=start_datetime,
        end_date=end_datetime
    )
    
    return analytics


@router.get("/link/{link_id}", response_model=LinkAnalytics)
async def get_link_analytics(
    link_id: int,
    start_date: Optional[str] = Query(None, description="Data inicial (YYYY-MM-DD)"),
    end_date: Optional[str] = Query(None, description="Data final (YYYY-MM-DD)"),
    db: Session = Depends(get_db)
):
    """
    Get analytics for a specific link
    """
    # Parse dates
    start_datetime = None
    end_datetime = None
    
    if start_date:
        try:
            start_datetime = datetime.strptime(start_date, "%Y-%m-%d")
        except ValueError:
            start_datetime = None
    
    if end_date:
        try:
            end_datetime = datetime.strptime(end_date, "%Y-%m-%d")
            end_datetime = end_datetime.replace(hour=23, minute=59, second=59)
        except ValueError:
            end_datetime = None
    
    analytics = AnalyticsService.get_link_analytics(
        db=db,
        link_id=link_id,
        start_date=start_datetime,
        end_date=end_datetime
    )
    
    # Return first link analytics (should be only one)
    if analytics.top_links:
        return analytics.top_links[0]
    
    # If no clicks, return empty analytics
    from app.models.link import Link
    link = db.query(Link).filter(Link.id == link_id).first()
    if not link:
        from fastapi import HTTPException, status
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Link com ID {link_id} não encontrado"
        )
    
    return LinkAnalytics(
        link_id=link.id,
        identifier=link.identifier,
        total_clicks=0,
        unique_ips=0,
        clicks_by_device={},
        clicks_by_browser={},
        clicks_by_country={},
        clicks_by_day={},
        first_click=None,
        last_click=None
    )
