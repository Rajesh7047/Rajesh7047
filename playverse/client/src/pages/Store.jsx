import { useState, useEffect, useCallback } from 'react';
import { useSearchParams } from 'react-router-dom';
import { Filter, SlidersHorizontal, X, ChevronDown, ChevronUp } from 'lucide-react';
import { gamesAPI } from '../services/api';
import GameGrid from '../components/game/GameGrid';
import { GENRES, SORT_OPTIONS } from '../utils/helpers';

const FilterSection = ({ title, children, defaultOpen = true }) => {
  const [open, setOpen] = useState(defaultOpen);
  return (
    <div className="border-b border-gaming-border pb-4 mb-4 last:border-0">
      <button
        onClick={() => setOpen(!open)}
        className="flex items-center justify-between w-full text-left mb-3"
      >
        <span className="text-gray-200 font-semibold text-sm">{title}</span>
        {open ? <ChevronUp size={14} className="text-gray-500" /> : <ChevronDown size={14} className="text-gray-500" />}
      </button>
      {open && children}
    </div>
  );
};

const Store = () => {
  const [searchParams, setSearchParams] = useSearchParams();
  const [games, setGames] = useState([]);
  const [pagination, setPagination] = useState({ total: 0, pages: 1, page: 1 });
  const [loading, setLoading] = useState(true);
  const [showFilters, setShowFilters] = useState(false);

  const selectedGenres = searchParams.get('genre')?.split(',').filter(Boolean) || [];
  const sort = searchParams.get('sort') || '-createdAt';
  const search = searchParams.get('search') || '';
  const page = parseInt(searchParams.get('page') || '1');

  const fetchGames = useCallback(async () => {
    setLoading(true);
    try {
      const { data } = await gamesAPI.getAll({
        genre: selectedGenres.join(',') || undefined,
        sort,
        search: search || undefined,
        page,
        limit: 20,
      });
      setGames(data.games);
      setPagination(data.pagination);
    } finally {
      setLoading(false);
    }
  }, [selectedGenres.join(','), sort, search, page]);

  useEffect(() => { fetchGames(); }, [fetchGames]);

  const update = (key, value) => {
    const p = new URLSearchParams(searchParams);
    if (value) p.set(key, value); else p.delete(key);
    p.set('page', '1');
    setSearchParams(p);
  };

  const toggleGenre = (genre) => {
    const next = selectedGenres.includes(genre)
      ? selectedGenres.filter((g) => g !== genre)
      : [...selectedGenres, genre];
    update('genre', next.join(','));
  };

  const Filters = () => (
    <div className="space-y-0">
      <FilterSection title="Genre">
        <div className="flex flex-wrap gap-1.5">
          {GENRES.map((g) => (
            <button
              key={g}
              onClick={() => toggleGenre(g)}
              className={`text-xs px-2.5 py-1 rounded-full border transition-all ${
                selectedGenres.includes(g)
                  ? 'bg-primary-600 border-primary-600 text-white'
                  : 'border-gaming-border text-gray-400 hover:border-primary-600/50 hover:text-gray-200'
              }`}
            >
              {g}
            </button>
          ))}
        </div>
      </FilterSection>

      <FilterSection title="Price" defaultOpen={false}>
        <div className="space-y-1">
          {[
            { label: 'Free to Play', value: 'free' },
            { label: 'Under $20', value: 'under20' },
            { label: '$20 – $40', value: '20-40' },
            { label: 'Over $40', value: 'over40' },
          ].map((opt) => (
            <label key={opt.value} className="flex items-center gap-2 cursor-pointer group">
              <input type="checkbox" className="accent-primary-500 w-3.5 h-3.5" />
              <span className="text-gray-400 text-sm group-hover:text-gray-200 transition-colors">{opt.label}</span>
            </label>
          ))}
        </div>
      </FilterSection>

      {(selectedGenres.length > 0 || search) && (
        <button
          onClick={() => setSearchParams({})}
          className="flex items-center gap-1 text-red-400 hover:text-red-300 text-xs mt-2"
        >
          <X size={12} /> Clear All Filters
        </button>
      )}
    </div>
  );

  return (
    <div className="min-h-screen page-container py-8">
      <div className="flex items-center justify-between mb-6">
        <div>
          <h1 className="font-gaming text-2xl font-bold text-white">
            {search ? `Results for "${search}"` : 'Game Store'}
          </h1>
          <p className="text-gray-500 text-sm mt-1">
            {loading ? 'Loading...' : `${pagination.total.toLocaleString()} games available`}
          </p>
        </div>

        <div className="flex items-center gap-3">
          {/* Sort */}
          <select
            value={sort}
            onChange={(e) => update('sort', e.target.value)}
            className="bg-gaming-card border border-gaming-border rounded-lg px-3 py-2 text-sm text-gray-200 focus:outline-none focus:border-primary-500 cursor-pointer"
          >
            {SORT_OPTIONS.map((o) => (
              <option key={o.value} value={o.value}>{o.label}</option>
            ))}
          </select>

          {/* Mobile filter toggle */}
          <button
            onClick={() => setShowFilters(!showFilters)}
            className="lg:hidden btn-secondary py-2 px-3"
          >
            <Filter size={16} /> Filters
            {selectedGenres.length > 0 && (
              <span className="ml-1 w-5 h-5 bg-primary-600 text-white text-xs rounded-full flex items-center justify-center">
                {selectedGenres.length}
              </span>
            )}
          </button>
        </div>
      </div>

      {/* Active Filters */}
      {(selectedGenres.length > 0 || search) && (
        <div className="flex flex-wrap items-center gap-2 mb-4">
          <span className="text-gray-500 text-xs">Active:</span>
          {search && (
            <span className="flex items-center gap-1 text-xs bg-gaming-card border border-gaming-border px-2 py-1 rounded-full text-gray-300">
              Search: {search}
              <button onClick={() => update('search', '')}><X size={11} className="text-gray-500 hover:text-red-400" /></button>
            </span>
          )}
          {selectedGenres.map((g) => (
            <span key={g} className="flex items-center gap-1 text-xs bg-primary-600/20 border border-primary-600/30 px-2 py-1 rounded-full text-primary-400">
              {g}
              <button onClick={() => toggleGenre(g)}><X size={11} className="hover:text-red-400" /></button>
            </span>
          ))}
        </div>
      )}

      <div className="flex gap-6">
        {/* Sidebar Filters */}
        <aside className={`w-56 shrink-0 ${showFilters ? 'block' : 'hidden'} lg:block`}>
          <div className="card p-4 sticky top-20">
            <div className="flex items-center gap-2 mb-4">
              <SlidersHorizontal size={15} className="text-primary-400" />
              <h2 className="font-gaming font-semibold text-white text-sm">Filters</h2>
            </div>
            <Filters />
          </div>
        </aside>

        {/* Main Content */}
        <main className="flex-1 min-w-0">
          <GameGrid games={games} loading={loading} cols="wide" />

          {/* Pagination */}
          {pagination.pages > 1 && (
            <div className="flex justify-center gap-2 mt-8">
              <button
                disabled={page <= 1}
                onClick={() => update('page', String(page - 1))}
                className="btn-secondary py-2 px-3 text-sm disabled:opacity-40"
              >
                Prev
              </button>
              {Array.from({ length: Math.min(pagination.pages, 7) }, (_, i) => {
                const p = i + 1;
                return (
                  <button
                    key={p}
                    onClick={() => update('page', String(p))}
                    className={`w-9 h-9 rounded-lg text-sm font-medium transition-all ${
                      p === page ? 'bg-primary-600 text-white' : 'btn-secondary py-2 px-0'
                    }`}
                  >
                    {p}
                  </button>
                );
              })}
              <button
                disabled={page >= pagination.pages}
                onClick={() => update('page', String(page + 1))}
                className="btn-secondary py-2 px-3 text-sm disabled:opacity-40"
              >
                Next
              </button>
            </div>
          )}
        </main>
      </div>
    </div>
  );
};

export default Store;
