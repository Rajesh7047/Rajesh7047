import { useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { api } from "../api";
import { useAuth } from "../auth";
import { GameCard } from "../components/GameCard";
import type { Game } from "../types";

const sortOptions = [
  { value: "popular", label: "Popularity" },
  { value: "price-low", label: "Price: Low to High" },
  { value: "price-high", label: "Price: High to Low" },
  { value: "rating", label: "Top Rated" }
];

export const CatalogPage = () => {
  const auth = useAuth();
  const queryClient = useQueryClient();
  const [search, setSearch] = useState("");
  const [genre, setGenre] = useState("");
  const [sort, setSort] = useState("popular");
  const [notice, setNotice] = useState<string | null>(null);

  const gamesQuery = useQuery({
    queryKey: ["games", search, genre, sort],
    queryFn: () =>
      api.listGames({
        ...(search ? { q: search } : {}),
        ...(genre ? { genre } : {}),
        sort
      })
  });

  const recommendationsQuery = useQuery({
    queryKey: ["recommendations", auth.user?.id],
    queryFn: () => api.listRecommendations(auth.token!),
    enabled: auth.isAuthenticated
  });

  const wishlistQuery = useQuery({
    queryKey: ["wishlist", auth.user?.id],
    queryFn: () => api.getWishlist(auth.token!),
    enabled: auth.isAuthenticated
  });

  const addToCartMutation = useMutation({
    mutationFn: (gameId: string) => api.addCartItem(auth.token!, gameId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["cart"] });
      setNotice("Added to cart");
    },
    onError: (error) => setNotice(error instanceof Error ? error.message : "Failed to add")
  });

  const toggleWishlistMutation = useMutation({
    mutationFn: async (gameId: string) => {
      const currentlyWishlisted = wishlistQuery.data?.games.some((item) => item.id === gameId);
      if (currentlyWishlisted) {
        await api.removeWishlist(auth.token!, gameId);
      } else {
        await api.addWishlist(auth.token!, gameId);
      }
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ["wishlist"] });
    }
  });

  const genres = useMemo(() => {
    const values = (gamesQuery.data?.games ?? []).map((game) => game.genre);
    return Array.from(new Set(values));
  }, [gamesQuery.data?.games]);

  const wishlistIds = new Set((wishlistQuery.data?.games ?? []).map((game) => game.id));
  const games = gamesQuery.data?.games ?? [];
  const recommendations = recommendationsQuery.data?.games ?? [];

  return (
    <div className="stack">
      <section className="panel">
        <div className="section-title">
          <h2>Game Catalog</h2>
          {notice && <span className="badge">{notice}</span>}
        </div>
        <div className="filters">
          <input
            placeholder="Search title, publisher, or tags"
            value={search}
            onChange={(event) => setSearch(event.target.value)}
          />
          <select value={genre} onChange={(event) => setGenre(event.target.value)}>
            <option value="">All genres</option>
            {genres.map((value) => (
              <option key={value} value={value}>
                {value}
              </option>
            ))}
          </select>
          <select value={sort} onChange={(event) => setSort(event.target.value)}>
            {sortOptions.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
        </div>
        {gamesQuery.isLoading ? (
          <p>Loading catalog...</p>
        ) : (
          <div className="grid">
            {games.map((game) => (
              <GameCard
                key={game.id}
                game={game}
                onAddToCart={auth.isAuthenticated ? addToCartMutation.mutate : undefined}
                onToggleWishlist={
                  auth.isAuthenticated ? toggleWishlistMutation.mutateAsync : undefined
                }
                isWishlisted={wishlistIds.has(game.id)}
              />
            ))}
          </div>
        )}
      </section>

      {auth.isAuthenticated && (
        <section className="panel">
          <div className="section-title">
            <h2>Personalized recommendations</h2>
            <span className="hint">Based on your preferences and library history.</span>
          </div>
          {recommendations.length === 0 ? (
            <p>Purchase a few games to receive recommendations.</p>
          ) : (
            <div className="grid">
              {recommendations.map((game: Game) => (
                <GameCard
                  key={game.id}
                  game={game}
                  compact
                  onAddToCart={addToCartMutation.mutate}
                  onToggleWishlist={toggleWishlistMutation.mutateAsync}
                  isWishlisted={wishlistIds.has(game.id)}
                />
              ))}
            </div>
          )}
        </section>
      )}
    </div>
  );
};
