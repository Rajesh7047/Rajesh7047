import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { ArrowRight, Zap, Shield, Download, Star, TrendingUp, ChevronLeft, ChevronRight } from 'lucide-react';
import { gamesAPI } from '../services/api';
import GameGrid from '../components/game/GameGrid';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { formatPrice, getDiscountedPrice } from '../utils/helpers';
import Badge from '../components/ui/Badge';

const HeroSlide = ({ game }) => {
  const price = getDiscountedPrice(game.price, game.discount);
  return (
    <div className="relative h-[520px] overflow-hidden rounded-2xl">
      <img
        src={game.coverImage}
        alt={game.title}
        className="w-full h-full object-cover"
      />
      <div className="absolute inset-0 bg-hero-gradient" />
      <div className="absolute inset-0 flex flex-col justify-end p-8">
        <div className="max-w-xl animate-slide-up">
          {game.isFeatured && <Badge variant="featured" className="mb-3">Featured Game</Badge>}
          <h2 className="font-gaming text-4xl md:text-5xl font-bold text-white mb-3 leading-tight">
            {game.title}
          </h2>
          <p className="text-gray-300 mb-5 line-clamp-2 text-sm md:text-base">{game.shortDescription || game.description?.slice(0, 150)}</p>
          <div className="flex items-center gap-4">
            <Link
              to={`/game/${game.slug}`}
              className="btn-primary"
            >
              {game.price === 0 ? 'Play Free' : `Buy for $${price.toFixed(2)}`}
              <ArrowRight size={16} />
            </Link>
            <div className="flex items-center gap-2 text-gray-300">
              {game.genre?.slice(0, 2).map((g) => (
                <Badge key={g} variant="genre">{g}</Badge>
              ))}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

const FeatureCard = ({ icon: Icon, title, desc }) => (
  <div className="glass-card p-6 flex items-start gap-4">
    <div className="w-12 h-12 bg-primary-600/20 border border-primary-600/30 rounded-xl flex items-center justify-center shrink-0">
      <Icon size={22} className="text-primary-400" />
    </div>
    <div>
      <h3 className="font-gaming font-semibold text-white mb-1">{title}</h3>
      <p className="text-gray-500 text-sm leading-relaxed">{desc}</p>
    </div>
  </div>
);

const Home = () => {
  const [featured, setFeatured] = useState([]);
  const [topRated, setTopRated] = useState([]);
  const [newGames, setNewGames] = useState([]);
  const [loading, setLoading] = useState(true);
  const [heroIdx, setHeroIdx] = useState(0);

  useEffect(() => {
    const load = async () => {
      try {
        const [featuredRes, topRes, newRes] = await Promise.all([
          gamesAPI.getFeatured(),
          gamesAPI.getTopRated(),
          gamesAPI.getAll({ limit: 10, sort: '-createdAt' }),
        ]);
        setFeatured(featuredRes.data.games);
        setTopRated(topRes.data.games);
        setNewGames(newRes.data.games);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, []);

  useEffect(() => {
    if (featured.length <= 1) return;
    const t = setInterval(() => setHeroIdx((i) => (i + 1) % featured.length), 5000);
    return () => clearInterval(t);
  }, [featured]);

  if (loading) return (
    <div className="min-h-screen flex items-center justify-center">
      <LoadingSpinner size="lg" text="Loading PlayVerse..." />
    </div>
  );

  return (
    <div className="min-h-screen">
      {/* Hero Section */}
      <section className="page-container pt-6 pb-10">
        {featured.length > 0 && (
          <div className="relative">
            <HeroSlide game={featured[heroIdx]} />
            {featured.length > 1 && (
              <>
                <button
                  onClick={() => setHeroIdx((i) => (i - 1 + featured.length) % featured.length)}
                  className="absolute left-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/60 rounded-full flex items-center justify-center text-white hover:bg-black/80 transition-all"
                >
                  <ChevronLeft size={20} />
                </button>
                <button
                  onClick={() => setHeroIdx((i) => (i + 1) % featured.length)}
                  className="absolute right-4 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/60 rounded-full flex items-center justify-center text-white hover:bg-black/80 transition-all"
                >
                  <ChevronRight size={20} />
                </button>
                <div className="flex justify-center gap-1.5 mt-4">
                  {featured.map((_, i) => (
                    <button
                      key={i}
                      onClick={() => setHeroIdx(i)}
                      className={`rounded-full transition-all ${i === heroIdx ? 'w-6 h-2 bg-primary-500' : 'w-2 h-2 bg-gray-600 hover:bg-gray-400'}`}
                    />
                  ))}
                </div>
              </>
            )}
          </div>
        )}
      </section>

      {/* Features */}
      <section className="page-container pb-12">
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
          <FeatureCard icon={Zap} title="Instant Access" desc="Download and play your games immediately after purchase." />
          <FeatureCard icon={Shield} title="Secure Payments" desc="Your transactions are protected with industry-standard encryption." />
          <FeatureCard icon={Download} title="Cloud Library" desc="Access your entire game library from any device, anytime." />
          <FeatureCard icon={Star} title="Curated Selection" desc="Hand-picked titles across every genre for all types of gamers." />
        </div>
      </section>

      {/* Top Rated */}
      <section className="page-container pb-12">
        <div className="flex items-center justify-between mb-6">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <TrendingUp size={18} className="text-primary-400" />
              <h2 className="section-title mb-0">Top Rated</h2>
            </div>
            <p className="text-gray-500 text-sm">Highest rated games by our community</p>
          </div>
          <Link to="/store?sort=-averageRating" className="btn-ghost text-sm">
            View All <ArrowRight size={14} />
          </Link>
        </div>
        <GameGrid games={topRated} cols="wide" />
      </section>

      {/* New Releases */}
      <section className="page-container pb-12">
        <div className="flex items-center justify-between mb-6">
          <div>
            <div className="flex items-center gap-2 mb-1">
              <Zap size={18} className="text-accent-400" />
              <h2 className="section-title mb-0">New Releases</h2>
            </div>
            <p className="text-gray-500 text-sm">Fresh titles just added to the store</p>
          </div>
          <Link to="/store?sort=-createdAt" className="btn-ghost text-sm">
            View All <ArrowRight size={14} />
          </Link>
        </div>
        <GameGrid games={newGames} />
      </section>

      {/* CTA Banner */}
      <section className="page-container pb-16">
        <div className="relative overflow-hidden rounded-2xl border border-gaming-border bg-gradient-to-r from-primary-900/40 via-gaming-card to-accent-900/40 p-10 text-center">
          <div className="absolute inset-0 opacity-5" style={{ backgroundImage: 'radial-gradient(circle, white 1px, transparent 1px)', backgroundSize: '30px 30px' }} />
          <h2 className="font-gaming text-3xl md:text-4xl font-bold text-white mb-3 relative">
            Ready to <span className="text-gradient">Level Up?</span>
          </h2>
          <p className="text-gray-400 mb-6 max-w-lg mx-auto relative">
            Join millions of gamers on PlayVerse. Create your free account and start building your ultimate game library today.
          </p>
          <div className="flex items-center justify-center gap-4 relative">
            <Link to="/store" className="btn-primary">
              Browse Store <ArrowRight size={16} />
            </Link>
            <Link to="/auth?mode=register" className="btn-secondary">
              Create Account
            </Link>
          </div>
        </div>
      </section>
    </div>
  );
};

export default Home;
