const variants = {
  genre: 'bg-primary-600/20 text-primary-400 border-primary-600/30',
  discount: 'bg-green-600/20 text-green-400 border-green-600/30',
  free: 'bg-accent-600/20 text-accent-400 border-accent-600/30',
  featured: 'bg-yellow-600/20 text-yellow-400 border-yellow-600/30',
  new: 'bg-blue-600/20 text-blue-400 border-blue-600/30',
  warning: 'bg-orange-600/20 text-orange-400 border-orange-600/30',
  success: 'bg-emerald-600/20 text-emerald-400 border-emerald-600/30',
};

const Badge = ({ children, variant = 'genre', className = '' }) => (
  <span className={`text-xs font-semibold px-2 py-0.5 rounded-full border ${variants[variant]} ${className}`}>
    {children}
  </span>
);

export default Badge;
