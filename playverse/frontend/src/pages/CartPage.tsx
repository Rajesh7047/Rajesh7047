import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { api } from "../api";
import { useAuth } from "../auth";

export const CartPage = () => {
  const auth = useAuth();
  const queryClient = useQueryClient();
  const [checkoutMessage, setCheckoutMessage] = useState<string | null>(null);

  const cartQuery = useQuery({
    queryKey: ["cart", auth.user?.id],
    queryFn: () => api.getCart(auth.token!),
    enabled: auth.isAuthenticated
  });

  const removeItemMutation = useMutation({
    mutationFn: (gameId: string) => api.removeCartItem(auth.token!, gameId),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["cart", auth.user?.id] })
  });

  const checkoutMutation = useMutation({
    mutationFn: () => api.checkout(auth.token!, "card"),
    onSuccess: async (data) => {
      setCheckoutMessage(data.message);
      await queryClient.invalidateQueries({ queryKey: ["cart", auth.user?.id] });
      await queryClient.invalidateQueries({ queryKey: ["library", auth.user?.id] });
      await queryClient.invalidateQueries({ queryKey: ["orders", auth.user?.id] });
      await queryClient.invalidateQueries({ queryKey: ["recommendations", auth.user?.id] });
    }
  });

  const cart = cartQuery.data;

  return (
    <section className="panel">
      <div className="section-title">
        <h2>Shopping Cart</h2>
        <span className="hint">Secure checkout simulated with Stripe/PayPal-ready API.</span>
      </div>

      {checkoutMessage && <p className="success">{checkoutMessage}</p>}

      {cartQuery.isLoading ? (
        <p>Loading cart...</p>
      ) : !cart || cart.items.length === 0 ? (
        <p>Your cart is empty. Add games from the catalog.</p>
      ) : (
        <>
          <div className="list">
            {cart.items.map((item) => (
              <div key={item.game.id} className="list-item">
                <div>
                  <strong>{item.game.title}</strong>
                  <p>{item.game.genre}</p>
                </div>
                <div className="inline-actions">
                  <span>${item.lineTotal.toFixed(2)}</span>
                  <button
                    className="button ghost"
                    onClick={() => removeItemMutation.mutate(item.game.id)}
                  >
                    Remove
                  </button>
                </div>
              </div>
            ))}
          </div>

          <div className="checkout-row">
            <strong>Total: ${cart.total.toFixed(2)}</strong>
            <button className="button" onClick={() => checkoutMutation.mutate()}>
              Complete purchase
            </button>
          </div>
        </>
      )}
    </section>
  );
};
