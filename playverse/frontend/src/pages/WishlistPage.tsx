import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { api } from "../api";
import { useAuth } from "../auth";
import { GameCard } from "../components/GameCard";

export const WishlistPage = () => {
  const auth = useAuth();
  const queryClient = useQueryClient();

  const wishlistQuery = useQuery({
    queryKey: ["wishlist", auth.user?.id],
    queryFn: () => api.getWishlist(auth.token!),
    enabled: auth.isAuthenticated
  });

  const toggleMutation = useMutation({
    mutationFn: async (gameId: string) => {
      await api.removeWishlist(auth.token!, gameId);
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["wishlist", auth.user?.id] });
    }
  });

  const addCartMutation = useMutation({
    mutationFn: (gameId: string) => api.addCartItem(auth.token!, gameId),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["cart", auth.user?.id] })
  });

  const games = wishlistQuery.data?.games ?? [];

  return (
    <section className="panel">
      <h2>Wishlist</h2>
      {wishlistQuery.isLoading ? (
        <p>Loading wishlist...</p>
      ) : games.length === 0 ? (
        <p>Your wishlist is empty.</p>
      ) : (
        <div className="grid">
          {games.map((game) => (
            <GameCard
              key={game.id}
              game={game}
              onAddToCart={addCartMutation.mutate}
              onToggleWishlist={toggleMutation.mutate}
              isWishlisted
            />
          ))}
        </div>
      )}
    </section>
  );
};
