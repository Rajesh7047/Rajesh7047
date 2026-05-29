import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { Row, Col, Badge, Button, Spinner, Form, Alert, ListGroup } from 'react-bootstrap';
import api from '../api/client.js';
import { formatPrice, getFinalPrice } from '../utils/price.js';
import { useAuth } from '../context/AuthContext.jsx';
import { useCart } from '../context/CartContext.jsx';

export default function GameDetail() {
  const { slug } = useParams();
  const [game, setGame] = useState(null);
  const [reviews, setReviews] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const [reviewForm, setReviewForm] = useState({ rating: 5, title: '', body: '' });
  const { isAuthenticated, user, refreshUser } = useAuth();
  const { addToCart } = useCart();

  useEffect(() => {
    api
      .get(`/games/${slug}`)
      .then((res) => {
        setGame(res.data.game);
        setReviews(res.data.reviews);
      })
      .catch((err) => setMessage(err.message))
      .finally(() => setLoading(false));
  }, [slug]);

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  if (!game) {
    return (
      <div className="pv-container">
        <Alert variant="warning">{message || 'Game not found'}</Alert>
        <Link to="/categories">Back to store</Link>
      </div>
    );
  }

  const finalPrice = getFinalPrice(game);
  const owned = (user?.library || []).some((g) => {
    const id = typeof g === 'string' ? g : g._id;
    return id === game._id;
  });

  const handlePurchase = async () => {
    if (!isAuthenticated) {
      setMessage('Please log in first');
      return;
    }
    try {
      await addToCart(game._id);
      setMessage('Added to cart — proceed to checkout');
    } catch (err) {
      setMessage(err.message);
    }
  };

  const submitReview = async (e) => {
    e.preventDefault();
    try {
      await api.post('/reviews', { gameId: game._id, ...reviewForm });
      const { data } = await api.get(`/games/${slug}`);
      setReviews(data.reviews);
      setGame(data.game);
      setMessage('Review submitted');
    } catch (err) {
      setMessage(err.message);
    }
  };

  const installGame = () => {
    if (game.downloadUrl) {
      window.open(game.downloadUrl, '_blank', 'noopener');
      setMessage('Download started — check your library for install instructions');
    }
  };

  return (
    <div className="pv-container">
      <Row className="g-4">
        <Col lg={7}>
          <div className="pv-card overflow-hidden">
            <img
              src={game.bannerImage || game.coverImage}
              alt={game.title}
              className="w-100"
              style={{ maxHeight: 400, objectFit: 'cover' }}
            />
          </div>
          <div className="mt-4">
            <h2 className="h5">About</h2>
            <p className="text-muted">{game.description}</p>
            <h3 className="h6 mt-4">System requirements</h3>
            <ListGroup variant="dark" className="small">
              {Object.entries(game.systemRequirements || {}).map(([k, v]) => (
                <ListGroup.Item key={k} className="bg-transparent border-secondary">
                  <strong className="text-capitalize">{k}:</strong> {v}
                </ListGroup.Item>
              ))}
            </ListGroup>
          </div>
        </Col>
        <Col lg={5}>
          <Badge className="pv-badge mb-2">{game.genre}</Badge>
          <h1 className="page-title">{game.title}</h1>
          <p className="text-muted">{game.publisher}</p>
          {game.rating?.count > 0 && (
            <p>
              ★ {game.rating.average} · {game.rating.count} reviews
            </p>
          )}
          <p className="pv-price display-6">{formatPrice(finalPrice)}</p>
          {message && <Alert variant="info">{message}</Alert>}
          <div className="d-flex flex-wrap gap-2 mb-4">
            {owned ? (
              <Button className="pv-btn-primary" onClick={installGame}>
                Download / Install
              </Button>
            ) : (
              <Button className="pv-btn-primary" onClick={handlePurchase}>
                Add to cart
              </Button>
            )}
            <Button as={Link} to="/categories" variant="outline-light" className="pv-btn-outline">
              Back to store
            </Button>
          </div>
          <p className="small text-muted">File size: ~{(game.fileSizeMb / 1024).toFixed(1)} GB</p>
        </Col>
      </Row>

      <section className="mt-5">
        <h2 className="h4 mb-3">Reviews</h2>
        {owned && isAuthenticated && (
          <Form onSubmit={submitReview} className="pv-card p-3 mb-4">
            <Form.Group className="mb-2">
              <Form.Label>Your rating</Form.Label>
              <Form.Select
                value={reviewForm.rating}
                onChange={(e) => setReviewForm((f) => ({ ...f, rating: Number(e.target.value) }))}
              >
                {[5, 4, 3, 2, 1].map((n) => (
                  <option key={n} value={n}>
                    {n} stars
                  </option>
                ))}
              </Form.Select>
            </Form.Group>
            <Form.Control
              className="mb-2"
              placeholder="Review title"
              value={reviewForm.title}
              onChange={(e) => setReviewForm((f) => ({ ...f, title: e.target.value }))}
            />
            <Form.Control
              as="textarea"
              rows={3}
              className="mb-2"
              placeholder="Share your experience..."
              value={reviewForm.body}
              onChange={(e) => setReviewForm((f) => ({ ...f, body: e.target.value }))}
            />
            <Button type="submit" className="pv-btn-primary">
              Submit review
            </Button>
          </Form>
        )}
        {reviews.length === 0 ? (
          <p className="text-muted">No reviews yet.</p>
        ) : (
          reviews.map((r) => (
            <div key={r._id} className="pv-card p-3 mb-2">
              <strong>{r.user?.username}</strong> · ★ {r.rating}
              {r.title && <div className="fw-semibold">{r.title}</div>}
              <p className="mb-0 text-muted small">{r.body}</p>
            </div>
          ))
        )}
      </section>
    </div>
  );
}
