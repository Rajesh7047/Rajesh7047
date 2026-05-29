import { Link } from 'react-router-dom';
import { Gamepad2, Home, ArrowLeft } from 'lucide-react';

const NotFound = () => (
  <div className="min-h-screen flex items-center justify-center">
    <div className="text-center">
      <div className="w-24 h-24 bg-primary-600/20 rounded-full flex items-center justify-center mx-auto mb-6 border border-primary-600/30">
        <Gamepad2 size={40} className="text-primary-400" />
      </div>
      <h1 className="font-gaming text-7xl font-bold text-white mb-2">
        <span className="text-gradient">404</span>
      </h1>
      <h2 className="font-gaming text-2xl font-bold text-white mb-3">Level Not Found</h2>
      <p className="text-gray-500 mb-8 max-w-sm mx-auto">
        Looks like you've wandered into an uncharted area of the game world. Let's get you back on track.
      </p>
      <div className="flex items-center justify-center gap-3">
        <Link to="/" className="btn-primary">
          <Home size={16} /> Go Home
        </Link>
        <Link to="/store" className="btn-secondary">
          <ArrowLeft size={16} /> Browse Store
        </Link>
      </div>
    </div>
  </div>
);

export default NotFound;
