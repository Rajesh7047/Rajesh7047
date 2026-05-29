import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { Row, Col, Button, Spinner, Alert } from 'react-bootstrap';
import api from '../api/client.js';
import { useAuth } from '../context/AuthContext.jsx';

export default function Library() {
  const { user, refreshUser } = useAuth();
  const [wishlist, setWishlist] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function load() {
      try {
        await refreshUser();
        const { data } = await api.get('/wishlist');
        setWishlist(data.wishlist);
      } finally {
        setLoading(false);
      }
    }
    load();
  }, [refreshUser]);

  const library = user?.library || [];

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  return (
    <div className="pv-container">
      <h1 className="page-title">My Library</h1>
      <p className="page-subtitle">Your purchased games — download and install anytime</p>

      {library.length === 0 ? (
        <Alert variant="secondary">
          Your library is empty.{' '}
          <Link to="/categories">Browse the store</Link> to find games.
        </Alert>
      ) : (
        <Row xs={1} md={2} lg={3} className="g-4 mb-5">
          {library.map((game) => {
            const g = typeof game === 'object' ? game : { _id: game };
            return (
              <Col key={g._id}>
                <div className="pv-card p-3 h-100 d-flex flex-column">
                  {g.coverImage && (
                    <img
                      src={g.coverImage}
                      alt={g.title}
                      className="rounded mb-3"
                      style={{ height: 140, objectFit: 'cover', width: '100%' }}
                    />
                  )}
                  <h3 className="h6">{g.title || 'Game'}</h3>
                  <div className="mt-auto d-flex gap-2">
                    <Button
                      as={Link}
                      to={`/game/${g.slug}`}
                      size="sm"
                      className="pv-btn-primary"
                    >
                      Details
                    </Button>
                    {g.downloadUrl && (
                      <Button
                        size="sm"
                        variant="outline-light"
                        href={g.downloadUrl}
                        target="_blank"
                        rel="noopener noreferrer"
                      >
                        Install
                      </Button>
                    )}
                  </div>
                </div>
              </Col>
            );
          })}
        </Row>
      )}

      <h2 className="h4 mb-3">Wishlist</h2>
      {wishlist.length === 0 ? (
        <p className="text-muted">No games in your wishlist.</p>
      ) : (
        <Row xs={1} sm={2} md={4} className="g-3">
          {wishlist.map((game) => (
            <Col key={game._id}>
              <Link to={`/game/${game.slug}`} className="pv-card p-2 d-block text-decoration-none">
                <img
                  src={game.coverImage}
                  alt={game.title}
                  className="w-100 rounded"
                  style={{ height: 100, objectFit: 'cover' }}
                />
                <span className="text-white small d-block mt-2">{game.title}</span>
              </Link>
            </Col>
          ))}
        </Row>
      )}
    </div>
  );
}
