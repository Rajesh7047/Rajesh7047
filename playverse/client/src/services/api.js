import axios from 'axios';

const api = axios.create({
  baseURL: import.meta.env.VITE_API_URL || 'http://localhost:5000/api',
  timeout: 15000,
});

api.interceptors.request.use((config) => {
  const token = localStorage.getItem('pv_token');
  if (token) config.headers.Authorization = `Bearer ${token}`;
  return config;
});

api.interceptors.response.use(
  (res) => res,
  (err) => {
    if (err.response?.status === 401) {
      localStorage.removeItem('pv_token');
      localStorage.removeItem('pv_user');
    }
    return Promise.reject(err);
  }
);

export const authAPI = {
  register: (data) => api.post('/auth/register', data),
  login: (data) => api.post('/auth/login', data),
  getMe: () => api.get('/auth/me'),
  updateProfile: (data) => api.put('/auth/profile', data),
  changePassword: (data) => api.put('/auth/change-password', data),
};

export const gamesAPI = {
  getAll: (params) => api.get('/games', { params }),
  getFeatured: () => api.get('/games/featured'),
  getTopRated: () => api.get('/games/top-rated'),
  getBySlug: (slug) => api.get(`/games/${slug}`),
  search: (q) => api.get('/games/search', { params: { q } }),
  addReview: (id, data) => api.post(`/games/${id}/reviews`, data),
  // Admin
  adminGetAll: () => api.get('/games/admin/all'),
  adminGetById: (id) => api.get(`/games/id/${id}`),
  create: (data) => api.post('/games', data),
  update: (id, data) => api.put(`/games/${id}`, data),
  delete: (id) => api.delete(`/games/${id}`),
};

export const cartAPI = {
  get: () => api.get('/cart'),
  add: (gameId) => api.post('/cart/add', { gameId }),
  remove: (gameId) => api.delete(`/cart/item/${gameId}`),
  clear: () => api.delete('/cart/clear'),
};

export const ordersAPI = {
  create: (data) => api.post('/orders', data),
  getMy: () => api.get('/orders/my'),
  getById: (id) => api.get(`/orders/${id}`),
  // Admin
  adminGetAll: () => api.get('/orders/admin/all'),
  adminGetStats: () => api.get('/orders/admin/stats'),
};

export const wishlistAPI = {
  get: () => api.get('/wishlist'),
  toggle: (gameId) => api.post('/wishlist/toggle', { gameId }),
};

export const adminAPI = {
  getUsers: () => api.get('/admin/users'),
  updateUserStatus: (id, isActive) => api.patch(`/admin/users/${id}/status`, { isActive }),
};

export default api;
