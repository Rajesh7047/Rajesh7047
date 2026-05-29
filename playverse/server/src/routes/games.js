import { Router } from 'express';
import { Game } from '../models/Game.js';
import { Review } from '../models/Review.js';

const router = Router();

router.get('/', async (req, res, next) => {
  try {
    const {
      genre,
      search,
      sort = 'popularity',
      featured,
      minPrice,
      maxPrice,
      page = 1,
      limit = 12,
    } = req.query;

    const filter = { isActive: true };
    if (genre && genre !== 'all') filter.genre = new RegExp(`^${genre}$`, 'i');
    if (featured === 'true') filter.featured = true;
    if (minPrice) filter.price = { ...filter.price, $gte: Number(minPrice) };
    if (maxPrice) filter.price = { ...filter.price, $lte: Number(maxPrice) };
    if (search) {
      filter.$or = [
        { title: new RegExp(search, 'i') },
        { publisher: new RegExp(search, 'i') },
        { tags: new RegExp(search, 'i') },
      ];
    }

    const sortMap = {
      popularity: { popularity: -1 },
      price_asc: { price: 1 },
      price_desc: { price: -1 },
      rating: { 'rating.average': -1 },
      newest: { createdAt: -1 },
    };

    const skip = (Math.max(1, Number(page)) - 1) * Number(limit);
    const [games, total] = await Promise.all([
      Game.find(filter)
        .sort(sortMap[sort] || sortMap.popularity)
        .skip(skip)
        .limit(Number(limit)),
      Game.countDocuments(filter),
    ]);

    res.json({
      games,
      pagination: {
        page: Number(page),
        limit: Number(limit),
        total,
        pages: Math.ceil(total / Number(limit)),
      },
    });
  } catch (err) {
    next(err);
  }
});

router.get('/genres', async (req, res, next) => {
  try {
    const genres = await Game.distinct('genre', { isActive: true });
    res.json({ genres: genres.sort() });
  } catch (err) {
    next(err);
  }
});

router.get('/:slug', async (req, res, next) => {
  try {
    const game = await Game.findOne({ slug: req.params.slug, isActive: true });
    if (!game) return res.status(404).json({ message: 'Game not found' });

    const reviews = await Review.find({ game: game._id })
      .populate('user', 'username avatar')
      .sort({ createdAt: -1 })
      .limit(20);

    res.json({ game, reviews });
  } catch (err) {
    next(err);
  }
});

export default router;
