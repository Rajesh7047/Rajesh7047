import { useState } from 'react';
import { useNavigate, useSearchParams, useLocation, Link } from 'react-router-dom';
import { Form, Button, Alert, Card, Col, Row } from 'react-bootstrap';
import { useAuth } from '../context/AuthContext.jsx';

export default function AuthPage() {
  const [searchParams] = useSearchParams();
  const isRegister = searchParams.get('mode') === 'register';
  const [mode, setMode] = useState(isRegister ? 'register' : 'login');
  const [form, setForm] = useState({ username: '', email: '', password: '' });
  const [error, setError] = useState('');
  const [submitting, setSubmitting] = useState(false);
  const { login, register } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const from = location.state?.from?.pathname || '/';

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSubmitting(true);
    try {
      if (mode === 'login') {
        await login(form.email, form.password);
      } else {
        await register(form.username, form.email, form.password);
      }
      navigate(from, { replace: true });
    } catch (err) {
      setError(err.message);
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <div className="pv-container">
      <Row className="justify-content-center">
        <Col md={6} lg={5}>
          <Card className="pv-card border-0 p-4">
            <h1 className="page-title text-center mb-1">
              {mode === 'login' ? 'Welcome back' : 'Join PlayVerse'}
            </h1>
            <p className="text-center text-muted mb-4">
              {mode === 'login' ? 'Log in to your account' : 'Create your gamer profile'}
            </p>

            {error && <Alert variant="danger">{error}</Alert>}

            <div className="d-flex gap-2 mb-4">
              <Button
                variant={mode === 'login' ? 'primary' : 'outline-secondary'}
                className="flex-grow-1"
                onClick={() => setMode('login')}
              >
                Log in
              </Button>
              <Button
                variant={mode === 'register' ? 'primary' : 'outline-secondary'}
                className="flex-grow-1"
                onClick={() => setMode('register')}
              >
                Register
              </Button>
            </div>

            <Form onSubmit={handleSubmit}>
              {mode === 'register' && (
                <Form.Group className="mb-3">
                  <Form.Label>Username</Form.Label>
                  <Form.Control
                    required
                    value={form.username}
                    onChange={(e) => setForm((f) => ({ ...f, username: e.target.value }))}
                  />
                </Form.Group>
              )}
              <Form.Group className="mb-3">
                <Form.Label>Email</Form.Label>
                <Form.Control
                  type="email"
                  required
                  value={form.email}
                  onChange={(e) => setForm((f) => ({ ...f, email: e.target.value }))}
                />
              </Form.Group>
              <Form.Group className="mb-4">
                <Form.Label>Password</Form.Label>
                <Form.Control
                  type="password"
                  required
                  minLength={6}
                  value={form.password}
                  onChange={(e) => setForm((f) => ({ ...f, password: e.target.value }))}
                />
              </Form.Group>
              <Button type="submit" className="w-100 pv-btn-primary" disabled={submitting}>
                {submitting ? 'Please wait...' : mode === 'login' ? 'Log in' : 'Create account'}
              </Button>
            </Form>

            <p className="text-center text-muted small mt-4 mb-0">
              Demo: demo@playverse.com / demo1234 · Admin: admin@playverse.com / admin123
            </p>
            <p className="text-center mt-2 mb-0">
              <Link to="/">← Back to home</Link>
            </p>
          </Card>
        </Col>
      </Row>
    </div>
  );
}
