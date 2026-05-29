const Order = require('../models/Order');
const Cart = require('../models/Cart');
const User = require('../models/User');
const Game = require('../models/Game');
const crypto = require('crypto');

exports.createOrder = async (req, res, next) => {
  try {
    const { paymentMethod = 'demo' } = req.body;

    const cart = await Cart.findOne({ user: req.user._id }).populate('items.game');
    if (!cart || cart.items.length === 0) {
      return res.status(400).json({ success: false, message: 'Cart is empty.' });
    }

    // Build order items
    const items = cart.items.map((item) => ({
      game: item.game._id,
      title: item.game.title,
      price: item.price,
      coverImage: item.game.coverImage,
    }));

    const totalAmount = items.reduce((sum, item) => sum + item.price, 0);

    const order = await Order.create({
      user: req.user._id,
      items,
      totalAmount: Math.round(totalAmount * 100) / 100,
      paymentMethod,
      status: 'completed',
      transactionId: crypto.randomUUID(),
    });

    // Add games to user's library and update purchase counts
    const gameIds = cart.items.map((item) => ({
      game: item.game._id,
      purchasedAt: new Date(),
    }));

    await User.findByIdAndUpdate(req.user._id, {
      $push: {
        library: { $each: gameIds },
        purchaseHistory: order._id,
      },
    });

    // Increment purchase counts
    await Promise.all(
      cart.items.map((item) =>
        Game.findByIdAndUpdate(item.game._id, { $inc: { purchaseCount: 1 } })
      )
    );

    // Clear cart
    await Cart.findOneAndUpdate({ user: req.user._id }, { items: [] });

    res.status(201).json({
      success: true,
      message: 'Purchase successful! Games added to your library.',
      order,
    });
  } catch (err) {
    next(err);
  }
};

exports.getMyOrders = async (req, res, next) => {
  try {
    const orders = await Order.find({ user: req.user._id }).sort('-createdAt');
    res.json({ success: true, orders });
  } catch (err) {
    next(err);
  }
};

exports.getOrderById = async (req, res, next) => {
  try {
    const order = await Order.findOne({ _id: req.params.id, user: req.user._id });
    if (!order) return res.status(404).json({ success: false, message: 'Order not found.' });
    res.json({ success: true, order });
  } catch (err) {
    next(err);
  }
};

// Admin
exports.getAllOrders = async (req, res, next) => {
  try {
    const orders = await Order.find()
      .populate('user', 'username email')
      .sort('-createdAt')
      .limit(100);
    res.json({ success: true, orders });
  } catch (err) {
    next(err);
  }
};

exports.getDashboardStats = async (req, res, next) => {
  try {
    const User = require('../models/User');
    const [totalUsers, totalGames, totalOrders, revenueAgg] = await Promise.all([
      User.countDocuments({ role: 'user' }),
      Game.countDocuments({ isActive: true }),
      Order.countDocuments({ status: 'completed' }),
      Order.aggregate([
        { $match: { status: 'completed' } },
        { $group: { _id: null, total: { $sum: '$totalAmount' } } },
      ]),
    ]);

    const totalRevenue = revenueAgg[0]?.total || 0;

    const recentOrders = await Order.find({ status: 'completed' })
      .populate('user', 'username email')
      .sort('-createdAt')
      .limit(5);

    const topGames = await Game.find({ isActive: true })
      .sort('-purchaseCount')
      .limit(5)
      .select('title purchaseCount averageRating coverImage');

    res.json({
      success: true,
      stats: { totalUsers, totalGames, totalOrders, totalRevenue },
      recentOrders,
      topGames,
    });
  } catch (err) {
    next(err);
  }
};
