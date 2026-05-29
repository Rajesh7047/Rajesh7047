import { Router } from 'express';
import { Cart } from '../models/Cart.js';
import { Game } from '../models/Game.js';
import { protect } from '../middleware/auth.js';

const router = Router();

async function getOrCreateCart(userId) {
  let cart = await Cart.findOne({ user: userId }).populate('items.game');
  if (!cart) {
    cart = await Cart.create({ user: userId, items: [] });
    cart = await cart.populate('items.game');
  }
  return cart;
}

function cartSummary(cart) {
  const items = cart.items.map((item) => {
    const game = item.game;
    const price = game.discountPercent
      ? Math.round(game.price * (1 - game.discountPercent / 100) * 100) / 100
      : game.price;
    return {
      gameId: game._id,
      title: game.title,
      slug: game.slug,
      coverImage: game.coverImage,
      price,
      quantity: item.quantity,
      lineTotal: price * item.quantity,
    };
  });
  const subtotal = items.reduce((sum, i) => sum + i.lineTotal, 0);
  return { items, subtotal: Math.round(subtotal * 100) / 100, itemCount: items.length };
}

router.get('/', protect, async (req, res, next) => {
  try {
    const cart = await getOrCreateCart(req.user.id);
    res.json(cartSummary(cart));
  } catch (err) {
    next(err);
  }
});

router.post('/items', protect, async (req, res, next) => {
  try {
    const { gameId } = req.body;
    const game = await Game.findById(gameId);
    if (!game || !game.isActive) return res.status(404).json({ message: 'Game not found' });

    const cart = await getOrCreateCart(req.user.id);
    const existing = cart.items.find((i) => i.game._id.toString() === gameId);
    if (existing) {
      existing.quantity += 1;
    } else {
      cart.items.push({ game: gameId, quantity: 1 });
    }
    await cart.save();
    const updated = await getOrCreateCart(req.user.id);
    res.json(cartSummary(updated));
  } catch (err) {
    next(err);
  }
});

router.delete('/items/:gameId', protect, async (req, res, next) => {
  try {
    const cart = await getOrCreateCart(req.user.id);
    cart.items = cart.items.filter((i) => i.game._id.toString() !== req.params.gameId);
    await cart.save();
    const updated = await getOrCreateCart(req.user.id);
    res.json(cartSummary(updated));
  } catch (err) {
    next(err);
  }
});

router.delete('/', protect, async (req, res, next) => {
  try {
    const cart = await getOrCreateCart(req.user.id);
    cart.items = [];
    await cart.save();
    res.json({ items: [], subtotal: 0, itemCount: 0 });
  } catch (err) {
    next(err);
  }
});

export default router;
