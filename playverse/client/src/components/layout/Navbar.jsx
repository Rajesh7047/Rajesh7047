import { useState, useRef, useEffect } from 'react';
import { Link, NavLink, useNavigate } from 'react-router-dom';
import {
  Gamepad2, Search, ShoppingCart, Heart, User, LogOut,
  Settings, BookOpen, ChevronDown, Shield, Menu, X, Zap,
} from 'lucide-react';
import { useAuth } from '../../context/AuthContext';
import { useCart } from '../../context/CartContext';
import { gamesAPI } from '../../services/api';
import toast from 'react-hot-toast';

const Navbar = () => {
  const { user, logout, isAdmin } = useAuth();
  const { itemCount } = useCart();
  const navigate = useNavigate();
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState([]);
  const [showSearch, setShowSearch] = useState(false);
  const [showUserMenu, setShowUserMenu] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);
  const searchRef = useRef(null);
  const userMenuRef = useRef(null);
  let searchTimeout = useRef(null);

  useEffect(() => {
    const close = (e) => {
      if (!searchRef.current?.contains(e.target)) setShowSearch(false);
      if (!userMenuRef.current?.contains(e.target)) setShowUserMenu(false);
    };
    document.addEventListener('mousedown', close);
    return () => document.removeEventListener('mousedown', close);
  }, []);

  const handleSearch = async (q) => {
    setSearchQuery(q);
    clearTimeout(searchTimeout.current);
    if (!q.trim()) { setSearchResults([]); setShowSearch(false); return; }
    searchTimeout.current = setTimeout(async () => {
      try {
        const { data } = await gamesAPI.search(q);
        setSearchResults(data.games);
        setShowSearch(true);
      } catch {}
    }, 300);
  };

  const handleSearchSubmit = (e) => {
    e.preventDefault();
    if (searchQuery.trim()) {
      navigate(`/store?search=${encodeURIComponent(searchQuery.trim())}`);
      setShowSearch(false);
      setSearchQuery('');
    }
  };

  const handleLogout = () => {
    logout();
    toast.success('Logged out successfully');
    navigate('/');
    setShowUserMenu(false);
  };

  return (
    <nav className="sticky top-0 z-50 bg-gaming-darker/90 backdrop-blur-xl border-b border-gaming-border">
      <div className="page-container">
        <div className="flex items-center h-16 gap-4">
          {/* Logo */}
          <Link to="/" className="flex items-center gap-2 shrink-0 group">
            <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center group-hover:shadow-glow transition-all">
              <Gamepad2 size={18} className="text-white" />
            </div>
            <span className="font-gaming font-bold text-white text-lg hidden sm:block">
              Play<span className="text-gradient">Verse</span>
            </span>
          </Link>

          {/* Desktop Nav Links */}
          <div className="hidden md:flex items-center gap-1 ml-4">
            <NavLink to="/store" className={({ isActive }) => `nav-link px-3 py-2 rounded-lg hover:bg-gaming-card ${isActive ? 'text-white' : ''}`}>
              Store
            </NavLink>
            <NavLink to="/store?genre=Action" className={({ isActive }) => `nav-link px-3 py-2 rounded-lg hover:bg-gaming-card`}>
              Action
            </NavLink>
            <NavLink to="/store?genre=RPG" className={({ isActive }) => `nav-link px-3 py-2 rounded-lg hover:bg-gaming-card`}>
              RPG
            </NavLink>
            <NavLink to="/store?genre=Strategy" className={({ isActive }) => `nav-link px-3 py-2 rounded-lg hover:bg-gaming-card`}>
              Strategy
            </NavLink>
          </div>

          {/* Search */}
          <div ref={searchRef} className="flex-1 max-w-md relative hidden sm:block">
            <form onSubmit={handleSearchSubmit}>
              <div className="relative">
                <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
                <input
                  type="text"
                  placeholder="Search games..."
                  value={searchQuery}
                  onChange={(e) => handleSearch(e.target.value)}
                  className="w-full bg-gaming-card border border-gaming-border rounded-lg pl-9 pr-4 py-2 text-sm text-gray-200 placeholder-gray-500 focus:outline-none focus:border-primary-500 focus:ring-1 focus:ring-primary-500/30 transition-all"
                />
              </div>
            </form>
            {showSearch && searchResults.length > 0 && (
              <div className="absolute top-full mt-1 w-full bg-gaming-card border border-gaming-border rounded-xl overflow-hidden shadow-2xl z-50 animate-fade-in">
                {searchResults.map((g) => (
                  <Link
                    key={g._id}
                    to={`/game/${g.slug}`}
                    onClick={() => { setShowSearch(false); setSearchQuery(''); }}
                    className="flex items-center gap-3 px-4 py-2.5 hover:bg-gaming-darker transition-colors"
                  >
                    <img src={g.coverImage} alt={g.title} className="w-8 h-10 object-cover rounded" />
                    <div className="flex-1 min-w-0">
                      <p className="text-white text-sm font-medium truncate">{g.title}</p>
                      <p className="text-gray-500 text-xs">{g.genre?.[0]}</p>
                    </div>
                    <span className="text-primary-400 text-sm font-semibold shrink-0">
                      {g.price === 0 ? 'FREE' : `$${g.price.toFixed(2)}`}
                    </span>
                  </Link>
                ))}
              </div>
            )}
          </div>

          {/* Right side */}
          <div className="flex items-center gap-2 ml-auto">
            {/* Cart */}
            <Link
              to="/cart"
              className="relative p-2 text-gray-400 hover:text-white hover:bg-gaming-card rounded-lg transition-all"
            >
              <ShoppingCart size={20} />
              {itemCount > 0 && (
                <span className="absolute -top-1 -right-1 w-5 h-5 bg-primary-600 text-white text-xs rounded-full flex items-center justify-center font-bold">
                  {itemCount > 9 ? '9+' : itemCount}
                </span>
              )}
            </Link>

            {/* Wishlist */}
            {user && (
              <Link to="/wishlist" className="p-2 text-gray-400 hover:text-accent-400 hover:bg-gaming-card rounded-lg transition-all hidden sm:block">
                <Heart size={20} />
              </Link>
            )}

            {/* User */}
            {user ? (
              <div ref={userMenuRef} className="relative">
                <button
                  onClick={() => setShowUserMenu(!showUserMenu)}
                  className="flex items-center gap-2 px-3 py-2 rounded-lg hover:bg-gaming-card transition-all"
                >
                  <div className="w-7 h-7 bg-primary-600 rounded-full flex items-center justify-center text-white text-xs font-bold">
                    {user.username?.[0]?.toUpperCase()}
                  </div>
                  <span className="text-gray-300 text-sm font-medium hidden md:block">{user.username}</span>
                  <ChevronDown size={14} className="text-gray-500 hidden md:block" />
                </button>
                {showUserMenu && (
                  <div className="absolute right-0 top-full mt-1 w-52 bg-gaming-card border border-gaming-border rounded-xl overflow-hidden shadow-2xl z-50 animate-fade-in">
                    <div className="px-4 py-3 border-b border-gaming-border">
                      <p className="text-white font-semibold text-sm">{user.username}</p>
                      <p className="text-gray-500 text-xs truncate">{user.email}</p>
                    </div>
                    <div className="py-1">
                      <Link to="/library" onClick={() => setShowUserMenu(false)} className="flex items-center gap-2 px-4 py-2.5 text-gray-300 hover:bg-gaming-darker hover:text-white text-sm transition-colors">
                        <BookOpen size={15} /> My Library
                      </Link>
                      <Link to="/orders" onClick={() => setShowUserMenu(false)} className="flex items-center gap-2 px-4 py-2.5 text-gray-300 hover:bg-gaming-darker hover:text-white text-sm transition-colors">
                        <Zap size={15} /> Orders
                      </Link>
                      <Link to="/wishlist" onClick={() => setShowUserMenu(false)} className="flex items-center gap-2 px-4 py-2.5 text-gray-300 hover:bg-gaming-darker hover:text-white text-sm transition-colors">
                        <Heart size={15} /> Wishlist
                      </Link>
                      <Link to="/profile" onClick={() => setShowUserMenu(false)} className="flex items-center gap-2 px-4 py-2.5 text-gray-300 hover:bg-gaming-darker hover:text-white text-sm transition-colors">
                        <Settings size={15} /> Profile Settings
                      </Link>
                      {isAdmin && (
                        <>
                          <div className="my-1 border-t border-gaming-border" />
                          <Link to="/admin" onClick={() => setShowUserMenu(false)} className="flex items-center gap-2 px-4 py-2.5 text-primary-400 hover:bg-gaming-darker text-sm transition-colors">
                            <Shield size={15} /> Admin Panel
                          </Link>
                        </>
                      )}
                      <div className="my-1 border-t border-gaming-border" />
                      <button
                        onClick={handleLogout}
                        className="flex items-center gap-2 px-4 py-2.5 text-red-400 hover:bg-gaming-darker w-full text-left text-sm transition-colors"
                      >
                        <LogOut size={15} /> Logout
                      </button>
                    </div>
                  </div>
                )}
              </div>
            ) : (
              <div className="flex items-center gap-2">
                <Link to="/auth?mode=login" className="btn-ghost text-sm">Login</Link>
                <Link to="/auth?mode=register" className="btn-primary text-sm py-2 px-4">
                  Sign Up
                </Link>
              </div>
            )}

            {/* Mobile Menu */}
            <button
              onClick={() => setMobileOpen(!mobileOpen)}
              className="p-2 text-gray-400 hover:text-white rounded-lg md:hidden"
            >
              {mobileOpen ? <X size={20} /> : <Menu size={20} />}
            </button>
          </div>
        </div>

        {/* Mobile Menu Dropdown */}
        {mobileOpen && (
          <div className="md:hidden pb-4 border-t border-gaming-border mt-2 pt-4 animate-fade-in">
            <form onSubmit={handleSearchSubmit} className="mb-3">
              <div className="relative">
                <Search size={15} className="absolute left-3 top-1/2 -translate-y-1/2 text-gray-500" />
                <input
                  type="text"
                  placeholder="Search games..."
                  value={searchQuery}
                  onChange={(e) => handleSearch(e.target.value)}
                  className="w-full bg-gaming-card border border-gaming-border rounded-lg pl-9 pr-4 py-2 text-sm text-gray-200 placeholder-gray-500 focus:outline-none focus:border-primary-500"
                />
              </div>
            </form>
            <div className="flex flex-col gap-1">
              {['Store', 'Action', 'RPG', 'Strategy'].map((item) => (
                <NavLink
                  key={item}
                  to={item === 'Store' ? '/store' : `/store?genre=${item}`}
                  onClick={() => setMobileOpen(false)}
                  className="px-3 py-2 text-gray-300 hover:text-white hover:bg-gaming-card rounded-lg text-sm"
                >
                  {item}
                </NavLink>
              ))}
            </div>
          </div>
        )}
      </div>
    </nav>
  );
};

export default Navbar;
