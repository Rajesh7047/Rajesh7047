import { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { cartAPI } from '../services/api';
import { useAuth } from './AuthContext';

const CartContext = createContext(null);

export const CartProvider = ({ children }) => {
  const { isAuthenticated } = useAuth();
  const [cart, setCart] = useState({ items: [] });
  const [cartLoading, setCartLoading] = useState(false);

  const fetchCart = useCallback(async () => {
    if (!isAuthenticated) { setCart({ items: [] }); return; }
    try {
      setCartLoading(true);
      const { data } = await cartAPI.get();
      setCart(data.cart);
    } catch {
      setCart({ items: [] });
    } finally {
      setCartLoading(false);
    }
  }, [isAuthenticated]);

  useEffect(() => { fetchCart(); }, [fetchCart]);

  const addToCart = async (gameId) => {
    const { data } = await cartAPI.add(gameId);
    setCart(data.cart);
    return data;
  };

  const removeFromCart = async (gameId) => {
    const { data } = await cartAPI.remove(gameId);
    setCart(data.cart);
  };

  const clearCart = async () => {
    await cartAPI.clear();
    setCart({ items: [] });
  };

  const itemCount = cart?.items?.length || 0;
  const totalPrice = cart?.items?.reduce((sum, item) => sum + (item.price || 0), 0) || 0;
  const inCart = (gameId) => cart?.items?.some((i) => (i.game?._id || i.game) === gameId);

  return (
    <CartContext.Provider value={{ cart, cartLoading, addToCart, removeFromCart, clearCart, fetchCart, itemCount, totalPrice, inCart }}>
      {children}
    </CartContext.Provider>
  );
};

export const useCart = () => {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart must be used within CartProvider');
  return ctx;
};
