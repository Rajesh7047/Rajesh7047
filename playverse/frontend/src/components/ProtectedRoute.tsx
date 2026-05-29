import { Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../auth";

export const ProtectedRoute: React.FC<{ adminOnly?: boolean }> = ({ adminOnly = false }) => {
  const auth = useAuth();

  if (!auth.isAuthenticated) {
    return <Navigate to="/auth" replace />;
  }
  if (adminOnly && auth.user?.role !== "admin") {
    return <Navigate to="/" replace />;
  }
  return <Outlet />;
};
