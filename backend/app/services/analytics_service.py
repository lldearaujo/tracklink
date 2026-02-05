"""
Service for analytics and statistics
"""
from datetime import datetime, timedelta
from typing import Optional, Dict, List
from sqlalchemy import func, distinct
from sqlalchemy.orm import Session
from app.models.link import Link
from app.models.click import Click
from app.schemas.analytics import AnalyticsResponse, LinkAnalytics


class AnalyticsService:
    """
    Service for generating analytics and statistics
    """
    
    @staticmethod
    def get_link_analytics(
        db: Session,
        link_id: Optional[int] = None,
        ponto_dooh: Optional[str] = None,
        campanha: Optional[str] = None,
        start_date: Optional[datetime] = None,
        end_date: Optional[datetime] = None
    ) -> AnalyticsResponse:
        """
        Get comprehensive analytics with filters
        """
        # Base query for clicks
        clicks_query = db.query(Click)
        
        # Apply filters
        if link_id:
            clicks_query = clicks_query.filter(Click.link_id == link_id)
        
        if start_date:
            clicks_query = clicks_query.filter(Click.clicked_at >= start_date)
        
        if end_date:
            clicks_query = clicks_query.filter(Click.clicked_at <= end_date)
        
        # Get all clicks
        all_clicks = clicks_query.all()
        
        # Base query for links
        links_query = db.query(Link)
        if ponto_dooh:
            links_query = links_query.filter(Link.ponto_dooh == ponto_dooh)
        if campanha:
            links_query = links_query.filter(Link.campanha == campanha)
        
        # Get filtered links
        filtered_links = links_query.all()
        link_ids = [link.id for link in filtered_links]
        
        # Filter clicks by link_ids if filters applied
        if link_ids:
            all_clicks = [c for c in all_clicks if c.link_id in link_ids]
        
        # Calculate statistics
        total_clicks = len(all_clicks)
        unique_ips = len(set(c.ip_address for c in all_clicks if c.ip_address))
        
        # Clicks by ponto
        clicks_by_ponto: Dict[str, int] = {}
        for click in all_clicks:
            ponto = click.link.ponto_dooh
            clicks_by_ponto[ponto] = clicks_by_ponto.get(ponto, 0) + 1
        
        # Clicks by campanha
        clicks_by_campanha: Dict[str, int] = {}
        for click in all_clicks:
            campanha_name = click.link.campanha
            clicks_by_campanha[campanha_name] = clicks_by_campanha.get(campanha_name, 0) + 1
        
        # Clicks by device
        clicks_by_device: Dict[str, int] = {}
        for click in all_clicks:
            device = click.device_type or "unknown"
            clicks_by_device[device] = clicks_by_device.get(device, 0) + 1
        
        # Clicks by country
        clicks_by_country: Dict[str, int] = {}
        for click in all_clicks:
            country = click.country or "unknown"
            clicks_by_country[country] = clicks_by_country.get(country, 0) + 1
        
        # Clicks by day
        clicks_by_day: Dict[str, int] = {}
        for click in all_clicks:
            day = click.clicked_at.strftime("%Y-%m-%d")
            clicks_by_day[day] = clicks_by_day.get(day, 0) + 1
        
        # Get top links
        top_links = AnalyticsService._get_top_links(db, filtered_links, all_clicks)
        
        return AnalyticsResponse(
            total_links=len(filtered_links),
            total_clicks=total_clicks,
            unique_ips=unique_ips,
            clicks_by_ponto=clicks_by_ponto,
            clicks_by_campanha=clicks_by_campanha,
            clicks_by_device=clicks_by_device,
            clicks_by_country=clicks_by_country,
            clicks_by_day=clicks_by_day,
            top_links=top_links,
            period_start=start_date,
            period_end=end_date
        )
    
    @staticmethod
    def _get_top_links(
        db: Session,
        links: List[Link],
        clicks: List[Click]
    ) -> List[LinkAnalytics]:
        """
        Get analytics for top links
        """
        top_links_data = []
        
        for link in links:
            link_clicks = [c for c in clicks if c.link_id == link.id]
            
            if not link_clicks:
                continue
            
            # Calculate link-specific stats
            unique_ips = len(set(c.ip_address for c in link_clicks if c.ip_address))
            
            clicks_by_device: Dict[str, int] = {}
            for click in link_clicks:
                device = click.device_type or "unknown"
                clicks_by_device[device] = clicks_by_device.get(device, 0) + 1
            
            clicks_by_browser: Dict[str, int] = {}
            for click in link_clicks:
                browser = click.browser or "unknown"
                clicks_by_browser[browser] = clicks_by_browser.get(browser, 0) + 1
            
            clicks_by_country: Dict[str, int] = {}
            for click in link_clicks:
                country = click.country or "unknown"
                clicks_by_country[country] = clicks_by_country.get(country, 0) + 1
            
            clicks_by_day: Dict[str, int] = {}
            for click in link_clicks:
                day = click.clicked_at.strftime("%Y-%m-%d")
                clicks_by_day[day] = clicks_by_day.get(day, 0) + 1
            
            first_click = min(c.clicked_at for c in link_clicks)
            last_click = max(c.clicked_at for c in link_clicks)
            
            top_links_data.append(LinkAnalytics(
                link_id=link.id,
                identifier=link.identifier,
                total_clicks=len(link_clicks),
                unique_ips=unique_ips,
                clicks_by_device=clicks_by_device,
                clicks_by_browser=clicks_by_browser,
                clicks_by_country=clicks_by_country,
                clicks_by_day=clicks_by_day,
                first_click=first_click,
                last_click=last_click
            ))
        
        # Sort by total clicks descending
        top_links_data.sort(key=lambda x: x.total_clicks, reverse=True)
        
        return top_links_data[:10]  # Return top 10
