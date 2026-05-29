import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import { Review } from '../models/Review.js';
import { Game } from '../models/Game.js';
import { User } from '../models/User.js';
import { protect } from '../middleware/auth.js';

const router = Router();

async function refreshGameRating(gameId) {
  const stats = await Review.aggregate([
    { $match: { game: gameId } },
    { $group: { _id: null, average: { $avg: '$rating' }, count: { $sum: 1 } } },
  ]);
  const rating = stats[0]
    ? { average: Math.round(stats[0].average * 10) / 10, count: stats[0].count }
    : { average: 0, count: 0 };
  await Game.findByIdAndUpdate(gameId, { rating });
}

router.post(
  '/',
  protect,
  [
    body('gameId').notEmpty(),
    body('rating').isInt({ min: 1, max: 5 }),
    body('body').optional().isLength({ max: 2000 }),
  ],
  async (req, res, next) => {
    try {
      const errors = validationResult(req);
      if (!errors.isEmpty()) return res.status(400).json({ message: errors.array()[0].msg });

      const user = await User.findById(req.user.id);
      const owns = user.library.some((id) => id.toString() === req.body.gameId);
      if (!owns) {
        return res.status(403).json({ message: 'You can only review games in your library' });
      }

      const review = await Review.findOneAndUpdate(
        { user: req.user.id, game: req.body.gameId },
        {
          rating: req.body.rating,
          title: req.body.title,
          body: req.body.body,
        },
        { upsert: true, new: true, runValidators: true }
      );

      await refreshGameRating(req.body.gameId);
      res.status(201).json({ review });
    } catch (err) {
      next(err);
    }
  }
);

export default router;
