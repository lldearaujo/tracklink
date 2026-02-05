"""
Service for tracking clicks and extracting visitor information
"""
from typing import Optional
from user_agents import parse
from fastapi import Request
from app.models.click import Click
from app.schemas.click import ClickCreate
from sqlalchemy.orm import Session


class TrackingService:
    """
    Service for handling click tracking and data extraction
    """
    
    @staticmethod
    def get_client_ip(request: Request) -> str:
        """
        Extract client IP address from request
        """
        # Check for forwarded IP (behind proxy/load balancer)
        forwarded = request.headers.get("X-Forwarded-For")
        if forwarded:
            return forwarded.split(",")[0].strip()
        
        real_ip = request.headers.get("X-Real-IP")
        if real_ip:
            return real_ip
        
        if request.client:
            return request.client.host
        
        return "unknown"
    
    @staticmethod
    def parse_user_agent(user_agent: Optional[str]) -> dict:
        """
        Parse user agent string to extract device, browser, and OS info
        """
        if not user_agent:
            return {
                "device_type": "unknown",
                "browser": "unknown",
                "operating_system": "unknown"
            }
        
        try:
            ua = parse(user_agent)
            
            # Determine device type
            if ua.is_mobile:
                device_type = "mobile"
            elif ua.is_tablet:
                device_type = "tablet"
            else:
                device_type = "desktop"
            
            return {
                "device_type": device_type,
                "browser": f"{ua.browser.family} {ua.browser.version_string}".strip() or "unknown",
                "operating_system": f"{ua.os.family} {ua.os.version_string}".strip() or "unknown"
            }
        except Exception:
            return {
                "device_type": "unknown",
                "browser": "unknown",
                "operating_system": "unknown"
            }
    
    @staticmethod
    def get_location_info(ip_address: str) -> dict:
        """
        Get location information from IP address
        Note: This is a placeholder. For production, use a GeoIP service
        like MaxMind GeoIP2 or ipapi.co
        """
        # TODO: Implement GeoIP lookup
        # For now, return empty location data
        return {
            "country": None,
            "city": None
        }
    
    @staticmethod
    def create_click(db: Session, click_data: ClickCreate) -> Click:
        """
        Create a new click record
        """
        click = Click(**click_data.dict())
        db.add(click)
        db.commit()
        db.refresh(click)
        return click
    
    @staticmethod
    def track_click(db: Session, link_id: int, request: Request) -> Click:
        """
        Track a click with all available information
        """
        # Extract information
        ip_address = TrackingService.get_client_ip(request)
        user_agent = request.headers.get("User-Agent")
        referrer = request.headers.get("Referer")
        
        # Parse user agent
        ua_info = TrackingService.parse_user_agent(user_agent)
        
        # Get location (optional - requires GeoIP service)
        location_info = TrackingService.get_location_info(ip_address)
        
        # Create click data
        click_data = ClickCreate(
            link_id=link_id,
            ip_address=ip_address,
            user_agent=user_agent,
            referrer=referrer,
            device_type=ua_info["device_type"],
            browser=ua_info["browser"],
            operating_system=ua_info["operating_system"],
            country=location_info["country"],
            city=location_info["city"]
        )
        
        # Save click
        return TrackingService.create_click(db, click_data)
