import mongoose from 'mongoose';

const reviewSchema = new mongoose.Schema(
  {
    user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
    game: { type: mongoose.Schema.Types.ObjectId, ref: 'Game', required: true },
    rating: { type: Number, required: true, min: 1, max: 5 },
    title: { type: String, trim: true, maxlength: 120 },
    body: { type: String, trim: true, maxlength: 2000 },
  },
  { timestamps: true }
);

reviewSchema.index({ user: 1, game: 1 }, { unique: true });

export const Review = mongoose.model('Review', reviewSchema);
