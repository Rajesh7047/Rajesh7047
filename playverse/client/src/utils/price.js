export function getFinalPrice(game) {
  if (game.finalPrice !== undefined) return game.finalPrice;
  if (!game.discountPercent) return game.price;
  return Math.round(game.price * (1 - game.discountPercent / 100) * 100) / 100;
}

export function formatPrice(amount) {
  if (amount === 0) return 'Free';
  return `$${amount.toFixed(2)}`;
}
