import GameCard from './GameCard';
import LoadingSpinner from '../ui/LoadingSpinner';

const GameGrid = ({ games = [], loading = false, compact = false, cols = 'default' }) => {
  const colClass = {
    default: 'grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5',
    wide: 'grid-cols-2 sm:grid-cols-3 lg:grid-cols-4',
    narrow: 'grid-cols-2 sm:grid-cols-3',
  }[cols] || 'grid-cols-2 sm:grid-cols-3 lg:grid-cols-4 xl:grid-cols-5';

  if (loading) {
    return (
      <div className="flex justify-center py-20">
        <LoadingSpinner size="lg" text="Loading games..." />
      </div>
    );
  }

  if (!games.length) {
    return (
      <div className="text-center py-20">
        <p className="text-gray-500 text-lg">No games found.</p>
        <p className="text-gray-600 text-sm mt-2">Try adjusting your filters.</p>
      </div>
    );
  }

  return (
    <div className={`grid ${colClass} gap-4`}>
      {games.map((game) => (
        <GameCard key={game._id} game={game} compact={compact} />
      ))}
    </div>
  );
};

export default GameGrid;
