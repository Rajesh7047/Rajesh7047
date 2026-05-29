import { Star } from 'lucide-react';

const StarRating = ({ rating = 0, size = 14, showCount = false, count = 0, interactive = false, onRate }) => {
  const stars = Array.from({ length: 5 }, (_, i) => {
    const filled = i < Math.floor(rating);
    const half = !filled && i < rating;
    return { filled, half };
  });

  return (
    <div className="flex items-center gap-1">
      <div className="flex items-center gap-0.5">
        {stars.map((s, i) => (
          <Star
            key={i}
            size={size}
            className={`transition-colors ${
              interactive ? 'cursor-pointer hover:text-yellow-300' : ''
            } ${s.filled ? 'fill-yellow-400 text-yellow-400' : 'text-gray-600'}`}
            onClick={() => interactive && onRate && onRate(i + 1)}
            fill={s.filled ? 'currentColor' : 'none'}
          />
        ))}
      </div>
      {rating > 0 && (
        <span className="text-gray-400 text-sm ml-1 font-medium">{rating.toFixed(1)}</span>
      )}
      {showCount && count > 0 && (
        <span className="text-gray-500 text-xs">({count.toLocaleString()})</span>
      )}
    </div>
  );
};

export default StarRating;
