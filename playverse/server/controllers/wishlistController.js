const User = require('../models/User');

exports.getWishlist = async (req, res, next) => {
  try {
    const user = await User.findById(req.user._id).populate(
      'wishlist',
      'title coverImage price discount averageRating slug genre'
    );
    res.json({ success: true, wishlist: user.wishlist });
  } catch (err) {
    next(err);
  }
};

exports.toggleWishlist = async (req, res, next) => {
  try {
    const { gameId } = req.body;
    const user = await User.findById(req.user._id);

    const inWishlist = user.wishlist.some((id) => id.toString() === gameId);

    if (inWishlist) {
      user.wishlist = user.wishlist.filter((id) => id.toString() !== gameId);
      await user.save();
      return res.json({ success: true, message: 'Removed from wishlist.', inWishlist: false });
    }

    user.wishlist.push(gameId);
    await user.save();
    res.json({ success: true, message: 'Added to wishlist.', inWishlist: true });
  } catch (err) {
    next(err);
  }
};
