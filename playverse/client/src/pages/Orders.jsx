import { useEffect, useState } from 'react';
import { Table, Spinner, Badge } from 'react-bootstrap';
import api from '../api/client.js';
import { formatPrice } from '../utils/price.js';

export default function Orders() {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    api
      .get('/orders')
      .then((res) => setOrders(res.data.orders))
      .finally(() => setLoading(false));
  }, []);

  if (loading) {
    return (
      <div className="text-center py-5">
        <Spinner animation="border" />
      </div>
    );
  }

  return (
    <div className="pv-container">
      <h1 className="page-title">Order History</h1>
      <p className="page-subtitle">All your purchases and payment references</p>

      {orders.length === 0 ? (
        <p className="text-muted">No orders yet.</p>
      ) : (
        <Table responsive className="table-dark">
          <thead>
            <tr>
              <th>Date</th>
              <th>Items</th>
              <th>Total</th>
              <th>Status</th>
              <th>Reference</th>
            </tr>
          </thead>
          <tbody>
            {orders.map((order) => (
              <tr key={order._id}>
                <td>{new Date(order.createdAt).toLocaleDateString()}</td>
                <td>
                  {order.items.map((i) => (
                    <div key={i.game?._id || i.title}>{i.title || i.game?.title}</div>
                  ))}
                </td>
                <td className="pv-price">{formatPrice(order.total)}</td>
                <td>
                  <Badge bg={order.status === 'paid' ? 'success' : 'secondary'}>{order.status}</Badge>
                </td>
                <td>
                  <code className="small">{order.paymentReference}</code>
                </td>
              </tr>
            ))}
          </tbody>
        </Table>
      )}
    </div>
  );
}
