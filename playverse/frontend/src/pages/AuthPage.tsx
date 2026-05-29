import { useState } from "react";
import { useNavigate } from "react-router-dom";
import { api } from "../api";
import { useAuth } from "../auth";

const defaultGenres = ["action", "rpg", "adventure", "strategy", "simulation", "racing"];

export const AuthPage = () => {
  const navigate = useNavigate();
  const auth = useAuth();
  const [isRegister, setIsRegister] = useState(false);
  const [form, setForm] = useState({
    name: "",
    email: "",
    password: "",
    favoriteGenres: ["rpg", "adventure"]
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  const submit = async (event: React.FormEvent) => {
    event.preventDefault();
    setError(null);
    setLoading(true);
    try {
      const response = isRegister
        ? await api.register(form)
        : await api.login({ email: form.email, password: form.password });
      auth.setSession(response.token, response.user);
      navigate("/");
    } catch (err) {
      setError(err instanceof Error ? err.message : "Authentication failed");
    } finally {
      setLoading(false);
    }
  };

  return (
    <section className="panel narrow">
      <div className="section-title">
        <h2>{isRegister ? "Create account" : "Welcome back"}</h2>
        <button className="button ghost" onClick={() => setIsRegister((prev) => !prev)}>
          {isRegister ? "Sign in instead" : "Register"}
        </button>
      </div>

      <form onSubmit={submit} className="form-grid">
        {isRegister && (
          <label>
            Name
            <input
              required
              value={form.name}
              onChange={(event) => setForm((prev) => ({ ...prev, name: event.target.value }))}
            />
          </label>
        )}
        <label>
          Email
          <input
            required
            type="email"
            value={form.email}
            onChange={(event) => setForm((prev) => ({ ...prev, email: event.target.value }))}
          />
        </label>
        <label>
          Password
          <input
            required
            type="password"
            minLength={8}
            value={form.password}
            onChange={(event) => setForm((prev) => ({ ...prev, password: event.target.value }))}
          />
        </label>
        {isRegister && (
          <label>
            Favorite genres
            <select
              multiple
              value={form.favoriteGenres}
              onChange={(event) => {
                const selected = Array.from(event.target.selectedOptions).map(
                  (option) => option.value
                );
                setForm((prev) => ({ ...prev, favoriteGenres: selected }));
              }}
            >
              {defaultGenres.map((genre) => (
                <option key={genre} value={genre}>
                  {genre}
                </option>
              ))}
            </select>
          </label>
        )}
        {error && <p className="error">{error}</p>}
        <button className="button" type="submit" disabled={loading}>
          {loading ? "Please wait..." : isRegister ? "Create account" : "Sign in"}
        </button>
        {!isRegister && (
          <p className="hint">
            Demo credentials: <code>demo@playverse.dev</code> / <code>Demo@1234</code>
          </p>
        )}
      </form>
    </section>
  );
};
