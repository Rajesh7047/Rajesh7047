import mongoose from 'mongoose';

const reviewSummarySchema = new mongoose.Schema(
  {
    average: { type: Number, default: 0 },
    count: { type: Number, default: 0 },
  },
  { _id: false }
);

const gameSchema = new mongoose.Schema(
  {
    title: { type: String, required: true, trim: true },
    slug: { type: String, required: true, unique: true, lowercase: true },
    description: { type: String, required: true },
    shortDescription: { type: String, maxlength: 280 },
    genre: { type: String, required: true, index: true },
    publisher: { type: String, default: 'PlayVerse Studios' },
    price: { type: Number, required: true, min: 0 },
    discountPercent: { type: Number, default: 0, min: 0, max: 100 },
    coverImage: { type: String, required: true },
    bannerImage: { type: String, default: '' },
    screenshots: [{ type: String }],
    tags: [{ type: String }],
    rating: reviewSummarySchema,
    popularity: { type: Number, default: 0 },
    systemRequirements: {
      os: { type: String, default: 'Windows 10 64-bit' },
      processor: { type: String, default: 'Intel Core i5' },
      memory: { type: String, default: '8 GB RAM' },
      graphics: { type: String, default: 'GTX 1060' },
      storage: { type: String, default: '50 GB' },
    },
    downloadUrl: { type: String, default: '' },
    fileSizeMb: { type: Number, default: 1024 },
    featured: { type: Boolean, default: false },
    isActive: { type: Boolean, default: true },
  },
  { timestamps: true }
);

gameSchema.virtual('finalPrice').get(function finalPrice() {
  if (!this.discountPercent) return this.price;
  return Math.round(this.price * (1 - this.discountPercent / 100) * 100) / 100;
});

gameSchema.set('toJSON', { virtuals: true });
gameSchema.set('toObject', { virtuals: true });

export const Game = mongoose.model('Game', gameSchema);
