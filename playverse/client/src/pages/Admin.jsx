import { useState, useEffect, useCallback } from 'react';
import { Link } from 'react-router-dom';
import {
  LayoutDashboard, Gamepad2, Users, ShoppingBag, Plus, Edit2,
  Trash2, Eye, TrendingUp, DollarSign, Star, ToggleLeft, ToggleRight,
  ChevronLeft, Save, X, Check,
} from 'lucide-react';
import toast from 'react-hot-toast';
import { gamesAPI, ordersAPI, adminAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { formatDate, GENRES } from '../utils/helpers';
import Badge from '../components/ui/Badge';

const StatCard = ({ icon: Icon, label, value, color = 'primary' }) => {
  const colors = {
    primary: 'bg-primary-600/20 text-primary-400 border-primary-600/30',
    green: 'bg-emerald-600/20 text-emerald-400 border-emerald-600/30',
    accent: 'bg-accent-600/20 text-accent-400 border-accent-600/30',
    yellow: 'bg-yellow-600/20 text-yellow-400 border-yellow-600/30',
  };
  return (
    <div className="card p-5 flex items-center gap-4">
      <div className={`w-12 h-12 rounded-xl border flex items-center justify-center ${colors[color]}`}>
        <Icon size={22} />
      </div>
      <div>
        <p className="text-gray-500 text-sm">{label}</p>
        <p className="font-gaming font-bold text-white text-2xl">{value}</p>
      </div>
    </div>
  );
};

const defaultGameForm = {
  title: '', description: '', shortDescription: '', price: '', discount: 0,
  genre: [], developer: '', publisher: '', releaseDate: '', coverImage: '',
  fileSize: '', isFeatured: false, ageRating: 'T',
  systemRequirements: {
    minimum: { os: '', processor: '', memory: '', graphics: '', storage: '' },
    recommended: { os: '', processor: '', memory: '', graphics: '', storage: '' },
  },
};

const GameForm = ({ game, onSave, onCancel }) => {
  const [form, setForm] = useState(game ? { ...game, genre: game.genre || [], price: String(game.price) } : defaultGameForm);
  const [saving, setSaving] = useState(false);

  const set = (key) => (e) => setForm((f) => ({ ...f, [key]: e.target.type === 'checkbox' ? e.target.checked : e.target.value }));

  const toggleGenre = (g) => setForm((f) => ({
    ...f,
    genre: f.genre.includes(g) ? f.genre.filter((x) => x !== g) : [...f.genre, g],
  }));

  const setSysReq = (tier, key) => (e) => setForm((f) => ({
    ...f,
    systemRequirements: { ...f.systemRequirements, [tier]: { ...f.systemRequirements[tier], [key]: e.target.value } },
  }));

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (!form.title || !form.price || !form.developer || !form.coverImage || form.genre.length === 0) {
      toast.error('Please fill all required fields');
      return;
    }
    setSaving(true);
    try {
      const payload = { ...form, price: parseFloat(form.price), discount: parseInt(form.discount) || 0 };
      if (game?._id) {
        await gamesAPI.update(game._id, payload);
        toast.success('Game updated!');
      } else {
        await gamesAPI.create(payload);
        toast.success('Game created!');
      }
      onSave();
    } catch (err) {
      toast.error(err?.response?.data?.message || 'Failed');
    } finally {
      setSaving(false);
    }
  };

  const Input = ({ label, field, type = 'text', required = false, placeholder = '' }) => (
    <div className="space-y-1">
      <label className="text-gray-400 text-xs">{label}{required && <span className="text-red-400 ml-1">*</span>}</label>
      <input type={type} value={form[field] || ''} onChange={set(field)} placeholder={placeholder} className="input-field py-2 text-sm" />
    </div>
  );

  return (
    <form onSubmit={handleSubmit} className="space-y-6">
      <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
        <Input label="Title" field="title" required placeholder="Game title" />
        <Input label="Developer" field="developer" required placeholder="Studio name" />
        <Input label="Publisher" field="publisher" placeholder="Publisher name" />
        <Input label="Price ($)" field="price" type="number" required placeholder="29.99" />
        <Input label="Discount (%)" field="discount" type="number" placeholder="0-100" />
        <Input label="Release Date" field="releaseDate" type="date" />
        <Input label="Cover Image URL" field="coverImage" required placeholder="https://..." />
        <Input label="File Size" field="fileSize" placeholder="e.g. 12 GB" />
      </div>

      <div className="space-y-1">
        <label className="text-gray-400 text-xs">Short Description</label>
        <input value={form.shortDescription || ''} onChange={set('shortDescription')} placeholder="One-line description" className="input-field py-2 text-sm" />
      </div>

      <div className="space-y-1">
        <label className="text-gray-400 text-xs">Full Description<span className="text-red-400 ml-1">*</span></label>
        <textarea value={form.description || ''} onChange={set('description')} rows={4} placeholder="Full game description..." className="input-field resize-none text-sm" />
      </div>

      <div>
        <label className="text-gray-400 text-xs mb-2 block">Genres<span className="text-red-400 ml-1">*</span></label>
        <div className="flex flex-wrap gap-1.5">
          {GENRES.map((g) => (
            <button type="button" key={g} onClick={() => toggleGenre(g)}
              className={`text-xs px-2.5 py-1 rounded-full border transition-all ${form.genre.includes(g) ? 'bg-primary-600 border-primary-600 text-white' : 'border-gaming-border text-gray-400 hover:border-primary-500/50'}`}>
              {g}
            </button>
          ))}
        </div>
      </div>

      <div className="flex items-center gap-3">
        <div className="flex items-center gap-2">
          <label className="text-gray-400 text-xs">Featured</label>
          <button type="button" onClick={() => setForm((f) => ({ ...f, isFeatured: !f.isFeatured }))}
            className={`${form.isFeatured ? 'text-primary-400' : 'text-gray-600'}`}>
            {form.isFeatured ? <ToggleRight size={24} /> : <ToggleLeft size={24} />}
          </button>
        </div>
        <div className="space-y-1">
          <label className="text-gray-400 text-xs">Age Rating</label>
          <select value={form.ageRating} onChange={set('ageRating')} className="bg-gaming-darker border border-gaming-border rounded-lg px-3 py-1.5 text-sm text-gray-200 focus:outline-none focus:border-primary-500">
            {['E', 'E10+', 'T', 'M', 'AO', 'RP'].map((r) => <option key={r}>{r}</option>)}
          </select>
        </div>
      </div>

      {/* System Requirements */}
      <div>
        <p className="text-gray-300 font-semibold text-sm mb-3">System Requirements</p>
        {['minimum', 'recommended'].map((tier) => (
          <div key={tier} className="mb-4">
            <p className="text-gray-500 text-xs capitalize mb-2 font-medium">{tier}</p>
            <div className="grid grid-cols-2 md:grid-cols-3 gap-2">
              {['os', 'processor', 'memory', 'graphics', 'storage'].map((k) => (
                <input key={k} value={form.systemRequirements[tier][k]} onChange={setSysReq(tier, k)}
                  placeholder={k.charAt(0).toUpperCase() + k.slice(1)} className="input-field py-1.5 text-xs" />
              ))}
            </div>
          </div>
        ))}
      </div>

      <div className="flex gap-3">
        <button type="submit" disabled={saving} className="btn-primary">
          {saving ? <div className="w-4 h-4 border-2 border-white/30 border-t-white rounded-full animate-spin" /> : <><Save size={15} /> {game ? 'Update Game' : 'Create Game'}</>}
        </button>
        <button type="button" onClick={onCancel} className="btn-secondary"><X size={15} /> Cancel</button>
      </div>
    </form>
  );
};

const Admin = () => {
  const { isAdmin } = useAuth();
  const [section, setSection] = useState('dashboard');
  const [stats, setStats] = useState(null);
  const [games, setGames] = useState([]);
  const [users, setUsers] = useState([]);
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(false);
  const [editGame, setEditGame] = useState(null);
  const [showForm, setShowForm] = useState(false);

  const loadSection = useCallback(async (s) => {
    setLoading(true);
    try {
      if (s === 'dashboard') {
        const { data } = await ordersAPI.adminGetStats();
        setStats(data);
      } else if (s === 'games') {
        const { data } = await gamesAPI.adminGetAll();
        setGames(data.games);
      } else if (s === 'users') {
        const { data } = await adminAPI.getUsers();
        setUsers(data.users);
      } else if (s === 'orders') {
        const { data } = await ordersAPI.adminGetAll();
        setOrders(data.orders);
      }
    } finally {
      setLoading(false);
    }
  }, []);

  useEffect(() => { loadSection(section); }, [section, loadSection]);

  const handleDelete = async (id, title) => {
    if (!confirm(`Remove "${title}" from listings?`)) return;
    try {
      await gamesAPI.delete(id);
      toast.success('Game removed from listings.');
      setGames((g) => g.filter((x) => x._id !== id));
    } catch { toast.error('Failed'); }
  };

  const handleToggleUser = async (id, isActive, username) => {
    try {
      await adminAPI.updateUserStatus(id, !isActive);
      setUsers((u) => u.map((user) => user._id === id ? { ...user, isActive: !isActive } : user));
      toast.success(`${username} ${!isActive ? 'activated' : 'deactivated'}`);
    } catch { toast.error('Failed'); }
  };

  if (!isAdmin) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <p className="text-gray-400 text-lg">Admin access required.</p>
        <Link to="/" className="btn-primary inline-flex mt-4">Go Home</Link>
      </div>
    </div>
  );

  const navItems = [
    { id: 'dashboard', icon: LayoutDashboard, label: 'Dashboard' },
    { id: 'games', icon: Gamepad2, label: 'Games' },
    { id: 'users', icon: Users, label: 'Users' },
    { id: 'orders', icon: ShoppingBag, label: 'Orders' },
  ];

  return (
    <div className="min-h-screen flex">
      {/* Sidebar */}
      <aside className="w-56 bg-gaming-darker border-r border-gaming-border shrink-0 sticky top-16 h-[calc(100vh-4rem)]">
        <div className="p-4">
          <p className="text-gray-500 text-xs font-semibold uppercase tracking-wider mb-3">Admin Panel</p>
          <nav className="space-y-1">
            {navItems.map(({ id, icon: Icon, label }) => (
              <button key={id} onClick={() => { setSection(id); setShowForm(false); setEditGame(null); }}
                className={`flex items-center gap-3 w-full px-3 py-2.5 rounded-lg text-sm font-medium transition-all ${section === id ? 'bg-primary-600/20 text-primary-400 border border-primary-600/30' : 'text-gray-400 hover:text-white hover:bg-gaming-card'}`}>
                <Icon size={16} /> {label}
              </button>
            ))}
          </nav>
        </div>
      </aside>

      {/* Main */}
      <main className="flex-1 p-6 overflow-auto">
        {/* Dashboard */}
        {section === 'dashboard' && (
          <div>
            <h1 className="font-gaming text-2xl font-bold text-white mb-6">Dashboard</h1>
            {loading ? <LoadingSpinner size="lg" /> : stats && (
              <div className="space-y-6">
                <div className="grid grid-cols-2 md:grid-cols-4 gap-4">
                  <StatCard icon={Users} label="Total Users" value={stats.stats.totalUsers.toLocaleString()} color="primary" />
                  <StatCard icon={Gamepad2} label="Active Games" value={stats.stats.totalGames.toLocaleString()} color="accent" />
                  <StatCard icon={ShoppingBag} label="Total Orders" value={stats.stats.totalOrders.toLocaleString()} color="yellow" />
                  <StatCard icon={DollarSign} label="Revenue" value={`$${stats.stats.totalRevenue.toFixed(0)}`} color="green" />
                </div>

                <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                  <div className="card p-5">
                    <h3 className="font-gaming font-semibold text-white mb-4 flex items-center gap-2"><TrendingUp size={16} className="text-primary-400" /> Top Games</h3>
                    <div className="space-y-3">
                      {stats.topGames.map((g) => (
                        <div key={g._id} className="flex items-center gap-3">
                          <img src={g.coverImage} alt={g.title} className="w-10 h-14 object-cover rounded" />
                          <div className="flex-1 min-w-0">
                            <p className="text-white text-sm font-medium truncate">{g.title}</p>
                            <p className="text-gray-500 text-xs">{g.purchaseCount.toLocaleString()} sales</p>
                          </div>
                          <div className="flex items-center gap-1 text-yellow-400 text-xs">
                            <Star size={11} fill="currentColor" /> {g.averageRating.toFixed(1)}
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                  <div className="card p-5">
                    <h3 className="font-gaming font-semibold text-white mb-4 flex items-center gap-2"><ShoppingBag size={16} className="text-accent-400" /> Recent Orders</h3>
                    <div className="space-y-3">
                      {stats.recentOrders.map((o) => (
                        <div key={o._id} className="flex items-center justify-between py-2 border-b border-gaming-border last:border-0">
                          <div>
                            <p className="text-white text-sm font-medium">{o.user?.username}</p>
                            <p className="text-gray-500 text-xs">{formatDate(o.createdAt)}</p>
                          </div>
                          <div className="text-right">
                            <p className="text-white text-sm font-bold">${o.totalAmount.toFixed(2)}</p>
                            <Badge variant="success" className="text-xs">{o.status}</Badge>
                          </div>
                        </div>
                      ))}
                    </div>
                  </div>
                </div>
              </div>
            )}
          </div>
        )}

        {/* Games */}
        {section === 'games' && (
          <div>
            <div className="flex items-center justify-between mb-6">
              <h1 className="font-gaming text-2xl font-bold text-white">
                {showForm ? (editGame ? 'Edit Game' : 'Add New Game') : 'Manage Games'}
              </h1>
              {!showForm ? (
                <button onClick={() => { setShowForm(true); setEditGame(null); }} className="btn-primary">
                  <Plus size={16} /> Add Game
                </button>
              ) : (
                <button onClick={() => { setShowForm(false); setEditGame(null); }} className="btn-ghost">
                  <ChevronLeft size={16} /> Back to List
                </button>
              )}
            </div>

            {showForm ? (
              <div className="card p-6">
                <GameForm
                  game={editGame}
                  onSave={() => { setShowForm(false); setEditGame(null); loadSection('games'); }}
                  onCancel={() => { setShowForm(false); setEditGame(null); }}
                />
              </div>
            ) : loading ? <LoadingSpinner size="lg" /> : (
              <div className="card overflow-hidden">
                <table className="w-full text-sm">
                  <thead className="bg-gaming-darker border-b border-gaming-border">
                    <tr>
                      {['Game', 'Price', 'Genre', 'Rating', 'Sales', 'Featured', 'Actions'].map((h) => (
                        <th key={h} className="px-4 py-3 text-left text-gray-400 font-medium text-xs">{h}</th>
                      ))}
                    </tr>
                  </thead>
                  <tbody>
                    {games.map((g) => (
                      <tr key={g._id} className="border-b border-gaming-border hover:bg-gaming-darker transition-colors">
                        <td className="px-4 py-3">
                          <div className="flex items-center gap-3">
                            <img src={g.coverImage} alt={g.title} className="w-9 h-12 object-cover rounded" />
                            <div>
                              <p className="text-white font-medium truncate max-w-[150px]">{g.title}</p>
                              <p className="text-gray-500 text-xs">{g.developer}</p>
                            </div>
                          </div>
                        </td>
                        <td className="px-4 py-3 text-white font-gaming">{g.price === 0 ? 'FREE' : `$${g.price.toFixed(2)}`}</td>
                        <td className="px-4 py-3"><div className="flex flex-wrap gap-1">{g.genre?.slice(0, 2).map((genre) => <Badge key={genre} variant="genre">{genre}</Badge>)}</div></td>
                        <td className="px-4 py-3 text-yellow-400 text-xs flex items-center gap-1 mt-3"><Star size={11} fill="currentColor" /> {g.averageRating.toFixed(1)}</td>
                        <td className="px-4 py-3 text-gray-400 text-xs">{g.purchaseCount.toLocaleString()}</td>
                        <td className="px-4 py-3">{g.isFeatured ? <Check size={14} className="text-emerald-400" /> : <X size={14} className="text-gray-600" />}</td>
                        <td className="px-4 py-3">
                          <div className="flex items-center gap-2">
                            <Link to={`/game/${g.slug}`} className="p-1.5 text-gray-500 hover:text-primary-400 hover:bg-primary-600/10 rounded-lg"><Eye size={14} /></Link>
                            <button onClick={() => { setEditGame(g); setShowForm(true); }} className="p-1.5 text-gray-500 hover:text-yellow-400 hover:bg-yellow-600/10 rounded-lg"><Edit2 size={14} /></button>
                            <button onClick={() => handleDelete(g._id, g.title)} className="p-1.5 text-gray-500 hover:text-red-400 hover:bg-red-600/10 rounded-lg"><Trash2 size={14} /></button>
                          </div>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}

        {/* Users */}
        {section === 'users' && (
          <div>
            <h1 className="font-gaming text-2xl font-bold text-white mb-6">Manage Users</h1>
            {loading ? <LoadingSpinner size="lg" /> : (
              <div className="card overflow-hidden">
                <table className="w-full text-sm">
                  <thead className="bg-gaming-darker border-b border-gaming-border">
                    <tr>{['User', 'Email', 'Role', 'Joined', 'Status', 'Actions'].map((h) => <th key={h} className="px-4 py-3 text-left text-gray-400 font-medium text-xs">{h}</th>)}</tr>
                  </thead>
                  <tbody>
                    {users.map((u) => (
                      <tr key={u._id} className="border-b border-gaming-border hover:bg-gaming-darker transition-colors">
                        <td className="px-4 py-3 flex items-center gap-3">
                          <div className="w-8 h-8 bg-primary-600/30 rounded-full flex items-center justify-center text-primary-400 font-bold text-sm">{u.username?.[0]?.toUpperCase()}</div>
                          <span className="text-white font-medium">{u.username}</span>
                        </td>
                        <td className="px-4 py-3 text-gray-400">{u.email}</td>
                        <td className="px-4 py-3">{u.role === 'admin' ? <Badge variant="featured">Admin</Badge> : <Badge variant="genre">User</Badge>}</td>
                        <td className="px-4 py-3 text-gray-500 text-xs">{formatDate(u.createdAt)}</td>
                        <td className="px-4 py-3">{u.isActive ? <Badge variant="success">Active</Badge> : <Badge variant="warning">Inactive</Badge>}</td>
                        <td className="px-4 py-3">
                          <button onClick={() => handleToggleUser(u._id, u.isActive, u.username)} className={`p-1.5 rounded-lg transition-all ${u.isActive ? 'text-gray-500 hover:text-red-400 hover:bg-red-600/10' : 'text-gray-500 hover:text-emerald-400 hover:bg-emerald-600/10'}`}>
                            {u.isActive ? <ToggleRight size={18} /> : <ToggleLeft size={18} />}
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}

        {/* Orders */}
        {section === 'orders' && (
          <div>
            <h1 className="font-gaming text-2xl font-bold text-white mb-6">All Orders</h1>
            {loading ? <LoadingSpinner size="lg" /> : (
              <div className="card overflow-hidden">
                <table className="w-full text-sm">
                  <thead className="bg-gaming-darker border-b border-gaming-border">
                    <tr>{['Order ID', 'Customer', 'Items', 'Total', 'Date', 'Status'].map((h) => <th key={h} className="px-4 py-3 text-left text-gray-400 font-medium text-xs">{h}</th>)}</tr>
                  </thead>
                  <tbody>
                    {orders.map((o) => (
                      <tr key={o._id} className="border-b border-gaming-border hover:bg-gaming-darker transition-colors">
                        <td className="px-4 py-3 text-gray-400 font-mono text-xs">#{o._id.slice(-8).toUpperCase()}</td>
                        <td className="px-4 py-3 text-white">{o.user?.username || '—'}</td>
                        <td className="px-4 py-3 text-gray-400">{o.items.length} game{o.items.length !== 1 ? 's' : ''}</td>
                        <td className="px-4 py-3 text-white font-gaming font-bold">${o.totalAmount.toFixed(2)}</td>
                        <td className="px-4 py-3 text-gray-500 text-xs">{formatDate(o.createdAt)}</td>
                        <td className="px-4 py-3"><Badge variant="success">{o.status}</Badge></td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            )}
          </div>
        )}
      </main>
    </div>
  );
};

export default Admin;
