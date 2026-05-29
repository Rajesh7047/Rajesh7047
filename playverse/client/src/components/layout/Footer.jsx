import { Link } from 'react-router-dom';
import { Gamepad2, Share2, Globe2, ExternalLink, MessageCircle } from 'lucide-react';

const Footer = () => (
  <footer className="bg-gaming-darker border-t border-gaming-border mt-20">
    <div className="page-container py-12">
      <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
        {/* Brand */}
        <div className="col-span-1 md:col-span-2">
          <div className="flex items-center gap-2 mb-4">
            <div className="w-8 h-8 bg-primary-600 rounded-lg flex items-center justify-center">
              <Gamepad2 size={18} className="text-white" />
            </div>
            <span className="font-gaming font-bold text-white text-xl">
              Play<span className="text-gradient">Verse</span>
            </span>
          </div>
          <p className="text-gray-500 text-sm leading-relaxed max-w-sm">
            Your ultimate gaming universe. Browse, purchase, and manage your game library with a platform built for gamers by gamers.
          </p>
          <div className="flex items-center gap-3 mt-4">
            {[Share2, Globe2, ExternalLink, MessageCircle].map((Icon, i) => (
              <a key={i} href="#" className="w-9 h-9 bg-gaming-card border border-gaming-border rounded-lg flex items-center justify-center text-gray-500 hover:text-primary-400 hover:border-primary-600 transition-all">
                <Icon size={16} />
              </a>
            ))}
          </div>
        </div>

        {/* Links */}
        <div>
          <h4 className="font-gaming font-semibold text-white mb-4 text-sm">Store</h4>
          <ul className="space-y-2">
            {['New Releases', 'Featured', 'Top Sellers', 'Free Games', 'Sale'].map((item) => (
              <li key={item}>
                <Link to="/store" className="text-gray-500 hover:text-gray-300 text-sm transition-colors">{item}</Link>
              </li>
            ))}
          </ul>
        </div>

        <div>
          <h4 className="font-gaming font-semibold text-white mb-4 text-sm">Support</h4>
          <ul className="space-y-2">
            {['Help Center', 'Privacy Policy', 'Terms of Service', 'Refund Policy', 'Contact Us'].map((item) => (
              <li key={item}>
                <a href="#" className="text-gray-500 hover:text-gray-300 text-sm transition-colors">{item}</a>
              </li>
            ))}
          </ul>
        </div>
      </div>

      <div className="mt-10 pt-6 border-t border-gaming-border flex flex-col sm:flex-row items-center justify-between gap-4">
        <p className="text-gray-600 text-sm">© {new Date().getFullYear()} PlayVerse. All rights reserved.</p>
        <p className="text-gray-600 text-sm">Built with React & Node.js</p>
      </div>
    </div>
  </footer>
);

export default Footer;
