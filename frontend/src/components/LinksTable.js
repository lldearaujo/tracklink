import React from 'react';
import { format } from 'date-fns';
import ptBR from 'date-fns/locale/pt-BR';
import './LinksTable.css';

function LinksTable({ links, onDelete }) {
  const getTrackingUrl = (identifier) => {
    const baseUrl = window.location.origin.replace(':3000', ':8000');
    return `${baseUrl}/r/${identifier}`;
  };

  const copyToClipboard = (text) => {
    navigator.clipboard.writeText(text);
    alert('Link copiado para a área de transferência!');
  };

  if (links.length === 0) {
    return (
      <div className="empty-state">
        <p>Nenhum link cadastrado ainda.</p>
        <a href="/create" className="btn-primary">
          Criar Primeiro Link
        </a>
      </div>
    );
  }

  return (
    <div className="links-table-container">
      <table className="links-table">
        <thead>
          <tr>
            <th>Identificador</th>
            <th>Ponto DOOH</th>
            <th>Campanha</th>
            <th>URL de Destino</th>
            <th>Link Rastreável</th>
            <th>Cliques</th>
            <th>Criado em</th>
            <th>Ações</th>
          </tr>
        </thead>
        <tbody>
          {links.map((link) => (
            <tr key={link.id}>
              <td>
                <strong>{link.identifier}</strong>
              </td>
              <td>{link.ponto_dooh}</td>
              <td>{link.campanha}</td>
              <td>
                <a
                  href={link.destination_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="url-link"
                >
                  {link.destination_url.length > 40
                    ? `${link.destination_url.substring(0, 40)}...`
                    : link.destination_url}
                </a>
              </td>
              <td>
                <div className="tracking-url">
                  <code>{getTrackingUrl(link.identifier)}</code>
                  <button
                    onClick={() => copyToClipboard(getTrackingUrl(link.identifier))}
                    className="btn-copy"
                    title="Copiar link"
                  >
                    📋
                  </button>
                </div>
              </td>
              <td>
                <span className="clicks-badge">{link.total_clicks || 0}</span>
              </td>
              <td>
                {format(new Date(link.created_at), "dd/MM/yyyy 'às' HH:mm", {
                  locale: ptBR,
                })}
              </td>
              <td>
                <button
                  onClick={() => onDelete(link.id)}
                  className="btn-delete"
                  title="Excluir link"
                >
                  🗑️
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}

export default LinksTable;
