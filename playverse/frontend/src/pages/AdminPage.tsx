import { useState } from "react";
import { useMutation, useQuery, useQueryClient } from "@tanstack/react-query";
import { api } from "../api";
import { useAuth } from "../auth";

const emptyGame = {
  title: "",
  publisher: "",
  genre: "action",
  description: "",
  price: 49.99,
  discountPercent: 0,
  tags: "single-player,action",
  heroImage:
    "https://images.unsplash.com/photo-1560253023-3ec5d502959f?auto=format&fit=crop&w=1200&q=80",
  downloadUrl: "https://downloads.playverse.dev/new-game/setup.exe"
};

export const AdminPage = () => {
  const auth = useAuth();
  const queryClient = useQueryClient();
  const [form, setForm] = useState(emptyGame);
  const [message, setMessage] = useState<string | null>(null);

  const gamesQuery = useQuery({
    queryKey: ["admin-games"],
    queryFn: () => api.listAdminGames(auth.token!),
    enabled: auth.user?.role === "admin"
  });

  const createGameMutation = useMutation({
    mutationFn: () =>
      api.createAdminGame(auth.token!, {
        ...form,
        tags: form.tags
          .split(",")
          .map((tag) => tag.trim())
          .filter(Boolean),
        minSystemRequirements: {
          os: "Windows 10",
          cpu: "Intel i5",
          ram: "8 GB",
          gpu: "NVIDIA GTX 1060",
          storage: "30 GB"
        }
      }),
    onSuccess: async () => {
      setMessage("Game created");
      setForm(emptyGame);
      await queryClient.invalidateQueries({ queryKey: ["admin-games"] });
      await queryClient.invalidateQueries({ queryKey: ["games"] });
    }
  });

  const toggleGameMutation = useMutation({
    mutationFn: ({ gameId, active }: { gameId: string; active: boolean }) =>
      api.updateAdminGame(auth.token!, gameId, { active }),
    onSuccess: () => queryClient.invalidateQueries({ queryKey: ["admin-games"] })
  });

  return (
    <div className="stack">
      <section className="panel">
        <h2>Admin - Add game listing</h2>
        <div className="form-grid two-col">
          <label>
            Title
            <input
              value={form.title}
              onChange={(event) => setForm((prev) => ({ ...prev, title: event.target.value }))}
            />
          </label>
          <label>
            Publisher
            <input
              value={form.publisher}
              onChange={(event) =>
                setForm((prev) => ({ ...prev, publisher: event.target.value }))
              }
            />
          </label>
          <label>
            Genre
            <input
              value={form.genre}
              onChange={(event) => setForm((prev) => ({ ...prev, genre: event.target.value }))}
            />
          </label>
          <label>
            Price
            <input
              type="number"
              value={form.price}
              onChange={(event) => setForm((prev) => ({ ...prev, price: Number(event.target.value) }))}
            />
          </label>
          <label>
            Discount %
            <input
              type="number"
              value={form.discountPercent}
              onChange={(event) =>
                setForm((prev) => ({ ...prev, discountPercent: Number(event.target.value) }))
              }
            />
          </label>
          <label>
            Tags (comma-separated)
            <input
              value={form.tags}
              onChange={(event) => setForm((prev) => ({ ...prev, tags: event.target.value }))}
            />
          </label>
          <label className="full-width">
            Description
            <textarea
              rows={4}
              value={form.description}
              onChange={(event) =>
                setForm((prev) => ({ ...prev, description: event.target.value }))
              }
            />
          </label>
          <label className="full-width">
            Hero image URL
            <input
              value={form.heroImage}
              onChange={(event) => setForm((prev) => ({ ...prev, heroImage: event.target.value }))}
            />
          </label>
        </div>
        <button className="button" onClick={() => createGameMutation.mutate()}>
          Save game
        </button>
        {message && <p className="success">{message}</p>}
      </section>

      <section className="panel">
        <h2>Admin - Manage listings</h2>
        <div className="list">
          {(gamesQuery.data?.games ?? []).map((game) => (
            <div key={game.id} className="list-item">
              <div>
                <strong>{game.title}</strong>
                <p>
                  {game.publisher} · ${game.finalPrice.toFixed(2)}
                </p>
              </div>
              <button
                className="button ghost"
                onClick={() => toggleGameMutation.mutate({ gameId: game.id, active: !game.active })}
              >
                {game.active ? "Deactivate" : "Activate"}
              </button>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
};
