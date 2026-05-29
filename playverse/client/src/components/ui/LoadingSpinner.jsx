const LoadingSpinner = ({ size = 'md', text = '' }) => {
  const sizes = { sm: 'w-4 h-4', md: 'w-8 h-8', lg: 'w-12 h-12' };
  return (
    <div className="flex flex-col items-center justify-center gap-3">
      <div className={`${sizes[size]} border-2 border-gaming-border border-t-primary-500 rounded-full animate-spin`} />
      {text && <p className="text-gray-400 text-sm">{text}</p>}
    </div>
  );
};

export const PageLoader = () => (
  <div className="min-h-screen flex items-center justify-center bg-gaming-dark">
    <div className="text-center">
      <div className="w-16 h-16 border-2 border-gaming-border border-t-primary-500 rounded-full animate-spin mx-auto mb-4" />
      <p className="text-gray-400 font-gaming text-lg">Loading PlayVerse...</p>
    </div>
  </div>
);

export default LoadingSpinner;
