const Game = require('../models/Game');

exports.getGames = async (req, res, next) => {
  try {
    const {
      page = 1,
      limit = 12,
      genre,
      search,
      sort = '-createdAt',
      minPrice,
      maxPrice,
      featured,
    } = req.query;

    const query = { isActive: true };

    if (genre) query.genre = { $in: genre.split(',') };
    if (featured === 'true') query.isFeatured = true;
    if (search) query.$text = { $search: search };
    if (minPrice || maxPrice) {
      query.price = {};
      if (minPrice) query.price.$gte = Number(minPrice);
      if (maxPrice) query.price.$lte = Number(maxPrice);
    }

    const skip = (Number(page) - 1) * Number(limit);
    const [games, total] = await Promise.all([
      Game.find(query)
        .sort(sort)
        .skip(skip)
        .limit(Number(limit))
        .select('-reviews -systemRequirements'),
      Game.countDocuments(query),
    ]);

    res.json({
      success: true,
      games,
      pagination: {
        total,
        page: Number(page),
        pages: Math.ceil(total / Number(limit)),
        limit: Number(limit),
      },
    });
  } catch (err) {
    next(err);
  }
};

exports.getGameBySlug = async (req, res, next) => {
  try {
    const game = await Game.findOne({ slug: req.params.slug, isActive: true }).populate(
      'reviews.user',
      'username avatar'
    );
    if (!game) return res.status(404).json({ success: false, message: 'Game not found.' });
    res.json({ success: true, game });
  } catch (err) {
    next(err);
  }
};

exports.getGameById = async (req, res, next) => {
  try {
    const game = await Game.findById(req.params.id);
    if (!game) return res.status(404).json({ success: false, message: 'Game not found.' });
    res.json({ success: true, game });
  } catch (err) {
    next(err);
  }
};

exports.getFeaturedGames = async (req, res, next) => {
  try {
    const games = await Game.find({ isFeatured: true, isActive: true })
      .limit(6)
      .select('-reviews -systemRequirements');
    res.json({ success: true, games });
  } catch (err) {
    next(err);
  }
};

exports.getTopRated = async (req, res, next) => {
  try {
    const games = await Game.find({ isActive: true, reviewCount: { $gte: 0 } })
      .sort({ averageRating: -1, purchaseCount: -1 })
      .limit(8)
      .select('-reviews -systemRequirements');
    res.json({ success: true, games });
  } catch (err) {
    next(err);
  }
};

exports.addReview = async (req, res, next) => {
  try {
    const { rating, comment } = req.body;
    const game = await Game.findById(req.params.id);
    if (!game) return res.status(404).json({ success: false, message: 'Game not found.' });

    const alreadyReviewed = game.reviews.find(
      (r) => r.user.toString() === req.user._id.toString()
    );
    if (alreadyReviewed) {
      return res.status(400).json({ success: false, message: 'You have already reviewed this game.' });
    }

    game.reviews.push({ user: req.user._id, username: req.user.username, rating, comment });
    await game.save();

    res.status(201).json({ success: true, message: 'Review added.', game });
  } catch (err) {
    next(err);
  }
};

exports.searchGames = async (req, res, next) => {
  try {
    const { q } = req.query;
    if (!q) return res.json({ success: true, games: [] });

    const games = await Game.find({
      isActive: true,
      $or: [
        { title: { $regex: q, $options: 'i' } },
        { developer: { $regex: q, $options: 'i' } },
        { tags: { $in: [new RegExp(q, 'i')] } },
      ],
    })
      .limit(10)
      .select('title coverImage price slug averageRating genre');

    res.json({ success: true, games });
  } catch (err) {
    next(err);
  }
};

// Admin Controllers
exports.createGame = async (req, res, next) => {
  try {
    const game = await Game.create(req.body);
    res.status(201).json({ success: true, message: 'Game created successfully.', game });
  } catch (err) {
    next(err);
  }
};

exports.updateGame = async (req, res, next) => {
  try {
    const game = await Game.findByIdAndUpdate(req.params.id, req.body, {
      new: true,
      runValidators: true,
    });
    if (!game) return res.status(404).json({ success: false, message: 'Game not found.' });
    res.json({ success: true, message: 'Game updated.', game });
  } catch (err) {
    next(err);
  }
};

exports.deleteGame = async (req, res, next) => {
  try {
    const game = await Game.findByIdAndUpdate(req.params.id, { isActive: false }, { new: true });
    if (!game) return res.status(404).json({ success: false, message: 'Game not found.' });
    res.json({ success: true, message: 'Game removed from listings.' });
  } catch (err) {
    next(err);
  }
};

exports.getAllGamesAdmin = async (req, res, next) => {
  try {
    const games = await Game.find().sort('-createdAt');
    res.json({ success: true, games });
  } catch (err) {
    next(err);
  }
};
