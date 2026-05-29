const router = require('express').Router();
const { getCart, addToCart, removeFromCart, clearCart } = require('../controllers/cartController');
const { protect } = require('../middleware/auth');

router.use(protect);
router.get('/', getCart);
router.post('/add', addToCart);
router.delete('/item/:gameId', removeFromCart);
router.delete('/clear', clearCart);

module.exports = router;
