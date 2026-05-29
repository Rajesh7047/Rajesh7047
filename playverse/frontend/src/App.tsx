import { Navigate, Route, Routes } from "react-router-dom";
import { useAuth } from "./auth";
import { Layout } from "./components/Layout";
import { ProtectedRoute } from "./components/ProtectedRoute";
import { AdminPage } from "./pages/AdminPage";
import { AuthPage } from "./pages/AuthPage";
import { CartPage } from "./pages/CartPage";
import { CatalogPage } from "./pages/CatalogPage";
import { LibraryPage } from "./pages/LibraryPage";
import { WishlistPage } from "./pages/WishlistPage";

function App() {
  const auth = useAuth();

  return (
    <Routes>
      <Route path="/auth" element={auth.isAuthenticated ? <Navigate to="/" replace /> : <AuthPage />} />
      <Route path="/" element={<Layout />}>
        <Route index element={<CatalogPage />} />
        <Route element={<ProtectedRoute />}>
          <Route path="cart" element={<CartPage />} />
          <Route path="library" element={<LibraryPage />} />
          <Route path="wishlist" element={<WishlistPage />} />
        </Route>
        <Route element={<ProtectedRoute adminOnly />}>
          <Route path="admin" element={<AdminPage />} />
        </Route>
      </Route>
      <Route path="*" element={<Navigate to="/" replace />} />
    </Routes>
  );
}

export default App;
