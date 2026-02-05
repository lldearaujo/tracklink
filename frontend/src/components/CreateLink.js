import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { linksAPI } from '../services/api';
import './CreateLink.css';

function CreateLink() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    identifier: '',
    destination_url: '',
    ponto_dooh: '',
    campanha: '',
  });
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleChange = (e) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    // Validation
    if (!formData.identifier || !formData.destination_url || !formData.ponto_dooh || !formData.campanha) {
      setError('Por favor, preencha todos os campos.');
      setLoading(false);
      return;
    }

    // Validate URL
    try {
      new URL(formData.destination_url);
    } catch {
      setError('URL de destino inválida. Use o formato: https://exemplo.com');
      setLoading(false);
      return;
    }

    try {
      const response = await linksAPI.create(formData);
      alert('Link criado com sucesso!');
      navigate('/');
    } catch (err) {
      const errorMessage = err.response?.data?.detail || 'Erro ao criar link. Tente novamente.';
      setError(errorMessage);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="create-link">
      <div className="create-link-header">
        <h2>Criar Novo Link Rastreável</h2>
        <a href="/" className="btn-secondary">
          ← Voltar ao Dashboard
        </a>
      </div>

      <div className="create-link-form-container">
        <form onSubmit={handleSubmit} className="create-link-form">
          {error && <div className="error-message">{error}</div>}

          <div className="form-group">
            <label htmlFor="identifier">
              Identificador Único <span className="required">*</span>
            </label>
            <input
              type="text"
              id="identifier"
              name="identifier"
              value={formData.identifier}
              onChange={handleChange}
              placeholder="Ex: promo-verao-2024"
              required
            />
            <small>Use apenas letras, números e hífens. Este será usado no link rastreável.</small>
          </div>

          <div className="form-group">
            <label htmlFor="destination_url">
              URL de Destino <span className="required">*</span>
            </label>
            <input
              type="url"
              id="destination_url"
              name="destination_url"
              value={formData.destination_url}
              onChange={handleChange}
              placeholder="https://exemplo.com/promocao"
              required
            />
            <small>URL completa para onde o usuário será redirecionado.</small>
          </div>

          <div className="form-group">
            <label htmlFor="ponto_dooh">
              Ponto (DOOH) <span className="required">*</span>
            </label>
            <input
              type="text"
              id="ponto_dooh"
              name="ponto_dooh"
              value={formData.ponto_dooh}
              onChange={handleChange}
              placeholder="Ex: Shopping Center Norte"
              required
            />
            <small>Identificação do ponto Digital Out of Home.</small>
          </div>

          <div className="form-group">
            <label htmlFor="campanha">
              Campanha do Cliente <span className="required">*</span>
            </label>
            <input
              type="text"
              id="campanha"
              name="campanha"
              value={formData.campanha}
              onChange={handleChange}
              placeholder="Ex: Campanha Verão 2024"
              required
            />
            <small>Nome da campanha do cliente.</small>
          </div>

          <div className="form-actions">
            <button type="submit" className="btn-submit" disabled={loading}>
              {loading ? 'Criando...' : 'Criar Link'}
            </button>
            <button
              type="button"
              onClick={() => navigate('/')}
              className="btn-cancel"
            >
              Cancelar
            </button>
          </div>
        </form>

        <div className="form-info">
          <h3>Como funciona?</h3>
          <ol>
            <li>Preencha todos os campos do formulário</li>
            <li>O sistema gerará um link rastreável único</li>
            <li>Compartilhe o link (ex: WhatsApp, email, etc.)</li>
            <li>Acompanhe as métricas no dashboard</li>
          </ol>
          <p className="info-note">
            <strong>Exemplo de link gerado:</strong><br />
            <code>http://localhost:8000/r/seu-identificador</code>
          </p>
        </div>
      </div>
    </div>
  );
}

export default CreateLink;
