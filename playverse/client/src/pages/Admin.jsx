import { useEffect, useState } from 'react';
import {
  Row,
  Col,
  Card,
  Table,
  Form,
  Button,
  Spinner,
  Alert,
  Badge,
} from 'react-bootstrap';
import api from '../api/client.js';

const emptyGame = {
  title: '',
  description: '',
  shortDescription: '',
  genre: 'Action',
  publisher: '',
  price: 29.99,
  discountPercent: 0,
  coverImage: '',
  featured: false,
};

export default function Admin() {
  const [stats, setStats] = useState(null);
  const [games, setGames] = useState([]);
  const [form, setForm] = useState(emptyGame);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [submitting, setSubmitting] = useState(false);

  const load = async () => {
    try {
      const [statsRes, gamesRes] = await Promise.all([
        api.get('/admin/stats'),
        api.get('/admin/games'),
      ]);
      setStats(statsRes.data);
      setGames(gamesRes.data.games);
    } catch (err) {
      setMessage(err.message);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    load();
  }, []);

  const handleSubmit = async (e) => {
    e.preventDefault();
    setSubmitting(true);
    setMessage('');
    try {
      await api.post('/admin/games', {
        ...form,
        price: Number(form.price),
        discountPercent: Number(form.discountPercent),
      });
      setForm(emptyGame);
      setMessage('Game added successfully');
      await load();
    } catch (err) {
      setMessage(err.message);
    } finally {
      setSubmitting(false);
    }
  };

  const deactivate = async (id) => {
    if (!window.confirm('Deactivate this game?')) return;
    await api.delete(`/admin/games/${id}`);
    await load();
  };

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  return (
    <div className="pv-container">
      <h1 className="page-title">Admin Dashboard</h1>
      <p className="page-subtitle">Manage listings, pricing, and view analytics</p>

      {message && <Alert variant="info">{message}</Alert>}

      {stats && (
        <Row className="g-3 mb-4">
          <Col sm={6} md={3}>
            <Card className="pv-card p-3 text-center">
              <div className="h3 mb-0">{stats.stats.users}</div>
              <small className="text-muted">Users</small>
            </Card>
          </Col>
          <Col sm={6} md={3}>
            <Card className="pv-card p-3 text-center">
              <div className="h3 mb-0">{stats.stats.games}</div>
              <small className="text-muted">Active games</small>
            </Card>
          </Col>
          <Col sm={6} md={3}>
            <Card className="pv-card p-3 text-center">
              <div className="h3 mb-0">{stats.stats.orders}</div>
              <small className="text-muted">Orders</small>
            </Card>
          </Col>
          <Col sm={6} md={3}>
            <Card className="pv-card p-3 text-center">
              <div className="h3 mb-0 pv-price">${stats.stats.revenue.toFixed(0)}</div>
              <small className="text-muted">Revenue</small>
            </Card>
          </Col>
        </Row>
      )}

      <Row className="g-4">
        <Col lg={5}>
          <Card className="pv-card p-4">
            <h2 className="h5 mb-3">Add new game</h2>
            <Form onSubmit={handleSubmit}>
              {['title', 'genre', 'publisher', 'coverImage', 'shortDescription'].map((field) => (
                <Form.Group key={field} className="mb-2">
                  <Form.Label className="text-capitalize">{field.replace(/([A-Z])/g, ' $1')}</Form.Label>
                  <Form.Control
                    required={['title', 'genre', 'coverImage'].includes(field)}
                    value={form[field]}
                    onChange={(e) => setForm((f) => ({ ...f, [field]: e.target.value }))}
                  />
                </Form.Group>
              ))}
              <Form.Group className="mb-2">
                <Form.Label>Description</Form.Label>
                <Form.Control
                  as="textarea"
                  rows={3}
                  required
                  value={form.description}
                  onChange={(e) => setForm((f) => ({ ...f, description: e.target.value }))}
                />
              </Form.Group>
              <Row>
                <Col>
                  <Form.Group className="mb-2">
                    <Form.Label>Price</Form.Label>
                    <Form.Control
                      type="number"
                      step="0.01"
                      value={form.price}
                      onChange={(e) => setForm((f) => ({ ...f, price: e.target.value }))}
                    />
                  </Form.Group>
                </Col>
                <Col>
                  <Form.Group className="mb-2">
                    <Form.Label>Discount %</Form.Label>
                    <Form.Control
                      type="number"
                      value={form.discountPercent}
                      onChange={(e) => setForm((f) => ({ ...f, discountPercent: e.target.value }))}
                    />
                  </Form.Group>
                </Col>
              </Row>
              <Form.Check
                type="checkbox"
                label="Featured"
                className="mb-3"
                checked={form.featured}
                onChange={(e) => setForm((f) => ({ ...f, featured: e.target.checked }))}
              />
              <Button type="submit" className="w-100 pv-btn-primary" disabled={submitting}>
                Add game
              </Button>
            </Form>
          </Card>
        </Col>
        <Col lg={7}>
          <Card className="pv-card p-3">
            <h2 className="h5 mb-3">Game listings</h2>
            <Table responsive className="table-dark table-sm mb-0">
              <thead>
                <tr>
                  <th>Title</th>
                  <th>Genre</th>
                  <th>Price</th>
                  <th>Status</th>
                  <th />
                </tr>
              </thead>
              <tbody>
                {games.map((g) => (
                  <tr key={g._id}>
                    <td>{g.title}</td>
                    <td>{g.genre}</td>
                    <td>${g.price}</td>
                    <td>
                      {g.isActive ? (
                        <Badge bg="success">Active</Badge>
                      ) : (
                        <Badge bg="secondary">Off</Badge>
                      )}
                    </td>
                    <td>
                      {g.isActive && (
                        <Button size="sm" variant="outline-danger" onClick={() => deactivate(g._id)}>
                          Deactivate
                        </Button>
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </Table>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
