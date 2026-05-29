const router = require('express').Router();
const {
  createOrder,
  getMyOrders,
  getOrderById,
  getAllOrders,
  getDashboardStats,
} = require('../controllers/orderController');
const { protect, adminOnly } = require('../middleware/auth');

router.use(protect);
router.post('/', createOrder);
router.get('/my', getMyOrders);
router.get('/admin/all', adminOnly, getAllOrders);
router.get('/admin/stats', adminOnly, getDashboardStats);
router.get('/:id', getOrderById);

module.exports = router;
