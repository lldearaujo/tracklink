"""
API endpoints for link management
"""
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List
from app.core.database import get_db
from app.models.link import Link
from app.models.click import Click
from app.schemas.link import LinkCreate, LinkResponse, LinkList

router = APIRouter()


@router.post("/", response_model=LinkResponse, status_code=status.HTTP_201_CREATED)
async def create_link(link_data: LinkCreate, db: Session = Depends(get_db)):
    """
    Create a new trackable link
    """
    # Check if identifier already exists
    existing_link = db.query(Link).filter(Link.identifier == link_data.identifier).first()
    if existing_link:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f"Link com identificador '{link_data.identifier}' já existe"
        )
    
    # Create new link
    link = Link(
        identifier=link_data.identifier,
        destination_url=str(link_data.destination_url),
        ponto_dooh=link_data.ponto_dooh,
        campanha=link_data.campanha
    )
    
    db.add(link)
    db.commit()
    db.refresh(link)
    
    # Get total clicks
    total_clicks = db.query(func.count(Click.id)).filter(Click.link_id == link.id).scalar()
    
    response = LinkResponse.model_validate(link)
    response.total_clicks = total_clicks
    
    return response


@router.get("/", response_model=LinkList)
async def list_links(
    skip: int = 0,
    limit: int = 100,
    ponto_dooh: str = None,
    campanha: str = None,
    db: Session = Depends(get_db)
):
    """
    List all links with optional filters
    """
    query = db.query(Link)
    
    if ponto_dooh:
        query = query.filter(Link.ponto_dooh == ponto_dooh)
    
    if campanha:
        query = query.filter(Link.campanha == campanha)
    
    total = query.count()
    links = query.offset(skip).limit(limit).all()
    
    # Add total clicks to each link
    link_responses = []
    for link in links:
        total_clicks = db.query(func.count(Click.id)).filter(Click.link_id == link.id).scalar()
        response = LinkResponse.model_validate(link)
        response.total_clicks = total_clicks
        link_responses.append(response)
    
    return LinkList(links=link_responses, total=total)


@router.get("/{link_id}", response_model=LinkResponse)
async def get_link(link_id: int, db: Session = Depends(get_db)):
    """
    Get a specific link by ID
    """
    link = db.query(Link).filter(Link.id == link_id).first()
    
    if not link:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Link com ID {link_id} não encontrado"
        )
    
    # Get total clicks
    total_clicks = db.query(func.count(Click.id)).filter(Click.link_id == link.id).scalar()
    
    response = LinkResponse.model_validate(link)
    response.total_clicks = total_clicks
    
    return response


@router.delete("/{link_id}", status_code=status.HTTP_204_NO_CONTENT)
async def delete_link(link_id: int, db: Session = Depends(get_db)):
    """
    Delete a link and all its clicks
    """
    link = db.query(Link).filter(Link.id == link_id).first()
    
    if not link:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"Link com ID {link_id} não encontrado"
        )
    
    db.delete(link)
    db.commit()
    
    return None
