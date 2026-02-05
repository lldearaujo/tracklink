import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL || 'http://localhost:8000';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

export const linksAPI = {
  create: (linkData) => api.post('/api/links', linkData),
  list: (params = {}) => api.get('/api/links', { params }),
  get: (linkId) => api.get(`/api/links/${linkId}`),
  delete: (linkId) => api.delete(`/api/links/${linkId}`),
};

export const analyticsAPI = {
  get: (params = {}) => api.get('/api/analytics', { params }),
  getByLink: (linkId, params = {}) => api.get(`/api/analytics/link/${linkId}`, { params }),
};

export default api;
