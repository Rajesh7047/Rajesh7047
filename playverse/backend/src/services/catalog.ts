import { Game } from "../types.js";

export const computeFinalPrice = (game: Game): number =>
  Number((game.price * (1 - game.discountPercent / 100)).toFixed(2));

export const toPublicGame = (game: Game) => {
  const totalReviews = game.reviews.length;
  const averageRating =
    totalReviews === 0
      ? 0
      : Number(
          (
            game.reviews.reduce((acc, review) => acc + review.rating, 0) / totalReviews
          ).toFixed(1)
        );

  return {
    ...game,
    finalPrice: computeFinalPrice(game),
    averageRating,
    totalReviews
  };
};

export const normalize = (value: string): string => value.trim().toLowerCase();
