import { Link } from 'react-router-dom';
import { ShoppingCart, Heart, Star, Check, Zap } from 'lucide-react';
import { useState } from 'react';
import toast from 'react-hot-toast';
import { useAuth } from '../../context/AuthContext';
import { useCart } from '../../context/CartContext';
import { wishlistAPI } from '../../services/api';
import { formatPrice, getDiscountedPrice } from '../../utils/helpers';
import Badge from '../ui/Badge';

const GameCard = ({ game, compact = false }) => {
  const { isAuthenticated, ownsGame, inWishlist, refetch } = useAuth();
  const { addToCart, inCart } = useCart();
  const [adding, setAdding] = useState(false);
  const [wishlisting, setWishlisting] = useState(false);

  const owned = ownsGame(game._id);
  const inCartAlready = inCart(game._id);
  const wishlistActive = inWishlist(game._id);
  const discountedPrice = getDiscountedPrice(game.price, game.discount);

  const handleCart = async (e) => {
    e.preventDefault();
    if (!isAuthenticated) { toast.error('Please login to add to cart'); return; }
    if (owned || inCartAlready) return;
    try {
      setAdding(true);
      await addToCart(game._id);
      toast.success(`${game.title} added to cart!`);
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to add to cart');
    } finally {
      setAdding(false);
    }
  };

  const handleWishlist = async (e) => {
    e.preventDefault();
    if (!isAuthenticated) { toast.error('Please login to use wishlist'); return; }
    try {
      setWishlisting(true);
      const { data } = await wishlistAPI.toggle(game._id);
      await refetch();
      toast.success(data.message);
    } catch {
      toast.error('Failed to update wishlist');
    } finally {
      setWishlisting(false);
    }
  };

  return (
    <Link to={`/game/${game.slug}`} className="block group">
      <div className="card-hover h-full flex flex-col">
        {/* Cover Image */}
        <div className="relative overflow-hidden aspect-[3/4]">
          <img
            src={game.coverImage}
            alt={game.title}
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
            loading="lazy"
          />
          <div className="absolute inset-0 bg-gradient-to-t from-gaming-card via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />

          {/* Badges */}
          <div className="absolute top-2 left-2 flex flex-col gap-1">
            {game.isFeatured && <Badge variant="featured">Featured</Badge>}
            {game.discount > 0 && <Badge variant="discount">-{game.discount}%</Badge>}
            {game.price === 0 && <Badge variant="free">FREE</Badge>}
          </div>

          {/* Wishlist Button */}
          <button
            onClick={handleWishlist}
            disabled={wishlisting}
            className={`absolute top-2 right-2 p-1.5 rounded-lg transition-all duration-200 ${
              wishlistActive
                ? 'bg-accent-600 text-white'
                : 'bg-black/60 text-gray-300 hover:bg-accent-600/80 hover:text-white opacity-0 group-hover:opacity-100'
            }`}
          >
            <Heart size={14} fill={wishlistActive ? 'currentColor' : 'none'} />
          </button>
        </div>

        {/* Info */}
        <div className="p-3 flex flex-col flex-1 gap-2">
          <div>
            <h3 className="font-gaming font-semibold text-white text-sm leading-tight line-clamp-2 group-hover:text-primary-400 transition-colors">
              {game.title}
            </h3>
            <p className="text-gray-500 text-xs mt-0.5">{game.developer}</p>
          </div>

          {/* Genre */}
          {!compact && game.genre?.length > 0 && (
            <div className="flex flex-wrap gap-1">
              {game.genre.slice(0, 2).map((g) => (
                <Badge key={g} variant="genre">{g}</Badge>
              ))}
            </div>
          )}

          {/* Rating */}
          {game.averageRating > 0 && (
            <div className="flex items-center gap-1">
              <Star size={12} className="fill-yellow-400 text-yellow-400" />
              <span className="text-yellow-400 text-xs font-semibold">{game.averageRating.toFixed(1)}</span>
              {game.reviewCount > 0 && (
                <span className="text-gray-500 text-xs">({game.reviewCount.toLocaleString()})</span>
              )}
            </div>
          )}

          {/* Price + Cart */}
          <div className="flex items-center justify-between mt-auto pt-2 border-t border-gaming-border">
            <div>
              {game.price === 0 ? (
                <span className="text-accent-400 font-bold text-sm font-gaming">FREE</span>
              ) : (
                <div className="flex items-center gap-1.5">
                  <span className="text-white font-bold text-sm font-gaming">
                    ${discountedPrice.toFixed(2)}
                  </span>
                  {game.discount > 0 && (
                    <span className="text-gray-500 text-xs line-through">${game.price.toFixed(2)}</span>
                  )}
                </div>
              )}
            </div>

            <button
              onClick={handleCart}
              disabled={adding || owned || inCartAlready}
              className={`p-1.5 rounded-lg transition-all duration-200 ${
                owned
                  ? 'bg-emerald-600/20 text-emerald-400 cursor-default'
                  : inCartAlready
                  ? 'bg-primary-600/20 text-primary-400 cursor-default'
                  : 'bg-primary-600 hover:bg-primary-500 text-white hover:shadow-glow'
              }`}
              title={owned ? 'Owned' : inCartAlready ? 'In Cart' : 'Add to Cart'}
            >
              {owned ? <Check size={14} /> : inCartAlready ? <Zap size={14} /> : <ShoppingCart size={14} />}
            </button>
          </div>
        </div>
      </div>
    </Link>
  );
};

export default GameCard;
