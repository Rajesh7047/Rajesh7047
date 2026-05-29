import { Heart, ShoppingCart, Star } from "lucide-react";
import type { Game } from "../types";

interface GameCardProps {
  game: Game;
  owned?: boolean;
  onAddToCart: (gameId: string) => void;
  onInspect: (game: Game) => void;
}

export function GameCard({ game, owned = false, onAddToCart, onInspect }: GameCardProps) {
  const finalPrice = game.finalPrice ?? game.price * (1 - game.discountPercent / 100);

  return (
    <article className="game-card">
      <button className="image-button" onClick={() => onInspect(game)} aria-label={`View details for ${game.title}`}>
        <img src={game.heroImage} alt="" />
      </button>
      <div className="game-card__body">
        <div className="game-card__meta">
          <span>{game.genre}</span>
          <span className="rating">
            <Star size={15} fill="currentColor" /> {game.rating}
          </span>
        </div>
        <h3>{game.title}</h3>
        <p>{game.description}</p>
        <div className="tag-row">
          {game.tags.slice(0, 3).map((tag) => (
            <span key={tag}>{tag}</span>
          ))}
        </div>
        <div className="game-card__footer">
          <div>
            {game.discountPercent > 0 && <span className="price-cut">${game.price.toFixed(2)}</span>}
            <strong>${finalPrice.toFixed(2)}</strong>
          </div>
          <button className="icon-button ghost" aria-label={`Wishlist ${game.title}`}>
            <Heart size={18} />
          </button>
          <button className="icon-button" onClick={() => onAddToCart(game.id)} disabled={owned}>
            <ShoppingCart size={18} />
            {owned ? "Owned" : "Cart"}
          </button>
        </div>
      </div>
    </article>
  );
}
