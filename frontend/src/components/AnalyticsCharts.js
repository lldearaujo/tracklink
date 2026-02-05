import React from 'react';
import {
  BarChart,
  Bar,
  PieChart,
  Pie,
  Cell,
  LineChart,
  Line,
  XAxis,
  YAxis,
  CartesianGrid,
  Tooltip,
  Legend,
  ResponsiveContainer,
} from 'recharts';
import './AnalyticsCharts.css';

const COLORS = ['#667eea', '#764ba2', '#f093fb', '#4facfe', '#43e97b', '#fa709a'];

function AnalyticsCharts({ analytics }) {
  // Prepare data for charts
  const pontoData = Object.entries(analytics.clicks_by_ponto || {}).map(([name, value]) => ({
    name,
    value,
  }));

  const campanhaData = Object.entries(analytics.clicks_by_campanha || {}).map(([name, value]) => ({
    name,
    value,
  }));

  const deviceData = Object.entries(analytics.clicks_by_device || {}).map(([name, value]) => ({
    name,
    value,
  }));

  const countryData = Object.entries(analytics.clicks_by_country || {})
    .slice(0, 10)
    .map(([name, value]) => ({
      name,
      value,
    }));

  const dayData = Object.entries(analytics.clicks_by_day || {})
    .sort(([a], [b]) => a.localeCompare(b))
    .map(([name, value]) => ({
      name: new Date(name).toLocaleDateString('pt-BR', { day: '2-digit', month: '2-digit' }),
      value,
    }));

  return (
    <div className="analytics-charts">
      <div className="charts-grid">
        {dayData.length > 0 && (
          <div className="chart-card">
            <h3>Cliques por Dia</h3>
            <ResponsiveContainer width="100%" height={300}>
              <LineChart data={dayData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" />
                <YAxis />
                <Tooltip />
                <Legend />
                <Line type="monotone" dataKey="value" stroke="#667eea" strokeWidth={2} />
              </LineChart>
            </ResponsiveContainer>
          </div>
        )}

        {pontoData.length > 0 && (
          <div className="chart-card">
            <h3>Cliques por Ponto DOOH</h3>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={pontoData}>
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis dataKey="name" angle={-45} textAnchor="end" height={100} />
                <YAxis />
                <Tooltip />
                <Bar dataKey="value" fill="#667eea" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}

        {campanhaData.length > 0 && (
          <div className="chart-card">
            <h3>Cliques por Campanha</h3>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={campanhaData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                  outerRadius={100}
                  fill="#8884d8"
                  dataKey="value"
                >
                  {campanhaData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        )}

        {deviceData.length > 0 && (
          <div className="chart-card">
            <h3>Cliques por Dispositivo</h3>
            <ResponsiveContainer width="100%" height={300}>
              <PieChart>
                <Pie
                  data={deviceData}
                  cx="50%"
                  cy="50%"
                  labelLine={false}
                  label={({ name, percent }) => `${name}: ${(percent * 100).toFixed(0)}%`}
                  outerRadius={100}
                  fill="#8884d8"
                  dataKey="value"
                >
                  {deviceData.map((entry, index) => (
                    <Cell key={`cell-${index}`} fill={COLORS[index % COLORS.length]} />
                  ))}
                </Pie>
                <Tooltip />
              </PieChart>
            </ResponsiveContainer>
          </div>
        )}

        {countryData.length > 0 && (
          <div className="chart-card">
            <h3>Top 10 Países</h3>
            <ResponsiveContainer width="100%" height={300}>
              <BarChart data={countryData} layout="vertical">
                <CartesianGrid strokeDasharray="3 3" />
                <XAxis type="number" />
                <YAxis dataKey="name" type="category" width={100} />
                <Tooltip />
                <Bar dataKey="value" fill="#764ba2" />
              </BarChart>
            </ResponsiveContainer>
          </div>
        )}
      </div>
    </div>
  );
}

export default AnalyticsCharts;
