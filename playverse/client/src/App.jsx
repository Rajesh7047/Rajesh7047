import { Routes, Route } from 'react-router-dom';
import Layout from './components/Layout.jsx';
import { ProtectedRoute, AdminRoute } from './components/ProtectedRoute.jsx';
import Home from './pages/Home.jsx';
import Categories from './pages/Categories.jsx';
import GameDetail from './pages/GameDetail.jsx';
import AuthPage from './pages/AuthPage.jsx';
import Library from './pages/Library.jsx';
import Bag from './pages/Bag.jsx';
import Orders from './pages/Orders.jsx';
import Admin from './pages/Admin.jsx';

export default function App() {
  return (
    <Routes>
      <Route element={<Layout />}>
        <Route index element={<Home />} />
        <Route path="categories" element={<Categories />} />
        <Route path="game/:slug" element={<GameDetail />} />
        <Route path="auth" element={<AuthPage />} />
        <Route
          path="library"
          element={
            <ProtectedRoute>
              <Library />
            </ProtectedRoute>
          }
        />
        <Route
          path="bag"
          element={
            <ProtectedRoute>
              <Bag />
            </ProtectedRoute>
          }
        />
        <Route
          path="orders"
          element={
            <ProtectedRoute>
              <Orders />
            </ProtectedRoute>
          }
        />
        <Route
          path="admin"
          element={
            <AdminRoute>
              <Admin />
            </AdminRoute>
          }
        />
      </Route>
    </Routes>
  );
}
