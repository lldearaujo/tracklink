"""
Click model - represents a click/tracking event
"""
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Text
from sqlalchemy.orm import relationship
from datetime import datetime
from app.core.database import Base


class Click(Base):
    """
    Model for tracking clicks/visits
    """
    __tablename__ = "clicks"
    
    id = Column(Integer, primary_key=True, index=True)
    link_id = Column(Integer, ForeignKey("links.id"), nullable=False, index=True)
    
    # Visitor information
    ip_address = Column(String(45), nullable=True)  # IPv6 can be up to 45 chars
    user_agent = Column(Text, nullable=True)
    referrer = Column(Text, nullable=True)
    
    # Extracted data
    device_type = Column(String(50), nullable=True)  # mobile, desktop, tablet
    browser = Column(String(100), nullable=True)
    operating_system = Column(String(100), nullable=True)
    country = Column(String(100), nullable=True)
    city = Column(String(100), nullable=True)
    
    # Timestamp
    clicked_at = Column(DateTime, default=datetime.utcnow, index=True)
    
    # Relationship
    link = relationship("Link", back_populates="clicks")
    
    def __repr__(self):
        return f"<Click(id={self.id}, link_id={self.link_id}, ip='{self.ip_address}')>"
