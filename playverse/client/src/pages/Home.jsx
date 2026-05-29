import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Row, Col, Spinner, Button } from 'react-bootstrap';
import api from '../api/client.js';
import GameCard from '../components/GameCard.jsx';
import { useAuth } from '../context/AuthContext.jsx';
import { useCart } from '../context/CartContext.jsx';

export default function Home() {
  const [featured, setFeatured] = useState([]);
  const [trending, setTrending] = useState([]);
  const [recommendations, setRecommendations] = useState([]);
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const { isAuthenticated, user } = useAuth();
  const { addToCart } = useCart();

  useEffect(() => {
    async function load() {
      try {
        const [featRes, trendRes] = await Promise.all([
          api.get('/recommendations/featured'),
          api.get('/games?sort=popularity&limit=8'),
        ]);
        setFeatured(featRes.data.games);
        setTrending(trendRes.data.games);

        if (isAuthenticated) {
          const recRes = await api.get('/recommendations');
          setRecommendations(recRes.data.recommendations);
        }
      } catch (err) {
        setMessage(err.message);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [isAuthenticated]);

  const handleAdd = async (gameId) => {
    if (!isAuthenticated) {
      setMessage('Please log in to add games to your cart');
      return;
    }
    try {
      await addToCart(gameId);
      setMessage('Added to cart!');
      setTimeout(() => setMessage(''), 2500);
    } catch (err) {
      setMessage(err.message);
    }
  };

  const ownedIds = new Set((user?.library || []).map((g) => (typeof g === 'string' ? g : g._id || g.id)));

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" variant="primary" />
      </div>
    );
  }

  return (
    <div className="pv-container">
      <section className="hero-section text-center py-5 mb-5">
        <p className="pv-badge d-inline-block mb-3">Your gaming universe</p>
        <h1 className="display-4 fw-bold mb-3">
          Discover. Purchase. <span className="text-accent">Play.</span>
        </h1>
        <p className="lead text-muted col-lg-8 mx-auto mb-4">
          PlayVerse is a modern PC game store with secure checkout, personalized recommendations,
          and one-click library access.
        </p>
        <div className="d-flex gap-2 justify-content-center flex-wrap">
          <Button as={Link} to="/categories" className="pv-btn-primary">
            Browse Store
          </Button>
          {!isAuthenticated && (
            <Button as={Link} to="/auth" variant="outline-light" className="pv-btn-outline">
              Create Account
            </Button>
          )}
        </div>
      </section>

      {message && <div className="alert alert-info">{message}</div>}

      <Section title="Featured" games={featured} onAdd={handleAdd} ownedIds={ownedIds} />
      {recommendations.length > 0 && (
        <Section
          title="Recommended for you"
          games={recommendations}
          onAdd={handleAdd}
          ownedIds={ownedIds}
        />
      )}
      <Section title="Trending now" games={trending} onAdd={handleAdd} ownedIds={ownedIds} />

      <style>{`
        .hero-section { border-radius: var(--pv-radius); background: linear-gradient(180deg, var(--pv-surface) 0%, transparent 100%); border: 1px solid var(--pv-border); }
        .text-accent { color: var(--pv-accent); font-family: var(--font-display); }
      `}</style>
    </div>
  );
}

function Section({ title, games, onAdd, ownedIds }) {
  if (!games?.length) return null;
  return (
    <section className="mb-5">
      <h2 className="h4 mb-4 font-display">{title}</h2>
      <Row xs={1} sm={2} md={3} lg={4} className="g-4">
        {games.map((game) => (
          <Col key={game._id}>
            <GameCard game={game} onAddToCart={onAdd} owned={ownedIds.has(game._id)} />
          </Col>
        ))}
      </Row>
    </section>
  );
}
