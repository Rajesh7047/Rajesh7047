import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { ShoppingCart, Trash2, CreditCard, ArrowRight, ShoppingBag, Lock } from 'lucide-react';
import toast from 'react-hot-toast';
import { useCart } from '../context/CartContext';
import { useAuth } from '../context/AuthContext';
import { ordersAPI } from '../services/api';
import LoadingSpinner from '../components/ui/LoadingSpinner';

const Cart = () => {
  const { cart, cartLoading, removeFromCart, clearCart, totalPrice } = useCart();
  const { isAuthenticated, refetch } = useAuth();
  const navigate = useNavigate();
  const [checkingOut, setCheckingOut] = useState(false);
  const [removing, setRemoving] = useState(null);

  if (!isAuthenticated) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <ShoppingCart size={48} className="text-gray-600 mx-auto mb-4" />
        <h2 className="font-gaming text-xl text-white mb-2">Sign in to view your cart</h2>
        <Link to="/auth?mode=login" className="btn-primary inline-flex mt-4">Sign In</Link>
      </div>
    </div>
  );

  if (cartLoading) return (
    <div className="min-h-screen flex items-center justify-center">
      <LoadingSpinner size="lg" text="Loading cart..." />
    </div>
  );

  const items = cart?.items || [];

  const handleRemove = async (gameId, title) => {
    setRemoving(gameId);
    try {
      await removeFromCart(gameId);
      toast.success(`${title} removed from cart`);
    } catch {
      toast.error('Failed to remove');
    } finally {
      setRemoving(null);
    }
  };

  const handleCheckout = async () => {
    setCheckingOut(true);
    try {
      const { data } = await ordersAPI.create({ paymentMethod: 'demo' });
      await refetch();
      toast.success('Purchase complete! Games added to library.', { duration: 4000 });
      navigate(`/orders/${data.order._id}`);
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Checkout failed');
    } finally {
      setCheckingOut(false);
    }
  };

  if (items.length === 0) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <ShoppingBag size={56} className="text-gray-600 mx-auto mb-4" />
        <h2 className="font-gaming text-2xl text-white mb-2">Your cart is empty</h2>
        <p className="text-gray-500 mb-6">Add some games to get started!</p>
        <Link to="/store" className="btn-primary inline-flex">
          Browse Store <ArrowRight size={16} />
        </Link>
      </div>
    </div>
  );

  return (
    <div className="min-h-screen page-container py-8">
      <h1 className="font-gaming text-2xl font-bold text-white mb-6 flex items-center gap-2">
        <ShoppingCart size={24} className="text-primary-400" />
        Your Cart
        <span className="text-gray-500 text-lg font-normal">({items.length} item{items.length !== 1 ? 's' : ''})</span>
      </h1>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        {/* Items */}
        <div className="lg:col-span-2 space-y-3">
          {items.map((item) => {
            const g = item.game;
            if (!g) return null;
            return (
              <div key={g._id} className="card p-4 flex items-center gap-4">
                <Link to={`/game/${g.slug}`}>
                  <img src={g.coverImage} alt={g.title} className="w-20 h-28 object-cover rounded-lg shrink-0" />
                </Link>
                <div className="flex-1 min-w-0">
                  <Link to={`/game/${g.slug}`} className="font-gaming font-semibold text-white hover:text-primary-400 transition-colors line-clamp-2">
                    {g.title}
                  </Link>
                  <p className="text-gray-500 text-xs mt-1">{g.genre?.[0]}</p>
                  {g.averageRating > 0 && (
                    <div className="flex items-center gap-1 mt-1">
                      <span className="text-yellow-400 text-xs">★ {g.averageRating.toFixed(1)}</span>
                    </div>
                  )}
                </div>
                <div className="flex flex-col items-end gap-3">
                  <span className="font-gaming font-bold text-white">
                    {item.price === 0 ? 'FREE' : `$${item.price.toFixed(2)}`}
                  </span>
                  <button
                    onClick={() => handleRemove(g._id, g.title)}
                    disabled={removing === g._id}
                    className="p-1.5 text-gray-500 hover:text-red-400 hover:bg-red-400/10 rounded-lg transition-all"
                  >
                    {removing === g._id
                      ? <div className="w-4 h-4 border-2 border-gray-500/30 border-t-gray-500 rounded-full animate-spin" />
                      : <Trash2 size={16} />}
                  </button>
                </div>
              </div>
            );
          })}
        </div>

        {/* Order Summary */}
        <div className="lg:col-span-1">
          <div className="card p-6 sticky top-24 space-y-4">
            <h2 className="font-gaming font-bold text-white text-lg">Order Summary</h2>

            <div className="space-y-2">
              {items.map((item) => item.game && (
                <div key={item.game._id} className="flex justify-between text-sm">
                  <span className="text-gray-400 truncate max-w-[180px]">{item.game.title}</span>
                  <span className="text-gray-300 shrink-0 ml-2">
                    {item.price === 0 ? 'FREE' : `$${item.price.toFixed(2)}`}
                  </span>
                </div>
              ))}
            </div>

            <div className="border-t border-gaming-border pt-4">
              <div className="flex justify-between font-gaming font-bold text-white text-xl">
                <span>Total</span>
                <span>${totalPrice.toFixed(2)}</span>
              </div>
            </div>

            <button
              onClick={handleCheckout}
              disabled={checkingOut}
              className="btn-primary w-full justify-center py-3 text-base"
            >
              {checkingOut
                ? <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
                : <><CreditCard size={18} /> Complete Purchase</>}
            </button>

            <div className="flex items-center justify-center gap-2 text-gray-500 text-xs">
              <Lock size={12} />
              <span>Secure checkout powered by PlayVerse</span>
            </div>

            <button
              onClick={clearCart}
              className="text-red-400 hover:text-red-300 text-xs w-full text-center hover:underline"
            >
              Clear cart
            </button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Cart;
