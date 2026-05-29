import { useState, useEffect } from 'react';
import { useNavigate, useSearchParams, Link } from 'react-router-dom';
import { Eye, EyeOff, Gamepad2, Mail, Lock, User, ArrowRight } from 'lucide-react';
import toast from 'react-hot-toast';
import { authAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';

const InputField = ({ icon: Icon, type = 'text', placeholder, value, onChange, error, right }) => (
  <div className="space-y-1">
    <div className={`flex items-center gap-3 bg-gaming-darker border ${error ? 'border-red-500' : 'border-gaming-border focus-within:border-primary-500'} rounded-lg px-4 py-3 transition-all`}>
      <Icon size={16} className="text-gray-500 shrink-0" />
      <input
        type={type}
        placeholder={placeholder}
        value={value}
        onChange={onChange}
        className="flex-1 bg-transparent text-gray-100 placeholder-gray-500 outline-none text-sm"
      />
      {right}
    </div>
    {error && <p className="text-red-400 text-xs pl-1">{error}</p>}
  </div>
);

const Auth = () => {
  const [params] = useSearchParams();
  const navigate = useNavigate();
  const { login, isAuthenticated } = useAuth();
  const [mode, setMode] = useState(params.get('mode') === 'register' ? 'register' : 'login');
  const [showPass, setShowPass] = useState(false);
  const [loading, setLoading] = useState(false);
  const [form, setForm] = useState({ username: '', email: '', password: '' });
  const [errors, setErrors] = useState({});

  useEffect(() => {
    if (isAuthenticated) navigate('/');
  }, [isAuthenticated, navigate]);

  useEffect(() => {
    setMode(params.get('mode') === 'register' ? 'register' : 'login');
    setForm({ username: '', email: '', password: '' });
    setErrors({});
  }, [params]);

  const set = (field) => (e) => setForm((f) => ({ ...f, [field]: e.target.value }));

  const validate = () => {
    const e = {};
    if (!form.email) e.email = 'Email is required';
    else if (!/\S+@\S+\.\S+/.test(form.email)) e.email = 'Invalid email format';
    if (!form.password) e.password = 'Password is required';
    else if (form.password.length < 6) e.password = 'Minimum 6 characters';
    if (mode === 'register') {
      if (!form.username) e.username = 'Username is required';
      else if (form.username.length < 3) e.username = 'Minimum 3 characters';
    }
    return e;
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    const errs = validate();
    if (Object.keys(errs).length) { setErrors(errs); return; }
    setErrors({});
    setLoading(true);
    try {
      const fn = mode === 'register' ? authAPI.register : authAPI.login;
      const { data } = await fn(form);
      login(data);
      toast.success(data.message || (mode === 'register' ? 'Welcome to PlayVerse!' : 'Welcome back!'));
      navigate('/');
    } catch (err) {
      const msg = err?.response?.data?.message || 'Something went wrong.';
      toast.error(msg);
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center px-4 py-12">
      {/* Background */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 bg-primary-600/5 rounded-full blur-3xl" />
        <div className="absolute bottom-1/4 right-1/4 w-96 h-96 bg-accent-600/5 rounded-full blur-3xl" />
      </div>

      <div className="w-full max-w-md relative">
        {/* Logo */}
        <div className="text-center mb-8">
          <Link to="/" className="inline-flex items-center gap-2 mb-6">
            <div className="w-10 h-10 bg-primary-600 rounded-xl flex items-center justify-center shadow-glow">
              <Gamepad2 size={22} className="text-white" />
            </div>
            <span className="font-gaming font-bold text-white text-2xl">
              Play<span className="text-gradient">Verse</span>
            </span>
          </Link>
          <h1 className="font-gaming text-2xl font-bold text-white">
            {mode === 'register' ? 'Create Your Account' : 'Welcome Back'}
          </h1>
          <p className="text-gray-500 mt-1 text-sm">
            {mode === 'register' ? 'Join millions of gamers on PlayVerse' : 'Sign in to your gaming universe'}
          </p>
        </div>

        {/* Card */}
        <div className="card p-8 shadow-card">
          {/* Mode Tabs */}
          <div className="flex bg-gaming-darker rounded-lg p-1 mb-6">
            {['login', 'register'].map((m) => (
              <button
                key={m}
                onClick={() => navigate(`/auth?mode=${m}`)}
                className={`flex-1 py-2.5 rounded-md text-sm font-semibold transition-all ${
                  mode === m ? 'bg-primary-600 text-white shadow-glow' : 'text-gray-400 hover:text-gray-200'
                }`}
              >
                {m === 'login' ? 'Sign In' : 'Register'}
              </button>
            ))}
          </div>

          <form onSubmit={handleSubmit} className="space-y-4">
            {mode === 'register' && (
              <InputField
                icon={User}
                placeholder="Choose a username"
                value={form.username}
                onChange={set('username')}
                error={errors.username}
              />
            )}
            <InputField
              icon={Mail}
              type="email"
              placeholder="Email address"
              value={form.email}
              onChange={set('email')}
              error={errors.email}
            />
            <InputField
              icon={Lock}
              type={showPass ? 'text' : 'password'}
              placeholder="Password"
              value={form.password}
              onChange={set('password')}
              error={errors.password}
              right={
                <button type="button" onClick={() => setShowPass(!showPass)} className="text-gray-500 hover:text-gray-300">
                  {showPass ? <EyeOff size={15} /> : <Eye size={15} />}
                </button>
              }
            />

            {mode === 'login' && (
              <div className="text-right">
                <a href="#" className="text-primary-400 hover:text-primary-300 text-xs">Forgot password?</a>
              </div>
            )}

            <button
              type="submit"
              disabled={loading}
              className="btn-primary w-full justify-center py-3 mt-2"
            >
              {loading ? (
                <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
              ) : (
                <>
                  {mode === 'register' ? 'Create Account' : 'Sign In'}
                  <ArrowRight size={16} />
                </>
              )}
            </button>
          </form>

          {mode === 'login' && (
            <div className="mt-4 p-3 bg-gaming-darker rounded-lg border border-gaming-border">
              <p className="text-gray-500 text-xs text-center mb-1">Demo Credentials</p>
              <p className="text-gray-400 text-xs text-center">
                User: <code className="text-primary-400">demo@playverse.com</code> / <code className="text-primary-400">User@123</code>
              </p>
              <p className="text-gray-400 text-xs text-center mt-0.5">
                Admin: <code className="text-accent-400">admin@playverse.com</code> / <code className="text-accent-400">Admin@123</code>
              </p>
            </div>
          )}
        </div>

        <p className="text-center text-gray-500 text-sm mt-6">
          {mode === 'register' ? 'Already have an account? ' : "Don't have an account? "}
          <button
            onClick={() => navigate(`/auth?mode=${mode === 'register' ? 'login' : 'register'}`)}
            className="text-primary-400 hover:text-primary-300 font-medium"
          >
            {mode === 'register' ? 'Sign in' : 'Create one'}
          </button>
        </p>
      </div>
    </div>
  );
};

export default Auth;
