import { Link } from 'react-router-dom';
import { Badge, Button } from 'react-bootstrap';
import { formatPrice, getFinalPrice } from '../utils/price.js';

export default function GameCard({ game, onAddToCart, owned, inWishlist, onToggleWishlist }) {
  const finalPrice = getFinalPrice(game);

  return (
    <article className="pv-card h-100 d-flex flex-column">
      <Link to={`/game/${game.slug}`} className="text-decoration-none">
        <div className="game-card-image position-relative">
          <img src={game.coverImage} alt={game.title} loading="lazy" />
          {game.discountPercent > 0 && (
            <Badge bg="danger" className="position-absolute top-0 end-0 m-2">
              -{game.discountPercent}%
            </Badge>
          )}
          {game.featured && (
            <Badge className="position-absolute top-0 start-0 m-2 bg-info text-dark">
              Featured
            </Badge>
          )}
        </div>
      </Link>
      <div className="p-3 flex-grow-1 d-flex flex-column">
        <Badge className="pv-badge align-self-start mb-2">{game.genre}</Badge>
        <Link to={`/game/${game.slug}`} className="text-decoration-none text-white">
          <h3 className="h6 mb-1">{game.title}</h3>
        </Link>
        {game.rating?.count > 0 && (
          <small className="text-muted mb-2">
            ★ {game.rating.average} ({game.rating.count})
          </small>
        )}
        <div className="mt-auto d-flex align-items-center justify-content-between gap-2 flex-wrap">
          <div>
            {game.discountPercent > 0 && (
              <span className="pv-price-old">${game.price.toFixed(2)}</span>
            )}
            <span className="pv-price">{formatPrice(finalPrice)}</span>
          </div>
          <div className="d-flex gap-1">
            {onToggleWishlist && (
              <Button
                variant="outline-light"
                size="sm"
                onClick={() => onToggleWishlist(game._id)}
                title={inWishlist ? 'Remove from wishlist' : 'Add to wishlist'}
              >
                {inWishlist ? '♥' : '♡'}
              </Button>
            )}
            {owned ? (
              <Badge bg="success" className="align-self-center">
                Owned
              </Badge>
            ) : (
              <Button size="sm" className="pv-btn-primary" onClick={() => onAddToCart?.(game._id)}>
                Add
              </Button>
            )}
          </div>
        </div>
      </div>
      <style>{`
        .game-card-image { aspect-ratio: 16/10; overflow: hidden; }
        .game-card-image img { width: 100%; height: 100%; object-fit: cover; transition: transform 0.3s; }
        .pv-card:hover .game-card-image img { transform: scale(1.05); }
      `}</style>
    </article>
  );
}
