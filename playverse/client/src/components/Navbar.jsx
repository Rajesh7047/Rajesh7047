import { Link, NavLink, useNavigate } from 'react-router-dom';
import { Navbar as BSNavbar, Nav, Container, Badge } from 'react-bootstrap';
import { useAuth } from '../context/AuthContext.jsx';
import { useCart } from '../context/CartContext.jsx';

export default function Navbar() {
  const { user, isAuthenticated, isAdmin, logout } = useAuth();
  const { cart } = useCart();
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/');
  };

  return (
    <BSNavbar expand="lg" className="pv-navbar py-3" sticky="top">
      <Container className="pv-container-fluid">
        <BSNavbar.Brand as={Link} to="/" className="pv-brand">
          Play<span>Verse</span>
        </BSNavbar.Brand>
        <BSNavbar.Toggle aria-controls="pv-nav" className="border-secondary" />
        <BSNavbar.Collapse id="pv-nav">
          <Nav className="me-auto gap-1">
            <Nav.Link as={NavLink} to="/" end>
              Home
            </Nav.Link>
            <Nav.Link as={NavLink} to="/categories">
              Store
            </Nav.Link>
            {isAuthenticated && (
              <>
                <Nav.Link as={NavLink} to="/library">
                  My Library
                </Nav.Link>
                <Nav.Link as={NavLink} to="/orders">
                  Orders
                </Nav.Link>
              </>
            )}
            {isAdmin && (
              <Nav.Link as={NavLink} to="/admin">
                Admin
              </Nav.Link>
            )}
          </Nav>
          <Nav className="align-items-lg-center gap-2">
            {isAuthenticated ? (
              <>
                <Nav.Link as={NavLink} to="/bag" className="position-relative">
                  Cart
                  {cart.itemCount > 0 && (
                    <Badge bg="info" pill className="ms-1">
                      {cart.itemCount}
                    </Badge>
                  )}
                </Nav.Link>
                <span className="text-muted small d-none d-lg-inline">Hi, {user.username}</span>
                <button type="button" className="pv-btn-outline btn btn-sm" onClick={handleLogout}>
                  Log out
                </button>
              </>
            ) : (
              <>
                <Nav.Link as={NavLink} to="/auth">
                  Log in
                </Nav.Link>
                <Link to="/auth?mode=register" className="pv-btn-primary btn btn-sm">
                  Sign up
                </Link>
              </>
            )}
          </Nav>
        </BSNavbar.Collapse>
      </Container>
      <style>{`
        .pv-navbar { background: rgba(10, 14, 23, 0.92); backdrop-filter: blur(12px); border-bottom: 1px solid var(--pv-border); }
        .pv-brand { font-family: var(--font-display); font-weight: 700; font-size: 1.35rem; color: var(--pv-text) !important; }
        .pv-brand span { color: var(--pv-accent); }
        .nav-link { color: var(--pv-muted) !important; font-weight: 500; border-radius: 8px; }
        .nav-link.active, .nav-link:hover { color: var(--pv-text) !important; background: var(--pv-surface-2); }
      `}</style>
    </BSNavbar>
  );
}
