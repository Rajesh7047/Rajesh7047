import { Router } from 'express';
import { body, validationResult } from 'express-validator';
import { User } from '../models/User.js';
import { Cart } from '../models/Cart.js';
import { signToken } from '../utils/token.js';
import { protect } from '../middleware/auth.js';

const router = Router();

function validate(req, res) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    res.status(400).json({ message: errors.array()[0].msg, errors: errors.array() });
    return false;
  }
  return true;
}

function userPayload(user) {
  return {
    id: user._id,
    username: user.username,
    email: user.email,
    role: user.role,
    avatar: user.avatar,
    wishlist: user.wishlist,
    library: user.library,
    preferences: user.preferences,
  };
}

router.post(
  '/register',
  [
    body('username').trim().isLength({ min: 2 }).withMessage('Username must be at least 2 characters'),
    body('email').isEmail().withMessage('Valid email required'),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  async (req, res, next) => {
    try {
      if (!validate(req, res)) return;

      const { username, email, password } = req.body;
      const exists = await User.findOne({ email });
      if (exists) return res.status(409).json({ message: 'Email already registered' });

      const user = await User.create({ username, email, password });
      await Cart.create({ user: user._id, items: [] });

      const token = signToken(user);
      res.status(201).json({ token, user: userPayload(user) });
    } catch (err) {
      next(err);
    }
  }
);

router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Valid email required'),
    body('password').notEmpty().withMessage('Password required'),
  ],
  async (req, res, next) => {
    try {
      if (!validate(req, res)) return;

      const user = await User.findOne({ email: req.body.email }).select('+password');
      if (!user || !(await user.comparePassword(req.body.password))) {
        return res.status(401).json({ message: 'Invalid email or password' });
      }

      const token = signToken(user);
      res.json({ token, user: userPayload(user) });
    } catch (err) {
      next(err);
    }
  }
);

router.get('/me', protect, async (req, res, next) => {
  try {
    const user = await User.findById(req.user.id)
      .populate('library', 'title slug coverImage genre finalPrice price')
      .populate('wishlist', 'title slug coverImage genre finalPrice price');
    if (!user) return res.status(404).json({ message: 'User not found' });
    res.json({ user: userPayload(user) });
  } catch (err) {
    next(err);
  }
});

router.patch('/me', protect, async (req, res, next) => {
  try {
    const allowed = ['username', 'avatar', 'preferences'];
    const updates = {};
    for (const key of allowed) {
      if (req.body[key] !== undefined) updates[key] = req.body[key];
    }
    const user = await User.findByIdAndUpdate(req.user.id, updates, {
      new: true,
      runValidators: true,
    });
    res.json({ user: userPayload(user) });
  } catch (err) {
    next(err);
  }
});

export default router;
