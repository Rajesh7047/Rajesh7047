export const formatPrice = (price) => {
  if (price === 0) return 'FREE';
  return `$${price.toFixed(2)}`;
};

export const formatDate = (dateStr) => {
  if (!dateStr) return 'N/A';
  return new Date(dateStr).toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
};

export const getDiscountedPrice = (price, discount) => {
  if (!discount) return price;
  return Math.round(price * (1 - discount / 100) * 100) / 100;
};

export const truncate = (str, len = 100) => {
  if (!str) return '';
  return str.length > len ? str.slice(0, len) + '...' : str;
};

export const starArray = (rating) => {
  const full = Math.floor(rating);
  const half = rating - full >= 0.5 ? 1 : 0;
  const empty = 5 - full - half;
  return { full, half, empty };
};

export const GENRES = [
  'Action', 'Adventure', 'RPG', 'Strategy', 'Simulation',
  'Sports', 'Racing', 'Horror', 'Puzzle', 'FPS', 'MMORPG',
  'Fighting', 'Platformer', 'Indie',
];

export const SORT_OPTIONS = [
  { label: 'Newest', value: '-createdAt' },
  { label: 'Most Popular', value: '-purchaseCount' },
  { label: 'Highest Rated', value: '-averageRating' },
  { label: 'Price: Low to High', value: 'price' },
  { label: 'Price: High to Low', value: '-price' },
];
