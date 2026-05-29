import { NavLink, Outlet } from "react-router-dom";
import { useAuth } from "../auth";

export const Layout = () => {
  const auth = useAuth();

  return (
    <div className="shell">
      <header className="topbar">
        <div>
          <h1>PlayVerse</h1>
          <p className="subtitle">Discover, buy, and install your next favorite PC game.</p>
        </div>
        <div className="topbar-actions">
          {auth.user ? (
            <>
              <span className="badge">{auth.user.name}</span>
              <button className="button ghost" onClick={auth.logout}>
                Logout
              </button>
            </>
          ) : (
            <NavLink className="button" to="/auth">
              Login
            </NavLink>
          )}
        </div>
      </header>

      <nav className="tabs">
        <NavLink to="/" end>
          Catalog
        </NavLink>
        <NavLink to="/cart">Cart</NavLink>
        <NavLink to="/library">My Library</NavLink>
        <NavLink to="/wishlist">Wishlist</NavLink>
        {auth.user?.role === "admin" && <NavLink to="/admin">Admin</NavLink>}
      </nav>

      <main className="content">
        <Outlet />
      </main>
    </div>
  );
};
