import clsx from "clsx";
import { Game } from "../types";

interface Props {
  game: Game;
  onAddToCart?: (id: string) => void;
  onToggleWishlist?: (id: string) => void;
  isWishlisted?: boolean;
  compact?: boolean;
}

export const GameCard: React.FC<Props> = ({
  game,
  onAddToCart,
  onToggleWishlist,
  isWishlisted,
  compact = false
}) => (
  <article className={clsx("game-card", compact && "compact")}>
    <img src={game.heroImage} alt={game.title} loading="lazy" />
    <div className="game-card-content">
      <div className="game-title-row">
        <h3>{game.title}</h3>
        <span className="genre">{game.genre}</span>
      </div>
      <p>{game.description}</p>
      <div className="tags">
        {game.tags.slice(0, 3).map((tag) => (
          <span key={tag}>{tag}</span>
        ))}
      </div>
      <div className="price-row">
        <strong>${game.finalPrice.toFixed(2)}</strong>
        {game.discountPercent > 0 && (
          <span className="strike">${game.price.toFixed(2)}</span>
        )}
        <span className="rating">★ {game.averageRating || "New"}</span>
      </div>
      <div className="actions">
        {onAddToCart && (
          <button className="button" onClick={() => onAddToCart(game.id)}>
            Add to cart
          </button>
        )}
        {onToggleWishlist && (
          <button className="button ghost" onClick={() => onToggleWishlist(game.id)}>
            {isWishlisted ? "Remove wishlist" : "Wishlist"}
          </button>
        )}
      </div>
    </div>
  </article>
);
