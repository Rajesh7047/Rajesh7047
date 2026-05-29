import { useState, useEffect } from 'react';
import { Link, useParams } from 'react-router-dom';
import { Package, Check, Calendar, CreditCard, ArrowLeft, Hash } from 'lucide-react';
import { ordersAPI } from '../services/api';
import { useAuth } from '../context/AuthContext';
import LoadingSpinner from '../components/ui/LoadingSpinner';
import { formatDate } from '../utils/helpers';
import Badge from '../components/ui/Badge';

const OrderDetail = ({ orderId }) => {
  const [order, setOrder] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    ordersAPI.getById(orderId).then(({ data }) => setOrder(data.order)).finally(() => setLoading(false));
  }, [orderId]);

  if (loading) return <div className="flex justify-center py-10"><LoadingSpinner /></div>;
  if (!order) return <p className="text-gray-500 text-center py-10">Order not found.</p>;

  return (
    <div className="page-container py-8">
      <Link to="/orders" className="flex items-center gap-2 text-gray-400 hover:text-gray-200 text-sm mb-6">
        <ArrowLeft size={16} /> Back to Orders
      </Link>
      <div className="card p-6 max-w-2xl mx-auto">
        <div className="flex items-center gap-3 mb-6">
          <div className="w-12 h-12 bg-emerald-600/20 rounded-full flex items-center justify-center">
            <Check size={24} className="text-emerald-400" />
          </div>
          <div>
            <h1 className="font-gaming text-xl font-bold text-white">Order Confirmed!</h1>
            <p className="text-gray-500 text-sm">Your games are ready to play.</p>
          </div>
        </div>
        <div className="space-y-3 mb-6">
          {[
            { icon: Hash, label: 'Order ID', value: order._id },
            { icon: Calendar, label: 'Date', value: formatDate(order.createdAt) },
            { icon: CreditCard, label: 'Payment', value: order.paymentMethod },
            { icon: Check, label: 'Status', value: order.status },
          ].map(({ icon: Icon, label, value }) => (
            <div key={label} className="flex items-center justify-between py-2 border-b border-gaming-border">
              <div className="flex items-center gap-2 text-gray-500 text-sm">
                <Icon size={14} /> {label}
              </div>
              <span className={`text-sm font-medium capitalize ${value === 'completed' ? 'text-emerald-400' : 'text-gray-300'}`}>{value}</span>
            </div>
          ))}
        </div>
        <div className="space-y-3">
          {order.items.map((item, i) => (
            <div key={i} className="flex items-center gap-3 bg-gaming-darker rounded-lg p-3">
              {item.coverImage && <img src={item.coverImage} alt={item.title} className="w-12 h-16 object-cover rounded" />}
              <div className="flex-1">
                <p className="text-white font-semibold text-sm">{item.title}</p>
              </div>
              <span className="text-primary-400 font-bold text-sm">{item.price === 0 ? 'FREE' : `$${item.price.toFixed(2)}`}</span>
            </div>
          ))}
        </div>
        <div className="border-t border-gaming-border pt-4 mt-4 flex justify-between font-gaming font-bold text-white text-lg">
          <span>Total</span>
          <span>${order.totalAmount.toFixed(2)}</span>
        </div>
        <div className="flex gap-3 mt-6">
          <Link to="/library" className="btn-primary flex-1 justify-center">Go to Library</Link>
          <Link to="/store" className="btn-secondary flex-1 justify-center">Continue Shopping</Link>
        </div>
      </div>
    </div>
  );
};

const OrdersList = () => {
  const [orders, setOrders] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    ordersAPI.getMy().then(({ data }) => setOrders(data.orders)).finally(() => setLoading(false));
  }, []);

  if (loading) return <div className="flex justify-center py-20"><LoadingSpinner size="lg" /></div>;

  return (
    <div className="page-container py-8">
      <h1 className="font-gaming text-2xl font-bold text-white mb-6 flex items-center gap-2">
        <Package size={24} className="text-primary-400" /> Order History
      </h1>
      {orders.length === 0 ? (
        <div className="text-center py-20">
          <Package size={56} className="text-gray-600 mx-auto mb-4" />
          <h2 className="font-gaming text-xl text-white mb-2">No orders yet</h2>
          <Link to="/store" className="btn-primary inline-flex mt-4">Shop Now</Link>
        </div>
      ) : (
        <div className="space-y-4 max-w-2xl">
          {orders.map((order) => (
            <div key={order._id} className="card p-5">
              <div className="flex items-center justify-between mb-3">
                <div>
                  <p className="text-gray-500 text-xs">Order #{order._id.slice(-8).toUpperCase()}</p>
                  <p className="text-white font-semibold">{formatDate(order.createdAt)}</p>
                </div>
                <div className="text-right">
                  <Badge variant="success">{order.status}</Badge>
                  <p className="text-white font-gaming font-bold mt-1">${order.totalAmount.toFixed(2)}</p>
                </div>
              </div>
              <div className="flex items-center gap-2 mb-3">
                {order.items.slice(0, 4).map((item, i) =>
                  item.coverImage && <img key={i} src={item.coverImage} alt="" className="w-10 h-14 object-cover rounded" />
                )}
                {order.items.length > 4 && <span className="text-gray-500 text-sm">+{order.items.length - 4} more</span>}
              </div>
              <Link to={`/orders/${order._id}`} className="btn-secondary py-2 text-sm">View Details</Link>
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

const Orders = () => {
  const { isAuthenticated } = useAuth();
  const { id } = useParams();

  if (!isAuthenticated) return (
    <div className="min-h-screen flex items-center justify-center">
      <div className="text-center">
        <Package size={48} className="text-gray-600 mx-auto mb-4" />
        <h2 className="font-gaming text-xl text-white mb-2">Sign in to view orders</h2>
        <Link to="/auth?mode=login" className="btn-primary inline-flex mt-4">Sign In</Link>
      </div>
    </div>
  );

  return id ? <OrderDetail orderId={id} /> : <OrdersList />;
};

export default Orders;
