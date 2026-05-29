import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Heart, ShoppingCart, Trash2, Star } from 'lucide-react';
import toast from 'react-hot-toast';
import { wishlistAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { getDiscountedPrice } from '../utils/helpers';
import Badge from '../components/ui/Badge';

const Wishlist = () => {
  const { isAuthenticated, refetch: authRefetch } = useAuth();
  const { addToCart, inCart } = useCart();
  const [wishlist, setWishlist] = useState([]);
  const [loading, setLoading] = useState(true);
  const [removing, setRemoving] = useState(null);
  const [adding, setAdding] = useState(null);

  const load = async () => {
    try {
      const { data } = await wishlistAPI.get();
      setWishlist(data.wishlist);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (!isAuthenticated) { setLoading(false); return; }
    load();
  }, [isAuthenticated]);

  const handleRemove = async (gameId, title) => {
    setRemoving(gameId);
    try {
      await wishlistAPI.toggle(gameId);
      setWishlist((w) => w.filter((g) => g._id !== gameId));
      await authRefetch();
      toast.success(`${title} removed from wishlist`);
    } catch { toast.error('Failed'); }
    finally { setRemoving(null); }
  };

  const handleAddCart = async (gameId, title) => {
    setAdding(gameId);
    try {
      await addToCart(gameId);
      toast.success(`${title} added to cart!`);
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to add to cart');
    } finally { setAdding(null); }
  };

  if (!isAuthenticated) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <Heart size={48} className="text-gray-600 mx-auto mb-4" />
        <h2 className="font-gaming text-xl text-white mb-2">Sign in to view wishlist</h2>
        <Link to="/auth?mode=login" className="btn-primary inline-flex mt-4">Sign In</Link>
      </div>
    </div>
  );

  if (loading) return <div className="min-h-screen flex items-center justify-center"><LoadingSpinner size="lg" /></div>;

  return (
    <div className="min-h-screen page-container py-8">
      <h1 className="font-gaming text-2xl font-bold text-white mb-6 flex items-center gap-2">
        <Heart size={24} className="text-accent-400" />
        Wishlist
        <span className="text-gray-500 text-lg font-normal">({wishlist.length})</span>
      </h1>

      {wishlist.length === 0 ? (
        <div className="text-center py-20">
          <Heart size={56} className="text-gray-600 mx-auto mb-4" />
          <h2 className="font-gaming text-xl text-white mb-2">Your wishlist is empty</h2>
          <p className="text-gray-500 mb-6">Save games you want to play later.</p>
          <Link to="/store" className="btn-primary inline-flex">Browse Store</Link>
        </div>
      ) : (
        <div className="space-y-3 max-w-2xl">
          {wishlist.map((game) => {
            const price = getDiscountedPrice(game.price, game.discount);
            const inCartAlready = inCart(game._id);
            return (
              <div key={game._id} className="card p-4 flex items-center gap-4">
                <Link to={`/game/${game.slug}`}>
                  <img src={game.coverImage} alt={game.title} className="w-20 h-28 object-cover rounded-lg shrink-0" />
                </Link>
                <div className="flex-1 min-w-0">
                  <Link to={`/game/${game.slug}`} className="font-gaming font-semibold text-white hover:text-primary-400 transition-colors">
                    {game.title}
                  </Link>
                  <div className="flex flex-wrap gap-1 mt-1">
                    {game.genre?.slice(0, 2).map((g) => <Badge key={g} variant="genre">{g}</Badge>)}
                  </div>
                  {game.averageRating > 0 && (
                    <div className="flex items-center gap-1 mt-1.5">
                      <Star size={12} className="fill-yellow-400 text-yellow-400" />
                      <span className="text-yellow-400 text-xs">{game.averageRating.toFixed(1)}</span>
                    </div>
                  )}
                </div>
                <div className="flex flex-col items-end gap-2 shrink-0">
                  <div className="text-right">
                    <span className="font-gaming font-bold text-white">
                      {game.price === 0 ? 'FREE' : `$${price.toFixed(2)}`}
                    </span>
                    {game.discount > 0 && (
                      <p className="text-gray-500 text-xs line-through">${game.price.toFixed(2)}</p>
                    )}
                  </div>
                  <div className="flex items-center gap-2">
                    {!inCartAlready ? (
                      <button
                        onClick={() => handleAddCart(game._id, game.title)}
                        disabled={adding === game._id}
                        className="btn-primary py-1.5 px-3 text-xs"
                      >
                        {adding === game._id
                          ? <div className="w-3 h-3 border border-white/30 border-t-white rounded-full animate-spin" />
                          : <><ShoppingCart size={12} /> Add to Cart</>}
                      </button>
                    ) : (
                      <Link to="/cart" className="btn-secondary py-1.5 px-3 text-xs">In Cart</Link>
                    )}
                    <button
                      onClick={() => handleRemove(game._id, game.title)}
                      disabled={removing === game._id}
                      className="p-1.5 text-gray-500 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-all"
                    >
                      {removing === game._id
                        ? <div className="w-3 h-3 border border-gray-500/30 border-t-gray-500 rounded-full animate-spin" />
                        : <Trash2 size={14} />}
                    </button>
                  </div>
                </div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default Wishlist;
