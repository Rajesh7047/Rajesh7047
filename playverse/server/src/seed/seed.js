import 'dotenv/config';
import mongoose from 'mongoose';
import { connectDB } from '../config/db.js';
import { User } from '../models/User.js';
import { Game } from '../models/Game.js';
import { Cart } from '../models/Cart.js';
import { Order } from '../models/Order.js';
import { Review } from '../models/Review.js';
import { slugify } from '../utils/slugify.js';

const GAMES = [
  {
    title: 'Cyber Nexus: Reborn',
    description:
      'Dive into a neon-soaked open world where hackers and mercenaries fight for control of a fractured megacity. Master cybernetic upgrades, stealth takedowns, and high-speed chases.',
    shortDescription: 'Open-world cyberpunk action RPG',
    genre: 'Action',
    publisher: 'Neon Forge',
    price: 59.99,
    discountPercent: 20,
    coverImage: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&q=80',
    bannerImage: 'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=1200&q=80',
    tags: ['open-world', 'rpg', 'multiplayer'],
    popularity: 980,
    featured: true,
    rating: { average: 4.6, count: 1240 },
    fileSizeMb: 85000,
  },
  {
    title: 'Elder Realms Online',
    description:
      'Explore vast fantasy kingdoms, raid dungeons with friends, and craft legendary gear in this massively multiplayer adventure.',
    shortDescription: 'Fantasy MMORPG epic',
    genre: 'RPG',
    publisher: 'Mythic Gate',
    price: 49.99,
    discountPercent: 0,
    coverImage: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&q=80',
    tags: ['mmorpg', 'fantasy', 'co-op'],
    popularity: 1200,
    featured: true,
    rating: { average: 4.8, count: 3200 },
    fileSizeMb: 120000,
  },
  {
    title: 'Velocity Drift 24',
    description:
      'Experience next-gen arcade racing with dynamic weather, licensed tracks, and deep car customization.',
    shortDescription: 'Arcade racing simulator',
    genre: 'Racing',
    publisher: 'Turbo Axis',
    price: 39.99,
    discountPercent: 15,
    coverImage: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?w=600&q=80',
    tags: ['racing', 'multiplayer', 'sports'],
    popularity: 760,
    featured: true,
    rating: { average: 4.3, count: 890 },
    fileSizeMb: 45000,
  },
  {
    title: 'Stellar Command',
    description:
      'Command your fleet across procedurally generated galaxies. Trade, negotiate, or wage war in this deep space strategy title.',
    shortDescription: '4X space strategy',
    genre: 'Strategy',
    publisher: 'Orbital Works',
    price: 44.99,
    discountPercent: 10,
    coverImage: 'https://images.unsplash.com/photo-1614728263952-84ea256f9679?w=600&q=80',
    tags: ['strategy', '4x', 'sci-fi'],
    popularity: 540,
    rating: { average: 4.5, count: 620 },
    fileSizeMb: 28000,
  },
  {
    title: 'Phantom Manor',
    description:
      'A psychological horror adventure set in a decaying Victorian estate. Solve puzzles, hide from entities, and uncover a dark family secret.',
    shortDescription: 'Survival horror adventure',
    genre: 'Horror',
    publisher: 'Nocturne Labs',
    price: 29.99,
    discountPercent: 0,
    coverImage: 'https://images.unsplash.com/photo-1509248961158-e54f6934749c?w=600&q=80',
    tags: ['horror', 'single-player', 'story'],
    popularity: 430,
    rating: { average: 4.7, count: 410 },
    fileSizeMb: 35000,
  },
  {
    title: 'Farm Haven Simulator',
    description:
      'Build your dream farm, raise animals, and trade goods in a relaxing countryside simulation with seasonal events.',
    shortDescription: 'Relaxing farming sim',
    genre: 'Simulation',
    publisher: 'Green Pixel',
    price: 24.99,
    discountPercent: 25,
    coverImage: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=600&q=80',
    tags: ['simulation', 'casual', 'family'],
    popularity: 890,
    featured: true,
    rating: { average: 4.4, count: 2100 },
    fileSizeMb: 8000,
  },
  {
    title: 'Arena Legends',
    description:
      'Fast-paced 5v5 hero battles with unique abilities, ranked seasons, and esports-ready netcode.',
    shortDescription: 'Competitive hero shooter',
    genre: 'Action',
    publisher: 'Clash Interactive',
    price: 0,
    discountPercent: 0,
    coverImage: 'https://images.unsplash.com/photo-1538481199705-c710c4eabbfc?w=600&q=80',
    tags: ['free-to-play', 'multiplayer', 'esports'],
    popularity: 2500,
    featured: true,
    rating: { average: 4.2, count: 8900 },
    fileSizeMb: 55000,
  },
  {
    title: 'Puzzle Dimensions',
    description:
      'Manipulate gravity and portals across 200 mind-bending levels in this award-winning puzzle platformer.',
    shortDescription: 'Physics puzzle platformer',
    genre: 'Adventure',
    publisher: 'Mind Loop',
    price: 19.99,
    discountPercent: 0,
    coverImage: 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=600&q=80',
    tags: ['puzzle', 'indie', 'single-player'],
    popularity: 320,
    rating: { average: 4.9, count: 180 },
    fileSizeMb: 4000,
  },
  {
    title: 'Metro Heist: Underground',
    description:
      'Plan elaborate heists with your crew in a living underground city. Stealth, hacking, and shootouts await.',
    shortDescription: 'Co-op heist action',
    genre: 'Action',
    publisher: 'Shadow Circuit',
    price: 54.99,
    discountPercent: 30,
    coverImage: 'https://images.unsplash.com/photo-1556438064-2d7646166914?w=600&q=80',
    tags: ['co-op', 'stealth', 'action'],
    popularity: 670,
    rating: { average: 4.1, count: 950 },
    fileSizeMb: 72000,
  },
  {
    title: 'Civilization of Empires VI',
    description:
      'Lead your civilization from the stone age to the space age. Diplomacy, warfare, and culture shape your legacy.',
    shortDescription: 'Turn-based empire builder',
    genre: 'Strategy',
    publisher: 'Grand Tactics',
    price: 69.99,
    discountPercent: 0,
    coverImage: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5?w=600&q=80',
    tags: ['strategy', '4x', 'historical'],
    popularity: 1100,
    rating: { average: 4.6, count: 2800 },
    fileSizeMb: 95000,
  },
];

async function seed() {
  const uri = process.env.MONGODB_URI || 'mongodb://127.0.0.1:27017/playverse';
  await connectDB(uri);

  await Promise.all([User.deleteMany({}), Game.deleteMany({}), Cart.deleteMany({}), Order.deleteMany({}), Review.deleteMany({})]);

  const admin = await User.create({
    username: 'admin',
    email: 'admin@playverse.com',
    password: 'admin123',
    role: 'admin',
  });

  const demoUser = await User.create({
    username: 'gamer_demo',
    email: 'demo@playverse.com',
    password: 'demo1234',
    role: 'user',
    preferences: { genres: ['Action', 'RPG'] },
  });

  await Cart.create({ user: admin._id, items: [] });
  await Cart.create({ user: demoUser._id, items: [] });

  const games = await Game.insertMany(
    GAMES.map((g) => ({
      ...g,
      slug: slugify(g.title),
      downloadUrl: `https://cdn.playverse.local/downloads/${slugify(g.title)}.zip`,
      screenshots: [g.coverImage],
      isActive: true,
    }))
  );

  demoUser.library.push(games[7]._id);
  await demoUser.save();

  console.log('Seed complete');
  console.log('Admin: admin@playverse.com / admin123');
  console.log('Demo user: demo@playverse.com / demo1234');
  console.log(`Games seeded: ${games.length}`);

  await mongoose.disconnect();
}

seed().catch((err) => {
  console.error(err);
  process.exit(1);
});
