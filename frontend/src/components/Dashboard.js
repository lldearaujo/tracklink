import React, { useState, useEffect } from 'react';
import { linksAPI, analyticsAPI } from '../services/api';
import AnalyticsCharts from './AnalyticsCharts';
import LinksTable from './LinksTable';
import Filters from './Filters';
import './Dashboard.css';

function Dashboard() {
  const [links, setLinks] = useState([]);
  const [analytics, setAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [filters, setFilters] = useState({
    ponto_dooh: '',
    campanha: '',
    start_date: '',
    end_date: '',
  });

  useEffect(() => {
    loadData();
  }, [filters]);

  const loadData = async () => {
    setLoading(true);
    try {
      const [linksResponse, analyticsResponse] = await Promise.all([
        linksAPI.list(filters),
        analyticsAPI.get(filters),
      ]);
      setLinks(linksResponse.data.links);
      setAnalytics(analyticsResponse.data);
    } catch (error) {
      console.error('Erro ao carregar dados:', error);
      // Se for erro 500, pode ser problema de banco de dados
      if (error.response?.status === 500) {
        alert('Erro ao conectar com o banco de dados. Verifique as credenciais em backend/.env');
      } else {
        alert('Erro ao carregar dados. Verifique se o backend está rodando.');
      }
    } finally {
      setLoading(false);
    }
  };

  const handleDeleteLink = async (linkId) => {
    if (!window.confirm('Tem certeza que deseja excluir este link?')) {
      return;
    }

    try {
      await linksAPI.delete(linkId);
      loadData();
    } catch (error) {
      console.error('Erro ao excluir link:', error);
      alert('Erro ao excluir link.');
    }
  };

  const handleFilterChange = (newFilters) => {
    setFilters(newFilters);
  };

  if (loading) {
    return (
      <div className="dashboard-loading">
        <div className="spinner"></div>
        <p>Carregando dados...</p>
      </div>
    );
  }

  return (
    <div className="dashboard">
      <div className="dashboard-header">
        <h2>Dashboard de Métricas</h2>
        <a href="/create" className="btn-primary">
          + Criar Novo Link
        </a>
      </div>

      <Filters filters={filters} onFilterChange={handleFilterChange} />

      {analytics && (
        <div className="stats-grid">
          <div className="stat-card">
            <h3>Total de Links</h3>
            <p className="stat-value">{analytics.total_links}</p>
          </div>
          <div className="stat-card">
            <h3>Total de Cliques</h3>
            <p className="stat-value">{analytics.total_clicks}</p>
          </div>
          <div className="stat-card">
            <h3>IPs Únicos</h3>
            <p className="stat-value">{analytics.unique_ips}</p>
          </div>
        </div>
      )}

      {analytics && <AnalyticsCharts analytics={analytics} />}

      <div className="links-section">
        <h2>Links Cadastrados</h2>
        <LinksTable links={links} onDelete={handleDeleteLink} />
      </div>
    </div>
  );
}

export default Dashboard;
