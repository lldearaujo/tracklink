"""
API endpoints for link tracking and redirection
"""
from fastapi import APIRouter, Depends, HTTPException, Request, status
from fastapi.responses import RedirectResponse
from sqlalchemy.orm import Session
from app.core.database import get_db
from app.models.link import Link
from app.services.tracking_service import TrackingService

router = APIRouter()


@router.get("/{identifier}")
async def track_and_redirect(
    identifier: str,
    request: Request,
    db: Session = Depends(get_db)
):
    """
    Track click and redirect to destination URL
    """
    # Find link by identifier
    link = db.query(Link).filter(Link.identifier == identifier).first()
    
    if not link:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Link com identificador '{identifier}' não encontrado"
        )
    
    # Track the click
    TrackingService.track_click(db, link.id, request)
    
    # Redirect to destination URL
    return RedirectResponse(url=link.destination_url, status_code=status.HTTP_302_FOUND)
