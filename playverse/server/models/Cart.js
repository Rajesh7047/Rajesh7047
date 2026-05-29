const mongoose = require('mongoose');

const cartItemSchema = new mongoose.Schema({
  game: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Game',
    required: true,
  },
  price: Number,
  addedAt: { type: Date, default: Date.now },
});

const cartSchema = new mongoose.Schema(
  {
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
      unique: true,
    },
    items: [cartItemSchema],
  },
  { timestamps: true }
);

cartSchema.virtual('totalPrice').get(function () {
  return this.items.reduce((sum, item) => sum + (item.price || 0), 0);
});

module.exports = mongoose.model('Cart', cartSchema);
