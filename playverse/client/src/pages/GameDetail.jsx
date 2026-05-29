import { useState, useEffect } from 'react';
import { useParams, Link } from 'react-router-dom';
import {
  ShoppingCart, Heart, Star, Download, Check, ChevronLeft,
  Monitor, Cpu, MemoryStick, HardDrive, Calendar, User2,
  Award, Users, Zap, MessageSquare,
} from 'lucide-react';
import toast from 'react-hot-toast';
import { gamesAPI, wishlistAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import { useCart } from '../context/CartContext';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import StarRating from '../components/ui/StarRating';
import Badge from '../components/ui/Badge';
import { formatDate, getDiscountedPrice } from '../utils/helpers';

const SysReqRow = ({ icon: Icon, label, value }) => (
  value ? (
    <div className="flex items-start gap-3 py-2 border-b border-gaming-border last:border-0">
      <Icon size={14} className="text-gray-500 mt-0.5 shrink-0" />
      <div>
        <span className="text-gray-500 text-xs">{label}</span>
        <p className="text-gray-300 text-sm">{value}</p>
      </div>
    </div>
  ) : null
);

const ReviewForm = ({ gameId, onReviewAdded }) => {
  const { isAuthenticated } = useAuth();
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');
  const [submitting, setSubmitting] = useState(false);

  if (!isAuthenticated) return (
    <div className="card p-6 text-center">
      <p className="text-gray-400 mb-3">Sign in to leave a review</p>
      <Link to="/auth?mode=login" className="btn-primary inline-flex">Sign In</Link>
    </div>
  );

  const submit = async (e) => {
    e.preventDefault();
    if (!rating) { toast.error('Please select a rating'); return; }
    setSubmitting(true);
    try {
      const { data } = await gamesAPI.addReview(gameId, { rating, comment });
      toast.success('Review submitted!');
      setRating(0);
      setComment('');
      onReviewAdded(data.game);
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to submit review');
    } finally {
      setSubmitting(false);
    }
  };

  return (
    <form onSubmit={submit} className="card p-6 space-y-4">
      <h4 className="font-gaming font-semibold text-white">Write a Review</h4>
      <div>
        <p className="text-gray-400 text-sm mb-2">Your Rating</p>
        <StarRating rating={rating} interactive onRate={setRating} size={20} />
      </div>
      <textarea
        value={comment}
        onChange={(e) => setComment(e.target.value)}
        placeholder="Share your thoughts about this game..."
        rows={3}
        className="input-field resize-none"
      />
      <button type="submit" disabled={submitting} className="btn-primary">
        {submitting ? <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <>Submit Review <Star size={14} /></>}
      </button>
    </form>
  );
};

const GameDetail = () => {
  const { slug } = useParams();
  const { isAuthenticated, ownsGame, inWishlist, refetch } = useAuth();
  const { addToCart, inCart } = useCart();
  const [game, setGame] = useState(null);
  const [loading, setLoading] = useState(true);
  const [activeImg, setActiveImg] = useState(0);
  const [adding, setAdding] = useState(false);
  const [wishlisting, setWishlisting] = useState(false);
  const [activeTab, setActiveTab] = useState('about');

  useEffect(() => {
    const load = async () => {
      setLoading(true);
      try {
        const { data } = await gamesAPI.getBySlug(slug);
        setGame(data.game);
      } catch {
        toast.error('Game not found');
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [slug]);

  if (loading) return <div className="min-h-screen flex items-center justify-center"><LoadingSpinner size="lg" /></div>;
  if (!game) return <div className="min-h-screen flex items-center justify-center"><p className="text-gray-400">Game not found.</p></div>;

  const owned = ownsGame(game._id);
  const cartAlready = inCart(game._id);
  const wishlistActive = inWishlist(game._id);
  const discountedPrice = getDiscountedPrice(game.price, game.discount);
  const allImages = [game.coverImage, ...(game.screenshots || [])];

  const handleCart = async () => {
    if (!isAuthenticated) { toast.error('Please login to add to cart'); return; }
    if (owned || cartAlready) return;
    setAdding(true);
    try {
      await addToCart(game._id);
      toast.success('Added to cart!');
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed to add to cart');
    } finally {
      setAdding(false);
    }
  };

  const handleWishlist = async () => {
    if (!isAuthenticated) { toast.error('Please login'); return; }
    setWishlisting(true);
    try {
      const { data } = await wishlistAPI.toggle(game._id);
      await refetch();
      toast.success(data.message);
    } catch {
      toast.error('Failed');
    } finally {
      setWishlisting(false);
    }
  };

  return (
    <div className="min-h-screen page-container py-8">
      {/* Breadcrumb */}
      <div className="flex items-center gap-2 text-gray-500 text-sm mb-6">
        <Link to="/" className="hover:text-gray-300">Home</Link>
        <span>/</span>
        <Link to="/store" className="hover:text-gray-300">Store</Link>
        <span>/</span>
        <span className="text-gray-300">{game.title}</span>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
        {/* Left: Images */}
        <div className="lg:col-span-2 space-y-4">
          {/* Main Image */}
          <div className="relative rounded-2xl overflow-hidden aspect-video bg-gaming-card">
            <img src={allImages[activeImg]} alt={game.title} className="w-full h-full object-cover" />
            {game.isFeatured && (
              <div className="absolute top-4 left-4">
                <Badge variant="featured">Featured</Badge>
              </div>
            )}
          </div>

          {/* Thumbnails */}
          {allImages.length > 1 && (
            <div className="flex gap-2 overflow-x-auto pb-1">
              {allImages.map((img, i) => (
                <button
                  key={i}
                  onClick={() => setActiveImg(i)}
                  className={`shrink-0 w-20 h-14 rounded-lg overflow-hidden border-2 transition-all ${i === activeImg ? 'border-primary-500' : 'border-gaming-border hover:border-gray-500'}`}
                >
                  <img src={img} alt="" className="w-full h-full object-cover" />
                </button>
              ))}
            </div>
          )}

          {/* Tabs */}
          <div className="border-b border-gaming-border flex gap-4">
            {['about', 'requirements', 'reviews'].map((tab) => (
              <button
                key={tab}
                onClick={() => setActiveTab(tab)}
                className={`pb-3 text-sm font-medium capitalize transition-all border-b-2 ${activeTab === tab ? 'border-primary-500 text-white' : 'border-transparent text-gray-500 hover:text-gray-300'}`}
              >
                {tab === 'reviews' ? `Reviews (${game.reviewCount})` : tab.charAt(0).toUpperCase() + tab.slice(1)}
              </button>
            ))}
          </div>

          {/* Tab Content */}
          {activeTab === 'about' && (
            <div className="space-y-4">
              <p className="text-gray-400 leading-relaxed">{game.description}</p>
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                {[
                  { icon: User2, label: 'Developer', value: game.developer },
                  { icon: Calendar, label: 'Release', value: formatDate(game.releaseDate) },
                  { icon: Download, label: 'File Size', value: game.fileSize },
                  { icon: Award, label: 'Rating', value: game.ageRating },
                ].map(({ icon: Icon, label, value }) => (
                  <div key={label} className="card p-3">
                    <div className="flex items-center gap-2 mb-1">
                      <Icon size={13} className="text-gray-500" />
                      <span className="text-gray-500 text-xs">{label}</span>
                    </div>
                    <p className="text-white text-sm font-medium">{value}</p>
                  </div>
                ))}
              </div>
              {game.tags?.length > 0 && (
                <div className="flex flex-wrap gap-2">
                  {game.tags.map((t) => (
                    <span key={t} className="text-xs bg-gaming-card border border-gaming-border px-2.5 py-1 rounded-full text-gray-400">{t}</span>
                  ))}
                </div>
              )}
            </div>
          )}

          {activeTab === 'requirements' && game.systemRequirements && (
            <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
              {['minimum', 'recommended'].map((tier) => (
                game.systemRequirements[tier] && (
                  <div key={tier} className="card p-4">
                    <h4 className="font-gaming font-semibold text-white capitalize mb-3">{tier}</h4>
                    <SysReqRow icon={Monitor} label="OS" value={game.systemRequirements[tier].os} />
                    <SysReqRow icon={Cpu} label="Processor" value={game.systemRequirements[tier].processor} />
                    <SysReqRow icon={MemoryStick} label="Memory" value={game.systemRequirements[tier].memory} />
                    <SysReqRow icon={Monitor} label="Graphics" value={game.systemRequirements[tier].graphics} />
                    <SysReqRow icon={HardDrive} label="Storage" value={game.systemRequirements[tier].storage} />
                  </div>
                )
              ))}
            </div>
          )}

          {activeTab === 'reviews' && (
            <div className="space-y-6">
              <ReviewForm gameId={game._id} onReviewAdded={setGame} />
              {game.reviews?.length > 0 ? (
                <div className="space-y-4">
                  {game.reviews.map((r) => (
                    <div key={r._id} className="card p-4">
                      <div className="flex items-start justify-between gap-2 mb-2">
                        <div className="flex items-center gap-2">
                          <div className="w-8 h-8 bg-primary-600/30 rounded-full flex items-center justify-center text-primary-400 font-bold text-sm">
                            {(r.username || r.user?.username || '?')[0]?.toUpperCase()}
                          </div>
                          <span className="text-white font-medium text-sm">{r.username || r.user?.username}</span>
                        </div>
                        <StarRating rating={r.rating} size={12} />
                      </div>
                      {r.comment && <p className="text-gray-400 text-sm">{r.comment}</p>}
                      <p className="text-gray-600 text-xs mt-2">{formatDate(r.createdAt)}</p>
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-gray-500 text-center py-6">No reviews yet. Be the first!</p>
              )}
            </div>
          )}
        </div>

        {/* Right: Purchase Panel */}
        <div className="lg:col-span-1">
          <div className="card p-6 sticky top-24 space-y-5">
            <div>
              <div className="flex flex-wrap gap-1 mb-3">
                {game.genre?.map((g) => <Badge key={g} variant="genre">{g}</Badge>)}
              </div>
              <h1 className="font-gaming text-2xl font-bold text-white leading-tight">{game.title}</h1>
              <p className="text-gray-500 text-sm mt-1">{game.developer}</p>
            </div>

            {/* Rating */}
            <StarRating rating={game.averageRating} showCount count={game.reviewCount} size={16} />

            {/* Price */}
            <div className="bg-gaming-darker rounded-xl p-4">
              {game.price === 0 ? (
                <div className="text-3xl font-gaming font-bold text-accent-400">FREE</div>
              ) : (
                <div className="flex items-end gap-3">
                  <span className="text-3xl font-gaming font-bold text-white">${discountedPrice.toFixed(2)}</span>
                  {game.discount > 0 && (
                    <div className="flex flex-col">
                      <Badge variant="discount">-{game.discount}%</Badge>
                      <span className="text-gray-500 text-sm line-through">${game.price.toFixed(2)}</span>
                    </div>
                  )}
                </div>
              )}
            </div>

            {/* Stats */}
            <div className="grid grid-cols-2 gap-2 text-center">
              <div className="bg-gaming-darker rounded-lg p-2">
                <div className="flex items-center justify-center gap-1 text-yellow-400 mb-0.5">
                  <Star size={12} fill="currentColor" />
                  <span className="font-bold text-sm">{game.averageRating.toFixed(1)}</span>
                </div>
                <p className="text-gray-600 text-xs">Rating</p>
              </div>
              <div className="bg-gaming-darker rounded-lg p-2">
                <div className="flex items-center justify-center gap-1 text-primary-400 mb-0.5">
                  <Users size={12} />
                  <span className="font-bold text-sm">{(game.purchaseCount / 1000).toFixed(1)}k</span>
                </div>
                <p className="text-gray-600 text-xs">Owners</p>
              </div>
            </div>

            {/* Actions */}
            <div className="space-y-2">
              {owned ? (
                <button className="btn-primary w-full justify-center bg-emerald-600 hover:bg-emerald-500 shadow-none" disabled>
                  <Check size={16} /> Owned
                </button>
              ) : cartAlready ? (
                <Link to="/cart" className="btn-primary w-full justify-center">
                  <ShoppingCart size={16} /> Go to Cart
                </Link>
              ) : (
                <button onClick={handleCart} disabled={adding} className="btn-primary w-full justify-center">
                  {adding ? <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><ShoppingCart size={16} /> {game.price === 0 ? 'Add to Library' : 'Add to Cart'}</>}
                </button>
              )}
              <button
                onClick={handleWishlist}
                disabled={wishlisting}
                className={`btn-secondary w-full justify-center ${wishlistActive ? 'border-accent-600 text-accent-400' : ''}`}
              >
                <Heart size={16} fill={wishlistActive ? 'currentColor' : 'none'} />
                {wishlistActive ? 'In Wishlist' : 'Add to Wishlist'}
              </button>
            </div>

            <div className="flex items-center justify-center gap-2 text-gray-600 text-xs">
              <Zap size={12} />
              <span>Instant access after purchase</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default GameDetail;
