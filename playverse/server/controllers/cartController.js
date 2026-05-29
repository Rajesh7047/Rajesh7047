const Cart = require('../models/Cart');
const Game = require('../models/Game');

exports.getCart = async (req, res, next) => {
  try {
    let cart = await Cart.findOne({ user: req.user._id }).populate(
      'items.game',
      'title coverImage price discount slug averageRating'
    );
    if (!cart) cart = { items: [], totalPrice: 0 };
    res.json({ success: true, cart });
  } catch (err) {
    next(err);
  }
};

exports.addToCart = async (req, res, next) => {
  try {
    const { gameId } = req.body;
    const game = await Game.findById(gameId);
    if (!game || !game.isActive) {
      return res.status(404).json({ success: false, message: 'Game not found.' });
    }

    // Check if already in user's library
    const user = req.user;
    const owned = user.library?.some((l) => l.game?.toString() === gameId);
    if (owned) {
      return res.status(400).json({ success: false, message: 'You already own this game.' });
    }

    let cart = await Cart.findOne({ user: req.user._id });
    if (!cart) {
      cart = await Cart.create({ user: req.user._id, items: [] });
    }

    const exists = cart.items.find((i) => i.game.toString() === gameId);
    if (exists) {
      return res.status(400).json({ success: false, message: 'Game already in cart.' });
    }

    const finalPrice = game.discount
      ? game.price * (1 - game.discount / 100)
      : game.price;

    cart.items.push({ game: gameId, price: Math.round(finalPrice * 100) / 100 });
    await cart.save();

    cart = await Cart.findOne({ user: req.user._id }).populate(
      'items.game',
      'title coverImage price discount slug averageRating'
    );

    res.json({ success: true, message: 'Added to cart.', cart });
  } catch (err) {
    next(err);
  }
};

exports.removeFromCart = async (req, res, next) => {
  try {
    const { gameId } = req.params;
    const cart = await Cart.findOne({ user: req.user._id });
    if (!cart) return res.status(404).json({ success: false, message: 'Cart not found.' });

    cart.items = cart.items.filter((i) => i.game.toString() !== gameId);
    await cart.save();

    await cart.populate('items.game', 'title coverImage price discount slug');
    res.json({ success: true, message: 'Removed from cart.', cart });
  } catch (err) {
    next(err);
  }
};

exports.clearCart = async (req, res, next) => {
  try {
    await Cart.findOneAndUpdate({ user: req.user._id }, { items: [] });
    res.json({ success: true, message: 'Cart cleared.' });
  } catch (err) {
    next(err);
  }
};
