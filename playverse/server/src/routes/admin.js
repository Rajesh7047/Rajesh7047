import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import { Game } from '../models/Game.js';
import { User } from '../models/User.js';
import { Order } from '../models/Order.js';
import { protect, adminOnly } from '../middleware/auth.js';
import { slugify } from '../utils/slugify.js';

const router = Router();
router.use(protect, adminOnly);

function validate(req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({ message: errors.array()[0].msg });
    return false;
  }
  return true;
}

router.get('/stats', async (req, res, next) => {
  try {
    const [userCount, gameCount, orders, revenueAgg] = await Promise.all([
      User.countDocuments({ role: 'user' }),
      Game.countDocuments({ isActive: true }),
      Order.find({ status: 'paid' }).sort({ createdAt: -1 }).limit(10),
      Order.aggregate([
        { $match: { status: 'paid' } },
        { $group: { _id: null, total: { $sum: '$total' }, count: { $sum: 1 } } },
      ]),
    ]);

    const topGames = await Order.aggregate([
      { $match: { status: 'paid' } },
      { $unwind: '$items' },
      { $group: { _id: '$items.game', sales: { $sum: 1 }, revenue: { $sum: '$items.price' } } },
      { $sort: { sales: -1 } },
      { $limit: 5 },
      {
        $lookup: {
          from: 'games',
          localField: '_id',
          foreignField: '_id',
          as: 'game',
        },
      },
      { $unwind: '$game' },
      {
        $project: {
          title: '$game.title',
          sales: 1,
          revenue: 1,
        },
      },
    ]);

    res.json({
      stats: {
        users: userCount,
        games: gameCount,
        orders: revenueAgg[0]?.count || 0,
        revenue: revenueAgg[0]?.total || 0,
      },
      recentOrders: orders,
      topGames,
    });
  } catch (err) {
    next(err);
  }
});

router.get('/games', async (req, res, next) => {
  try {
    const games = await Game.find().sort({ createdAt: -1 });
    res.json({ games });
  } catch (err) {
    next(err);
  }
});

router.post(
  '/games',
  [
    body('title').trim().notEmpty(),
    body('description').trim().notEmpty(),
    body('genre').trim().notEmpty(),
    body('price').isFloat({ min: 0 }),
    body('coverImage').trim().notEmpty(),
  ],
  async (req, res, next) => {
    try {
      if (!validate(req, res)) return;

      let slug = slugify(req.body.title);
      const existing = await Game.findOne({ slug });
      if (existing) slug = `${slug}-${Date.now()}`;

      const game = await Game.create({
        ...req.body,
        slug,
        rating: { average: 0, count: 0 },
      });
      res.status(201).json({ game });
    } catch (err) {
      next(err);
    }
  }
);

router.patch('/games/:id', async (req, res, next) => {
  try {
    const game = await Game.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!game) return res.status(404).json({ message: 'Game not found' });
    res.json({ game });
  } catch (err) {
    next(err);
  }
});

router.delete('/games/:id', async (req, res, next) => {
  try {
    const game = await Game.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true });
    if (!game) return res.status(404).json({ message: 'Game not found' });
    res.json({ message: 'Game deactivated', game });
  } catch (err) {
    next(err);
  }
});

export default router;
