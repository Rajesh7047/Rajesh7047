import { Router } from 'express';
import { User } from '../models/User.js';
import { Game } from '../models/Game.js';
import { protect } from '../middleware/auth.js';

const router = Router();

router.get('/', protect, async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id).populate(
      'wishlist',
      'title slug coverImage genre price discountPercent finalPrice rating'
    );
    res.json({ wishlist: user.wishlist });
  } catch (err) {
    next(err);
  }
});

router.post('/:gameId', protect, async (req, res, next) => {
  try {
    const game = await Game.findById(req.params.gameId);
    if (!game) return res.status(404).json({ message: 'Game not found' });

    const user = await User.findById(req.user.id);
    const id = game._id.toString();
    if (user.wishlist.some((g) => g.toString() === id)) {
      user.wishlist = user.wishlist.filter((g) => g.toString() !== id);
    } else {
      user.wishlist.push(game._id);
    }
    await user.save();
    await user.populate('wishlist', 'title slug coverImage genre price discountPercent');
    res.json({ wishlist: user.wishlist });
  } catch (err) {
    next(err);
  }
});

export default router;
