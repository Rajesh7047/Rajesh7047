const router = require('express').Router();
const {
  getGames,
  getGameBySlug,
  getFeaturedGames,
  getTopRated,
  addReview,
  searchGames,
  createGame,
  updateGame,
  deleteGame,
  getAllGamesAdmin,
  getGameById,
} = require('../controllers/gameController');
const { protect, adminOnly } = require('../middleware/auth');

router.get('/', getGames);
router.get('/featured', getFeaturedGames);
router.get('/top-rated', getTopRated);
router.get('/search', searchGames);
router.get('/admin/all', protect, adminOnly, getAllGamesAdmin);
router.get('/id/:id', protect, adminOnly, getGameById);
router.get('/:slug', getGameBySlug);
router.post('/:id/reviews', protect, addReview);
router.post('/', protect, adminOnly, createGame);
router.put('/:id', protect, adminOnly, updateGame);
router.delete('/:id', protect, adminOnly, deleteGame);

module.exports = router;
