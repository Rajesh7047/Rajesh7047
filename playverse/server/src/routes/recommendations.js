import { Router } from 'express';
import { Game } from '../models/Game.js';
import { User } from '../models/User.js';
import { Order } from '../models/Order.js';
import { protect } from '../middleware/auth.js';

const router = Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).populate('library');
    const libraryIds = user.library.map((g) => g._id?.toString() || g.toString());

    const genres = new Set();
    for (const game of user.library) {
      if (game.genre) genres.add(game.genre);
    }

    const orders = await Order.find({ user: req.user.id }).limit(10);
    const purchasedGameIds = orders.flatMap((o) => o.items.map((i) => i.game.toString()));

    const filter = {
      isActive: true,
      _id: { $nin: libraryIds },
    };

    if (genres.size) {
      filter.genre = { $in: [...genres] };
    }

    let recommendations = await Game.find(filter).sort({ popularity: -1 }).limit(8);

    if (recommendations.length < 4) {
      const fallback = await Game.find({
        isActive: true,
        _id: { $nin: [...libraryIds, ...recommendations.map((g) => g._id)] },
      })
        .sort({ 'rating.average': -1, popularity: -1 })
        .limit(8 - recommendations.length);
      recommendations = [...recommendations, ...fallback];
    }

    res.json({ recommendations, basedOn: { genres: [...genres], purchases: purchasedGameIds.length } });
  } catch (err) {
    next(err);
  }
});

router.get('/featured', async (req, res, next) => {
  try {
    const games = await Game.find({ isActive: true, featured: true })
      .sort({ popularity: -1 })
      .limit(6);
    res.json({ games });
  } catch (err) {
    next(err);
  }
});

export default router;
