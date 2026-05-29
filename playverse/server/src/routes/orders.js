import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import { Cart } from '../models/Cart.js';
import { Game } from '../models/Game.js';
import { Order } from '../models/Order.js';
import { User } from '../models/User.js';
import { protect } from '../middleware/auth.js';

const router = Router();

function validate(req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({ message: errors.array()[0].msg });
    return false;
  }
  return true;
}

router.get('/', protect, async (req, res, next) => {
  try {
    const orders = await Order.find({ user: req.user.id })
      .sort({ createdAt: -1 })
      .populate('items.game', 'title slug coverImage');
    res.json({ orders });
  } catch (err) {
    next(err);
  }
});

router.post(
  '/checkout',
  protect,
  [body('paymentMethod').optional().isIn(['stripe', 'paypal'])],
  async (req, res, next) => {
    try {
      if (!validate(req, res)) return;

      const cart = await Cart.findOne({ user: req.user.id }).populate('items.game');
      if (!cart?.items.length) {
        return res.status(400).json({ message: 'Cart is empty' });
      }

      const user = await User.findById(req.user.id);
      const orderItems = [];
      let total = 0;

      for (const item of cart.items) {
        const game = item.game;
        if (!game?.isActive) continue;

        const owned = user.library.some((id) => id.toString() === game._id.toString());
        if (owned) continue;

        const price =
          game.discountPercent > 0
            ? Math.round(game.price * (1 - game.discountPercent / 100) * 100) / 100
            : game.price;

        orderItems.push({ game: game._id, title: game.title, price });
        total += price * item.quantity;

        if (!user.library.includes(game._id)) {
          user.library.push(game._id);
        }
        game.popularity += 1;
        await game.save();
      }

      if (!orderItems.length) {
        return res.status(400).json({ message: 'No purchasable items in cart' });
      }

      const paymentReference = `PV-${Date.now()}-${Math.random().toString(36).slice(2, 8).toUpperCase()}`;
      const order = await Order.create({
        user: req.user.id,
        items: orderItems,
        total: Math.round(total * 100) / 100,
        status: 'paid',
        paymentMethod: req.body.paymentMethod || 'stripe',
        paymentReference,
      });

      user.purchaseHistory.push(order._id);
      await user.save();

      cart.items = [];
      await cart.save();

      const populated = await Order.findById(order._id).populate(
        'items.game',
        'title slug coverImage downloadUrl fileSizeMb'
      );

      res.status(201).json({
        message: 'Payment successful',
        order: populated,
        library: user.library,
      });
    } catch (err) {
      next(err);
    }
  }
);

router.get('/:id', protect, async (req, res, next) => {
  try {
    const order = await Order.findOne({ _id: req.params.id, user: req.user.id }).populate(
      'items.game',
      'title slug coverImage downloadUrl fileSizeMb systemRequirements'
    );
    if (!order) return res.status(404).json({ message: 'Order not found' });
    res.json({ order });
  } catch (err) {
    next(err);
  }
});

export default router;
