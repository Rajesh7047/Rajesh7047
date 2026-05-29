import { useEffect, useState } from 'react';
import { Row, Col, Form, Spinner, InputGroup } from 'react-bootstrap';
import api from '../api/client.js';
import GameCard from '../components/GameCard.jsx';
import { useAuth } from '../context/AuthContext.jsx';
import { useCart } from '../context/CartContext.jsx';

export default function Categories() {
  const [games, setGames] = useState([]);
  const [genres, setGenres] = useState([]);
  const [pagination, setPagination] = useState({ page: 1, pages: 1 });
  const [filters, setFilters] = useState({
    genre: 'all',
    search: '',
    sort: 'popularity',
    page: 1,
  });
  const [loading, setLoading] = useState(true);
  const [message, setMessage] = useState('');
  const { isAuthenticated, user, refreshUser } = useAuth();
  const { addToCart } = useCart();

  useEffect(() => {
    api.get('/games/genres').then((res) => setGenres(res.data.genres));
  }, []);

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      try {
        const params = new URLSearchParams();
        if (filters.genre !== 'all') params.set('genre', filters.genre);
        if (filters.search) params.set('search', filters.search);
        params.set('sort', filters.sort);
        params.set('page', filters.page);
        params.set('limit', '12');

        const { data } = await api.get(`/games?${params}`);
        setGames(data.games);
        setPagination(data.pagination);
      } catch (err) {
        setMessage(err.message);
      } finally {
        setLoading(false);
      }
    };
    const t = setTimeout(load, 300);
    return () => clearTimeout(t);
  }, [filters]);

  const wishlistIds = new Set((user?.wishlist || []).map((g) => (typeof g === 'string' ? g : g._id)));
  const ownedIds = new Set((user?.library || []).map((g) => (typeof g === 'string' ? g : g._id)));

  const handleAdd = async (gameId) => {
    if (!isAuthenticated) {
      setMessage('Log in to add to cart');
      return;
    }
    try {
      await addToCart(gameId);
      setMessage('Added to cart');
    } catch (err) {
      setMessage(err.message);
    }
  };

  const toggleWishlist = async (gameId) => {
    if (!isAuthenticated) {
      setMessage('Log in to use wishlist');
      return;
    }
    try {
      await api.post(`/wishlist/${gameId}`);
      await refreshUser();
    } catch (err) {
      setMessage(err.message);
    }
  };

  return (
    <div className="pv-container">
      <h1 className="page-title">Game Store</h1>
      <p className="page-subtitle">Browse by genre, price, and popularity</p>

      <Row className="g-3 mb-4">
        <Col md={4}>
          <InputGroup>
            <Form.Control
              placeholder="Search games..."
              value={filters.search}
              onChange={(e) => setFilters((f) => ({ ...f, search: e.target.value, page: 1 }))}
            />
          </InputGroup>
        </Col>
        <Col md={3}>
          <Form.Select
            value={filters.genre}
            onChange={(e) => setFilters((f) => ({ ...f, genre: e.target.value, page: 1 }))}
          >
            <option value="all">All genres</option>
            {genres.map((g) => (
              <option key={g} value={g}>
                {g}
              </option>
            ))}
          </Form.Select>
        </Col>
        <Col md={3}>
          <Form.Select
            value={filters.sort}
            onChange={(e) => setFilters((f) => ({ ...f, sort: e.target.value, page: 1 }))}
          >
            <option value="popularity">Popularity</option>
            <option value="rating">Top rated</option>
            <option value="price_asc">Price: Low to High</option>
            <option value="price_desc">Price: High to Low</option>
            <option value="newest">Newest</option>
          </Form.Select>
        </Col>
      </Row>

      {message && <div className="alert alert-secondary py-2">{message}</div>}

      {loading ? (
        <div className="text-center py-5">
          <Spinner animation="border" />
        </div>
      ) : (
        <>
          <Row xs={1} sm={2} md={3} lg={4} className="g-4">
            {games.map((game) => (
              <Col key={game._id}>
                <GameCard
                  game={game}
                  onAddToCart={handleAdd}
                  owned={ownedIds.has(game._id)}
                  inWishlist={wishlistIds.has(game._id)}
                  onToggleWishlist={toggleWishlist}
                />
              </Col>
            ))}
          </Row>
          {games.length === 0 && <p className="text-muted text-center py-5">No games match your filters.</p>}
          {pagination.pages > 1 && (
            <div className="d-flex justify-content-center gap-2 mt-4">
              <button
                type="button"
                className="pv-btn-outline btn"
                disabled={filters.page <= 1}
                onClick={() => setFilters((f) => ({ ...f, page: f.page - 1 }))}
              >
                Previous
              </button>
              <span className="align-self-center text-muted">
                Page {filters.page} of {pagination.pages}
              </span>
              <button
                type="button"
                className="pv-btn-outline btn"
                disabled={filters.page >= pagination.pages}
                onClick={() => setFilters((f) => ({ ...f, page: f.page + 1 }))}
              >
                Next
              </button>
            </div>
          )}
        </>
      )}
    </div>
  );
}
