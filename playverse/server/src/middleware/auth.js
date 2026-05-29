import jwt from 'jsonwebtoken';
import { User } from '../models/User.js';

export function protect(req, res, next) {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    return res.status(401).json({ message: 'Authentication required' });
  }

  try {
    const token = header.split(' ')[1];
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = { id: decoded.id, role: decoded.role };
    next();
  } catch {
    return res.status(401).json({ message: 'Invalid or expired token' });
  }
}

export function adminOnly(req, res, next) {
  if (req.user?.role !== 'admin') {
    return res.status(403).json({ message: 'Admin access required' });
  }
  next();
}

export async function attachUser(req, res, next) {
  if (!req.user?.id) return next();
  try {
    const user = await User.findById(req.user.id).select('-password');
    if (user) req.currentUser = user;
  } catch {
    /* optional */
  }
  next();
}
