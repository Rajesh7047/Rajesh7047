import { BarChart3, CheckCircle2, Download, Gamepad2, Library, Lock, Search, ShieldCheck, Sparkles, UserRound } from "lucide-react";
import { useEffect, useMemo, useState } from "react";
import { GameCard } from "./components/GameCard";
import { StatCard } from "./components/StatCard";
import { addToCart, checkout, getAnalytics, getCart, getCatalog, getLibrary, getRecommendations, loginDemo } from "./services/api";
import type { CartView, Game, Purchase, User } from "./types";

type View = "store" | "library" | "cart" | "admin";

const navigation: Array<{ id: View; label: string }> = [
  { id: "store", label: "Store" },
  { id: "library", label: "Library" },
  { id: "cart", label: "Cart" },
  { id: "admin", label: "Admin" }
];

function formatCurrency(value: number) {
  return new Intl.NumberFormat("en-US", { style: "currency", currency: "USD" }).format(value);
}

export default function App() {
  const [view, setView] = useState<View>("store");
  const [games, setGames] = useState<Game[]>([]);
  const [genres, setGenres] = useState<string[]>([]);
  const [search, setSearch] = useState("");
  const [genre, setGenre] = useState("All");
  const [sort, setSort] = useState("popular");
  const [selectedGame, setSelectedGame] = useState<Game | null>(null);
  const [user, setUser] = useState<User | null>(null);
  const [cart, setCart] = useState<CartView>({ items: [], subtotal: 0, discount: 0, total: 0 });
  const [libraryGames, setLibraryGames] = useState<Game[]>([]);
  const [purchases, setPurchases] = useState<Purchase[]>([]);
  const [recommendations, setRecommendations] = useState<Game[]>([]);
  const [notice, setNotice] = useState("Live demo mode: use seeded PlayVerse accounts or run the API for full persistence.");
  const [analytics, setAnalytics] = useState({ totalRevenue: 0, totalOrders: 0, totalUsers: 0, activeGames: 0 });

  useEffect(() => {
    getCatalog(search, genre, sort).then(({ games: catalog, genres: nextGenres }) => {
      setGames(catalog);
      setGenres(nextGenres);
      setSelectedGame((current) => current ?? catalog[0] ?? null);
    });
  }, [search, genre, sort]);

  useEffect(() => {
    if (!user) return;
    getCart().then(setCart);
    getLibrary().then(({ games: ownedGames, purchases: orderHistory }) => {
      setLibraryGames(ownedGames);
      setPurchases(orderHistory);
    });
    getRecommendations().then(setRecommendations);
    if (user.role === "admin") getAnalytics().then(setAnalytics);
  }, [user]);

  const featured = useMemo(() => games.find((game) => game.featured) ?? games[0], [games]);
  const ownedIds = new Set(user?.ownedGameIds ?? libraryGames.map((game) => game.id));

  async function handleLogin(kind: "customer" | "admin" = "customer") {
    const session = await loginDemo(kind);
    localStorage.setItem("playverse.token", session.token);
    setUser(session.user);
    setNotice(`Signed in as ${session.user.name}. Demo credentials are documented in the README.`);
  }

  async function handleAddToCart(gameId: string) {
    if (!user) await handleLogin("customer");
    const nextCart = await addToCart(gameId);
    setCart(nextCart);
    setView("cart");
    setNotice("Game added to cart. Checkout includes system compatibility and license generation.");
  }

  async function handleCheckout() {
    const response = await checkout();
    setPurchases((current) => [response.purchase, ...current]);
    const library = await getLibrary();
    setLibraryGames(library.games);
    setCart({ items: [], subtotal: 0, discount: 0, total: 0 });
    setNotice(`Order ${response.purchase.id} is paid. License keys and secure download links are available in your library.`);
    setView("library");
  }

  return (
    <main>
      <header className="site-header">
        <a className="brand" href="#top" aria-label="PlayVerse home">
          <span>
            <Gamepad2 size={24} />
          </span>
          PlayVerse
        </a>
        <nav>
          {navigation.map((item) => (
            <button key={item.id} className={view === item.id ? "active" : ""} onClick={() => setView(item.id)}>
              {item.label}
            </button>
          ))}
        </nav>
        <div className="account">
          {user ? (
            <button className="profile-pill" onClick={() => setView(user.role === "admin" ? "admin" : "library")}>
              <span>{user.avatar}</span>
              {user.name}
            </button>
          ) : (
            <>
              <button className="secondary" onClick={() => handleLogin("customer")}>
                Demo login
              </button>
              <button onClick={() => handleLogin("admin")}>Admin</button>
            </>
          )}
        </div>
      </header>

      <section className="notice">
        <Sparkles size={18} /> {notice}
      </section>

      {view === "store" && (
        <>
          <section className="hero" id="top">
            <div className="hero__copy">
              <span className="eyebrow">Premium PC marketplace</span>
              <h1>Discover, buy, install, and review games from one polished hub.</h1>
              <p>
                Built from the PlayVerse report with secure accounts, catalog search, personalized recommendations, cart checkout,
                license delivery, compatibility checks, and admin control.
              </p>
              <div className="hero__actions">
                <button onClick={() => document.getElementById("catalog")?.scrollIntoView({ behavior: "smooth" })}>Browse catalog</button>
                <button className="secondary" onClick={() => handleLogin("customer")}>
                  Try seeded account
                </button>
              </div>
              <div className="stat-grid">
                <StatCard label="seeded releases" value={`${games.length}+`} icon={<Library />} />
                <StatCard label="avg. rating" value="4.6/5" icon={<CheckCircle2 />} />
                <StatCard label="secure checkout" value="JWT + validation" icon={<ShieldCheck />} />
              </div>
            </div>
            {featured && (
              <aside className="hero__feature">
                <img src={featured.heroImage} alt="" />
                <div>
                  <span>{featured.genre}</span>
                  <h2>{featured.title}</h2>
                  <p>{featured.description}</p>
                  <strong>{formatCurrency(featured.finalPrice ?? featured.price)}</strong>
                </div>
              </aside>
            )}
          </section>

          <section className="toolbar" id="catalog">
            <label className="search-field">
              <Search size={18} />
              <input value={search} onChange={(event) => setSearch(event.target.value)} placeholder="Search titles, studios, genres..." />
            </label>
            <select value={genre} onChange={(event) => setGenre(event.target.value)} aria-label="Filter by genre">
              <option>All</option>
              {genres.map((item) => (
                <option key={item}>{item}</option>
              ))}
            </select>
            <select value={sort} onChange={(event) => setSort(event.target.value)} aria-label="Sort games">
              <option value="popular">Most popular</option>
              <option value="rating">Top rated</option>
              <option value="new">Newest</option>
              <option value="price">Lowest price</option>
            </select>
          </section>

          <section className="content-grid">
            <div className="catalog-grid">
              {games.map((game) => (
                <GameCard key={game.id} game={game} owned={ownedIds.has(game.id)} onAddToCart={handleAddToCart} onInspect={setSelectedGame} />
              ))}
            </div>

            {selectedGame && (
              <aside className="detail-panel">
                <img src={selectedGame.heroImage} alt="" />
                <span className="eyebrow">{selectedGame.publisher}</span>
                <h2>{selectedGame.title}</h2>
                <p>{selectedGame.longDescription}</p>
                <div className="detail-list">
                  <div>
                    <small>Minimum RAM</small>
                    <strong>{selectedGame.requirements.minimum.memoryGb}GB</strong>
                  </div>
                  <div>
                    <small>Download</small>
                    <strong>{selectedGame.downloadSizeGb}GB</strong>
                  </div>
                  <div>
                    <small>Age rating</small>
                    <strong>{selectedGame.ageRating}</strong>
                  </div>
                </div>
                <button onClick={() => handleAddToCart(selectedGame.id)} disabled={ownedIds.has(selectedGame.id)}>
                  {ownedIds.has(selectedGame.id) ? "In library" : "Add to cart"}
                </button>
              </aside>
            )}
          </section>

          {user && recommendations.length > 0 && (
            <section className="recommendations">
              <div>
                <span className="eyebrow">For {user.name}</span>
                <h2>Personalized recommendations</h2>
              </div>
              <div className="mini-grid">
                {recommendations.map((game) => (
                  <button key={game.id} onClick={() => setSelectedGame(game)}>
                    <strong>{game.title}</strong>
                    <span>{game.genre}</span>
                  </button>
                ))}
              </div>
            </section>
          )}
        </>
      )}

      {view === "cart" && (
        <section className="page-panel">
          <div className="section-heading">
            <span className="eyebrow">Checkout</span>
            <h1>Cart and secure purchase</h1>
          </div>
          {cart.items.length === 0 ? (
            <p>Your cart is empty. Add a game from the catalog to generate a licensed order.</p>
          ) : (
            <div className="checkout-grid">
              <div className="line-items">
                {cart.items.map(({ game, finalPrice }) => (
                  <article key={game.id}>
                    <img src={game.heroImage} alt="" />
                    <div>
                      <strong>{game.title}</strong>
                      <span>{game.genre}</span>
                    </div>
                    <b>{formatCurrency(finalPrice)}</b>
                  </article>
                ))}
              </div>
              <aside className="summary-card">
                <h2>Order summary</h2>
                <p>
                  Subtotal <strong>{formatCurrency(cart.subtotal)}</strong>
                </p>
                <p>
                  Discount <strong>-{formatCurrency(cart.discount)}</strong>
                </p>
                <p className="total">
                  Total <strong>{formatCurrency(cart.total)}</strong>
                </p>
                <button onClick={handleCheckout}>
                  <Lock size={18} /> Pay with Stripe sandbox
                </button>
              </aside>
            </div>
          )}
        </section>
      )}

      {view === "library" && (
        <section className="page-panel">
          <div className="section-heading">
            <span className="eyebrow">Owned games</span>
            <h1>My library and installers</h1>
          </div>
          <div className="catalog-grid compact">
            {libraryGames.map((game) => (
              <article className="library-card" key={game.id}>
                <img src={game.heroImage} alt="" />
                <div>
                  <h3>{game.title}</h3>
                  <p>{game.description}</p>
                  <button>
                    <Download size={18} /> Install game
                  </button>
                </div>
              </article>
            ))}
          </div>
          <h2>Purchase history</h2>
          <div className="line-items">
            {purchases.map((purchase) => (
              <article key={purchase.id}>
                <span className="order-icon">PV</span>
                <div>
                  <strong>{purchase.id}</strong>
                  <span>{new Date(purchase.createdAt).toLocaleString()}</span>
                </div>
                <b>{formatCurrency(purchase.total)}</b>
              </article>
            ))}
          </div>
        </section>
      )}

      {view === "admin" && (
        <section className="page-panel">
          <div className="section-heading">
            <span className="eyebrow">Operations console</span>
            <h1>Admin dashboard</h1>
            {!user || user.role !== "admin" ? <button onClick={() => handleLogin("admin")}>Sign in as seeded admin</button> : null}
          </div>
          <div className="stat-grid">
            <StatCard label="gross revenue" value={formatCurrency(analytics.totalRevenue)} icon={<BarChart3 />} />
            <StatCard label="orders" value={`${analytics.totalOrders}`} icon={<CheckCircle2 />} />
            <StatCard label="users" value={`${analytics.totalUsers}`} icon={<UserRound />} />
            <StatCard label="active games" value={`${analytics.activeGames || games.length}`} icon={<Gamepad2 />} />
          </div>
          <div className="admin-grid">
            <article>
              <h2>Catalog governance</h2>
              <p>Add, update, discount, or archive games through the API while the storefront reflects changes instantly.</p>
              <ul>
                <li>Validated game metadata and requirements</li>
                <li>Promotion controls and featured placement</li>
                <li>Moderated user review workflow</li>
              </ul>
            </article>
            <article>
              <h2>Security posture</h2>
              <p>JWT auth, bcrypt password hashing, request validation, rate limits, Helmet headers, and role-based admin access.</p>
              <ul>
                <li>Mock payment provider boundary for Stripe/PayPal</li>
                <li>License key and installer link generation</li>
                <li>Compatibility checks before checkout</li>
              </ul>
            </article>
          </div>
        </section>
      )}
    </main>
  );
}
