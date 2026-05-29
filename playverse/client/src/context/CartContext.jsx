import { createContext, useCallback, useContext, useEffect, useMemo, useState } from 'react';
import api from '../api/client.js';
import { useAuth } from './AuthContext.jsx';

const CartContext = createContext(null);

export function CartProvider({ children }) {
  const { isAuthenticated } = useAuth();
  const [cart, setCart] = useState({ items: [], subtotal: 0, itemCount: 0 });

  const refreshCart = useCallback(async () => {
    if (!isAuthenticated) {
      setCart({ items: [], subtotal: 0, itemCount: 0 });
      return;
    }
    try {
      const { data } = await api.get('/cart');
      setCart(data);
    } catch {
      setCart({ items: [], subtotal: 0, itemCount: 0 });
    }
  }, [isAuthenticated]);

  useEffect(() => {
    refreshCart();
  }, [refreshCart]);

  const addToCart = async (gameId) => {
    const { data } = await api.post('/cart/items', { gameId });
    setCart(data);
    return data;
  };

  const removeFromCart = async (gameId) => {
    const { data } = await api.delete(`/cart/items/${gameId}`);
    setCart(data);
    return data;
  };

  const clearCart = async () => {
    const { data } = await api.delete('/cart');
    setCart(data);
  };

  const value = useMemo(
    () => ({ cart, refreshCart, addToCart, removeFromCart, clearCart }),
    [cart, refreshCart]
  );

  return <CartContext.Provider value={value}>{children}</CartContext.Provider>;
}

export function useCart() {
  const ctx = useContext(CartContext);
  if (!ctx) throw new Error('useCart must be used within CartProvider');
  return ctx;
}
