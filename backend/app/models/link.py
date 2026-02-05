"""
Link model - represents a trackable link
"""
from sqlalchemy import Column, Integer, String, DateTime, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from app.core.database import Base


class Link(Base):
    """
    Model for trackable links
    """
    __tablename__ = "links"
    
    id = Column(Integer, primary_key=True, index=True)
    identifier = Column(String(100), unique=True, index=True, nullable=False)
    destination_url = Column(Text, nullable=False)
    ponto_dooh = Column(String(200), nullable=False)
    campanha = Column(String(200), nullable=False)
    created_at = Column(DateTime, default=datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    # Relationship
    clicks = relationship("Click", back_populates="link", cascade="all, delete-orphan")
    
    def __repr__(self):
        return f"<Link(id={self.id}, identifier='{self.identifier}', ponto='{self.ponto_dooh}')>"
