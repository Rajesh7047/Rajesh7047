import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { BookOpen, Download, Search, Clock } from 'lucide-react';
import { useAuth } from '../context/AuthContext';
import { authAPI } from '../services/api';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { formatDate } from '../utils/helpers';
import Badge from '../components/ui/Badge';

const Library = () => {
  const { isAuthenticated } = useAuth();
  const [library, setLibrary] = useState([]);
  const [loading, setLoading] = useState(true);
  const [search, setSearch] = useState('');

  useEffect(() => {
    if (!isAuthenticated) { setLoading(false); return; }
    const load = async () => {
      try {
        const { data } = await authAPI.getMe();
        setLibrary(data.user.library || []);
      } finally {
        setLoading(false);
      }
    };
    load();
  }, [isAuthenticated]);

  if (!isAuthenticated) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <BookOpen size={48} className="text-gray-600 mx-auto mb-4" />
        <h2 className="font-gaming text-xl text-white mb-2">Sign in to view your library</h2>
        <Link to="/auth?mode=login" className="btn-primary inline-flex mt-4">Sign In</Link>
      </div>
    </div>
  );

  if (loading) return <div className="min-h-screen flex items-center justify-center"><LoadingSpinner size="lg" /></div>;

  const filtered = library.filter((item) =>
    !search || item.game?.title?.toLowerCase().includes(search.toLowerCase())
  );

  return (
    <div className="min-h-screen page-container py-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="font-gaming text-2xl font-bold text-white flex items-center gap-2">
            <BookOpen size={24} className="text-primary-400" />
            My Library
          </h1>
          <p className="text-gray-500 text-sm mt-1">{library.length} game{library.length !== 1 ? 's' : ''} in your collection</p>
        </div>
      </div>

      {library.length === 0 ? (
        <div className="text-center py-20">
          <BookOpen size={56} className="text-gray-600 mx-auto mb-4" />
          <h2 className="font-gaming text-xl text-white mb-2">Your library is empty</h2>
          <p className="text-gray-500 mb-6">Purchase games to add them to your library.</p>
          <Link to="/store" className="btn-primary inline-flex">Browse Store</Link>
        </div>
      ) : (
        <>
          {/* Search */}
          <div className="relative max-w-sm mb-6">
            <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
            <input
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search your library..."
              className="input-field pl-9 py-2.5 text-sm"
            />
          </div>

          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 xl:grid-cols-6 gap-4">
            {filtered.map((item) => {
              const game = item.game;
              if (!game) return null;
              return (
                <Link to={`/game/${game.slug}`} key={item._id || game._id} className="group">
                  <div className="card-hover">
                    <div className="relative aspect-[3/4] overflow-hidden">
                      <img src={game.coverImage} alt={game.title} className="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105" />
                      <div className="absolute inset-0 bg-gradient-to-t from-gaming-darker via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity" />
                      <div className="absolute bottom-0 left-0 right-0 p-3 translate-y-full group-hover:translate-y-0 transition-transform duration-300">
                        <button className="btn-primary w-full justify-center py-2 text-xs">
                          <Download size={12} /> Play Now
                        </button>
                      </div>
                    </div>
                    <div className="p-3">
                      <p className="text-white text-xs font-semibold font-gaming line-clamp-2 group-hover:text-primary-400 transition-colors">{game.title}</p>
                      {item.purchasedAt && (
                        <div className="flex items-center gap-1 mt-1 text-gray-600 text-xs">
                          <Clock size={10} />
                          <span>{formatDate(item.purchasedAt)}</span>
                        </div>
                      )}
                    </div>
                  </div>
                </Link>
              );
            })}
          </div>
        </>
      )}
    </div>
  );
};

export default Library;
