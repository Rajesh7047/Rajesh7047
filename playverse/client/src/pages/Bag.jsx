import { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { Table, Button, Alert, Card, Form } from 'react-bootstrap';
import api from '../api/client.js';
import { useCart } from '../context/CartContext.jsx';
import { useAuth } from '../context/AuthContext.jsx';
import { formatPrice } from '../utils/price.js';

export default function Bag() {
  const { cart, removeFromCart, clearCart, refreshCart } = useCart();
  const { refreshUser } = useAuth();
  const navigate = useNavigate();
  const [paymentMethod, setPaymentMethod] = useState('stripe');
  const [step, setStep] = useState('cart');
  const [message, setMessage] = useState('');
  const [processing, setProcessing] = useState(false);
  const [lastOrder, setLastOrder] = useState(null);

  const handleCheckout = async () => {
    setProcessing(true);
    setMessage('');
    try {
      setStep('payment');
      await new Promise((r) => setTimeout(r, 800));
      const { data } = await api.post('/orders/checkout', { paymentMethod });
      setLastOrder(data.order);
      await clearCart();
      await refreshUser();
      setStep('success');
    } catch (err) {
      setMessage(err.message);
      setStep('cart');
    } finally {
      setProcessing(false);
    }
  };

  if (step === 'success' && lastOrder) {
    return (
      <div className="pv-container text-center py-5">
        <Card className="pv-card p-5 mx-auto" style={{ maxWidth: 520 }}>
          <div className="display-4 mb-3">✓</div>
          <h1 className="h3">Payment successful</h1>
          <p className="text-muted">
            Reference: <code>{lastOrder.paymentReference}</code>
          </p>
          <p className="pv-price">Total: {formatPrice(lastOrder.total)}</p>
          <p>Games have been added to your library.</p>
          <div className="d-flex gap-2 justify-content-center flex-wrap">
            <Button className="pv-btn-primary" onClick={() => navigate('/library')}>
              Go to library
            </Button>
            <Button variant="outline-light" onClick={() => navigate('/orders')}>
              View orders
            </Button>
          </div>
        </Card>
      </div>
    );
  }

  return (
    <div className="pv-container">
      <h1 className="page-title">Shopping Cart</h1>
      <p className="page-subtitle">Review items before secure checkout</p>

      {message && <Alert variant="danger">{message}</Alert>}

      {cart.items.length === 0 ? (
        <Alert variant="secondary">
          Your cart is empty. <Link to="/categories">Continue shopping</Link>
        </Alert>
      ) : (
        <RowLayout>
          <Table responsive className="table-dark align-middle">
            <thead>
              <tr>
                <th>Game</th>
                <th>Price</th>
                <th />
              </tr>
            </thead>
            <tbody>
              {cart.items.map((item) => (
                <tr key={item.gameId}>
                  <td>
                    <div className="d-flex align-items-center gap-3">
                      <img
                        src={item.coverImage}
                        alt=""
                        width={64}
                        height={40}
                        className="rounded"
                        style={{ objectFit: 'cover' }}
                      />
                      <Link to={`/game/${item.slug}`} className="text-white">
                        {item.title}
                      </Link>
                    </div>
                  </td>
                  <td className="pv-price">{formatPrice(item.lineTotal)}</td>
                  <td>
                    <Button
                      size="sm"
                      variant="outline-danger"
                      onClick={() => removeFromCart(item.gameId)}
                    >
                      Remove
                    </Button>
                  </td>
                </tr>
              ))}
            </tbody>
          </Table>

          <Card className="pv-card p-4 mt-4">
            <h2 className="h5 mb-3">Payment</h2>
            {step === 'payment' && processing ? (
              <p className="text-muted">Processing secure payment via {paymentMethod}...</p>
            ) : (
              <>
                <Form.Group className="mb-3">
                  <Form.Label>Payment method</Form.Label>
                  <Form.Select
                    value={paymentMethod}
                    onChange={(e) => setPaymentMethod(e.target.value)}
                  >
                    <option value="stripe">Stripe (card)</option>
                    <option value="paypal">PayPal</option>
                  </Form.Select>
                </Form.Group>
                <div className="d-flex justify-content-between align-items-center mb-3">
                  <span className="text-muted">Subtotal</span>
                  <span className="pv-price h4 mb-0">{formatPrice(cart.subtotal)}</span>
                </div>
                <Button
                  className="w-100 pv-btn-primary"
                  disabled={processing}
                  onClick={handleCheckout}
                >
                  Pay {formatPrice(cart.subtotal)}
                </Button>
                <p className="small text-muted mt-2 mb-0 text-center">
                  Simulated checkout for demo — no real charges.
                </p>
              </>
            )}
          </Card>
        </RowLayout>
      )}
    </div>
  );
}

function RowLayout({ children }) {
  return <div>{children}</div>;
}
