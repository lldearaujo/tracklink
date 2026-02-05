import React, { useState, useEffect } from 'react';
import './Filters.css';

function Filters({ filters, onFilterChange }) {
  const [localFilters, setLocalFilters] = useState(filters);

  useEffect(() => {
    setLocalFilters(filters);
  }, [filters]);

  const handleChange = (field, value) => {
    const newFilters = { ...localFilters, [field]: value };
    setLocalFilters(newFilters);
  };

  const handleApply = () => {
    onFilterChange(localFilters);
  };

  const handleClear = () => {
    const clearedFilters = {
      ponto_dooh: '',
      campanha: '',
      start_date: '',
      end_date: '',
    };
    setLocalFilters(clearedFilters);
    onFilterChange(clearedFilters);
  };

  return (
    <div className="filters">
      <h3>Filtros</h3>
      <div className="filters-grid">
        <div className="filter-group">
          <label>Ponto DOOH</label>
          <input
            type="text"
            value={localFilters.ponto_dooh}
            onChange={(e) => handleChange('ponto_dooh', e.target.value)}
            placeholder="Ex: Shopping Center Norte"
          />
        </div>
        <div className="filter-group">
          <label>Campanha</label>
          <input
            type="text"
            value={localFilters.campanha}
            onChange={(e) => handleChange('campanha', e.target.value)}
            placeholder="Ex: Campanha Verão 2024"
          />
        </div>
        <div className="filter-group">
          <label>Data Inicial</label>
          <input
            type="date"
            value={localFilters.start_date}
            onChange={(e) => handleChange('start_date', e.target.value)}
          />
        </div>
        <div className="filter-group">
          <label>Data Final</label>
          <input
            type="date"
            value={localFilters.end_date}
            onChange={(e) => handleChange('end_date', e.target.value)}
          />
        </div>
      </div>
      <div className="filters-actions">
        <button onClick={handleApply} className="btn-apply">
          Aplicar Filtros
        </button>
        <button onClick={handleClear} className="btn-clear">
          Limpar
        </button>
      </div>
    </div>
  );
}

export default Filters;
