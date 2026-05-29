import { useMemo, useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { api } from "../api";
import { useAuth } from "../auth";

export const LibraryPage = () => {
  const auth = useAuth();
  const queryClient = useQueryClient();
  const [selectedGameId, setSelectedGameId] = useState<string>("");
  const [compatibilityResult, setCompatibilityResult] = useState<string | null>(null);
  const [downloadLink, setDownloadLink] = useState<string | null>(null);
  const [review, setReview] = useState({ rating: 5, comment: "" });

  const libraryQuery = useQuery({
    queryKey: ["library", auth.user?.id],
    queryFn: () => api.getLibrary(auth.token!),
    enabled: auth.isAuthenticated
  });

  const ordersQuery = useQuery({
    queryKey: ["orders", auth.user?.id],
    queryFn: () => api.getOrders(auth.token!),
    enabled: auth.isAuthenticated
  });

  const compatibilityMutation = useMutation({
    mutationFn: (gameId: string) =>
      api.checkCompatibility(auth.token!, gameId, {
        os: "Windows 11",
        ramGb: 16,
        gpuTier: "high"
      }),
    onSuccess: (data) => {
      setCompatibilityResult(
        data.compatible
          ? "Your current PC profile meets this game's minimum requirements."
          : "This game may not run well on your current PC profile."
      );
    }
  });

  const downloadMutation = useMutation({
    mutationFn: (gameId: string) => api.getDownload(auth.token!, gameId),
    onSuccess: (data) => setDownloadLink(data.installer)
  });

  const reviewMutation = useMutation({
    mutationFn: () => api.addReview(auth.token!, selectedGameId, review),
    onSuccess: async () => {
      setReview({ rating: 5, comment: "" });
      await queryClient.invalidateQueries({ queryKey: ["library", auth.user?.id] });
    }
  });

  const games = useMemo(() => libraryQuery.data?.games ?? [], [libraryQuery.data?.games]);

  return (
    <div className="stack">
      <section className="panel">
        <div className="section-title">
          <h2>My Library</h2>
          <span className="hint">Install purchased games directly to PC.</span>
        </div>
        {libraryQuery.isLoading ? (
          <p>Loading library...</p>
        ) : games.length === 0 ? (
          <p>Your library is empty.</p>
        ) : (
          <div className="list">
            {games.map((game) => (
              <div key={game.id} className="list-item block">
                <div>
                  <strong>{game.title}</strong>
                  <p>{game.minSystemRequirements.os}</p>
                </div>
                <div className="inline-actions">
                  <button className="button ghost" onClick={() => compatibilityMutation.mutate(game.id)}>
                    Check compatibility
                  </button>
                  <button className="button" onClick={() => downloadMutation.mutate(game.id)}>
                    Get installer
                  </button>
                </div>
              </div>
            ))}
          </div>
        )}
        {compatibilityResult && <p className="hint">{compatibilityResult}</p>}
        {downloadLink && (
          <p className="success">
            Installer ready:{" "}
            <a href={downloadLink} target="_blank" rel="noreferrer">
              {downloadLink}
            </a>
          </p>
        )}
      </section>

      <section className="panel">
        <h2>Post-purchase review</h2>
        <div className="form-grid">
          <label>
            Select game
            <select
              value={selectedGameId}
              onChange={(event) => setSelectedGameId(event.target.value)}
            >
              <option value="">Choose a game</option>
              {games.map((game) => (
                <option key={game.id} value={game.id}>
                  {game.title}
                </option>
              ))}
            </select>
          </label>
          <label>
            Rating
            <select
              value={review.rating}
              onChange={(event) =>
                setReview((prev) => ({ ...prev, rating: Number(event.target.value) }))
              }
            >
              {[5, 4, 3, 2, 1].map((value) => (
                <option key={value} value={value}>
                  {value}
                </option>
              ))}
            </select>
          </label>
          <label>
            Comment
            <textarea
              rows={3}
              value={review.comment}
              onChange={(event) =>
                setReview((prev) => ({ ...prev, comment: event.target.value }))
              }
            />
          </label>
          <button
            className="button"
            onClick={() => reviewMutation.mutate()}
            disabled={!selectedGameId || review.comment.length < 4}
          >
            Submit review
          </button>
        </div>
      </section>

      <section className="panel">
        <h2>Order history</h2>
        {ordersQuery.data?.orders.length ? (
          <div className="list">
            {ordersQuery.data.orders.map((order) => (
              <div key={order.id} className="list-item">
                <div>
                  <strong>{order.id}</strong>
                  <p>{new Date(order.createdAt).toLocaleString()}</p>
                </div>
                <span>${order.amountPaid.toFixed(2)}</span>
              </div>
            ))}
          </div>
        ) : (
          <p>No orders yet.</p>
        )}
      </section>
    </div>
  );
};
