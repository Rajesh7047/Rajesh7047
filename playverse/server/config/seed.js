require('dotenv').config({ path: '../.env' });
const mongoose = require('mongoose');
const bcrypt = require('bcryptjs');

const MONGO_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/playverse';

const games = [
  {
    title: 'Cyber Odyssey 2077',
    slug: 'cyber-odyssey-2077',
    description:
      'Dive into a sprawling open-world cyberpunk RPG set in a neon-drenched megacity. Build your character, choose your path, and uncover conspiracies that threaten the entire digital world. With over 200 hours of content, dynamic factions, and a living city that reacts to your choices, Cyber Odyssey 2077 redefines what an RPG can be.',
    shortDescription: 'Open-world cyberpunk RPG with 200+ hours of immersive content.',
    price: 49.99,
    originalPrice: 59.99,
    discount: 17,
    genre: ['RPG', 'Action'],
    developer: 'NeonForge Studios',
    publisher: 'PixelPath Publishing',
    releaseDate: new Date('2024-03-15'),
    tags: ['cyberpunk', 'open-world', 'story-rich', 'mature'],
    coverImage: 'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=600&q=80',
    screenshots: [
      'https://images.unsplash.com/photo-1511512578047-dfb367046420?w=800&q=80',
      'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=800&q=80',
    ],
    fileSize: '75 GB',
    isFeatured: true,
    ageRating: 'M',
    averageRating: 4.7,
    reviewCount: 2840,
    purchaseCount: 15200,
    systemRequirements: {
      minimum: {
        os: 'Windows 10 64-bit',
        processor: 'Intel Core i5-8600K',
        memory: '12 GB RAM',
        graphics: 'NVIDIA GTX 1060 6GB',
        storage: '75 GB SSD',
      },
      recommended: {
        os: 'Windows 11 64-bit',
        processor: 'Intel Core i7-12700K',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 3080',
        storage: '75 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Eternal Realms Online',
    slug: 'eternal-realms-online',
    description:
      'The most expansive MMORPG ever created. Choose from 12 unique races and 30 specializations as you explore a world forged by ancient gods. Battle millions of players in real-time wars, conquer dungeons with your guild, and craft legendary equipment. Eternal Realms Online evolves every season with new content, storylines, and world events.',
    shortDescription: 'The ultimate MMORPG experience with millions of players worldwide.',
    price: 0,
    originalPrice: 0,
    discount: 0,
    genre: ['MMORPG', 'RPG'],
    developer: 'WorldCraft Entertainment',
    publisher: 'WorldCraft Entertainment',
    releaseDate: new Date('2023-06-01'),
    tags: ['mmorpg', 'free-to-play', 'multiplayer', 'fantasy'],
    coverImage: 'https://images.unsplash.com/photo-1493711662062-fa541adb3fc8?w=600&q=80',
    screenshots: [
      'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=800&q=80',
    ],
    fileSize: '45 GB',
    isFeatured: true,
    ageRating: 'T',
    averageRating: 4.5,
    reviewCount: 8920,
    purchaseCount: 45000,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-6600',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 970',
        storage: '45 GB SSD',
      },
      recommended: {
        os: 'Windows 11',
        processor: 'Intel Core i7-10700K',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 2080',
        storage: '45 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Shadow Tactics: Reborn',
    slug: 'shadow-tactics-reborn',
    description:
      "A tactical stealth game set in feudal Japan. Lead a team of five unique specialists through 20 challenging missions across stunning feudal landscapes. Master each character's abilities, set up elaborate traps, and outsmart enemies in a game that rewards creativity and patience. Reborn features fully reworked visuals and an expanded campaign.",
    shortDescription: 'Tactical stealth masterpiece set in feudal Japan.',
    price: 29.99,
    originalPrice: 39.99,
    discount: 25,
    genre: ['Strategy', 'Action'],
    developer: 'Mimimi Games',
    publisher: 'Daedalic Entertainment',
    releaseDate: new Date('2024-01-20'),
    tags: ['stealth', 'tactical', 'japan', 'strategy'],
    coverImage: 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=600&q=80',
    fileSize: '8 GB',
    isFeatured: false,
    ageRating: 'T',
    averageRating: 4.8,
    reviewCount: 1560,
    purchaseCount: 8400,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-4460',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 770',
        storage: '8 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i7-6700',
        memory: '16 GB RAM',
        graphics: 'NVIDIA GTX 1070',
        storage: '8 GB SSD',
      },
    },
  },
  {
    title: 'Velocity Rush',
    slug: 'velocity-rush',
    description:
      'The next generation of arcade racing. Feel the adrenaline as you tear through 60 tracks across 12 exotic locations. Customize over 200 cars with a deep tuning system, compete in online tournaments with 32-player lobbies, and experience the most authentic driving physics ever crafted for arcade racing. Velocity Rush sets a new standard.',
    shortDescription: 'Next-gen arcade racing with 200+ customizable cars.',
    price: 34.99,
    originalPrice: 34.99,
    discount: 0,
    genre: ['Racing', 'Sports'],
    developer: 'TurboPixel Games',
    publisher: 'TurboPixel Games',
    releaseDate: new Date('2024-05-10'),
    tags: ['racing', 'cars', 'multiplayer', 'arcade'],
    coverImage: 'https://images.unsplash.com/photo-1493238792000-8113da705763?w=600&q=80',
    fileSize: '35 GB',
    isFeatured: true,
    ageRating: 'E',
    averageRating: 4.3,
    reviewCount: 3100,
    purchaseCount: 18500,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-6600K',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 1050 Ti',
        storage: '35 GB SSD',
      },
      recommended: {
        os: 'Windows 11',
        processor: 'Intel Core i7-9700K',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 2070',
        storage: '35 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Hollow Depths',
    slug: 'hollow-depths',
    description:
      'A hauntingly beautiful horror-survival experience set deep beneath the ocean. You wake up alone on a research station that has gone dark. As you explore the sunken corridors, you piece together what happened while something hunts you in the dark. With procedurally generated layouts and adaptive AI, no two runs are the same.',
    shortDescription: 'Procedural underwater horror with an adaptive hunting AI.',
    price: 19.99,
    originalPrice: 24.99,
    discount: 20,
    genre: ['Horror', 'Adventure'],
    developer: 'Abyss Interactive',
    publisher: 'Indie Void',
    releaseDate: new Date('2023-10-31'),
    tags: ['horror', 'survival', 'underwater', 'atmospheric'],
    coverImage: 'https://images.unsplash.com/photo-1518408225513-c67875b1b3e3?w=600&q=80',
    fileSize: '12 GB',
    isFeatured: false,
    ageRating: 'M',
    averageRating: 4.6,
    reviewCount: 4200,
    purchaseCount: 22000,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-7500',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 1060',
        storage: '12 GB SSD',
      },
      recommended: {
        os: 'Windows 11',
        processor: 'Intel Core i7-9700',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 2060',
        storage: '12 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Forge & Flame',
    slug: 'forge-and-flame',
    description:
      "A deeply crafted survival simulation where you build civilizations from scratch. Start as a lone settler, harvest resources, research technologies, and grow your settlement into a sprawling empire. Manage needs, deal with seasons, bandits, and natural disasters. Forge & Flame blends city-building with survival in ways you've never seen.",
    shortDescription: 'City-building survival simulation - build your empire from nothing.',
    price: 24.99,
    originalPrice: 24.99,
    discount: 0,
    genre: ['Simulation', 'Strategy'],
    developer: 'Ember Workshop',
    publisher: 'Ember Workshop',
    releaseDate: new Date('2024-02-14'),
    tags: ['city-builder', 'survival', 'simulation', 'crafting'],
    coverImage: 'https://images.unsplash.com/photo-1448375240586-882707db888b?w=600&q=80',
    fileSize: '6 GB',
    isFeatured: false,
    ageRating: 'E10+',
    averageRating: 4.4,
    reviewCount: 2100,
    purchaseCount: 11300,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-4570',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 960',
        storage: '6 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i7-8700K',
        memory: '16 GB RAM',
        graphics: 'NVIDIA GTX 1070',
        storage: '6 GB SSD',
      },
    },
  },
  {
    title: 'Apex Strikers',
    slug: 'apex-strikers',
    description:
      "The most intense team-based FPS of the decade. 5v5 tactical combat where every bullet counts. Master 30 agents, each with unique abilities that synergize with your team. Compete in ranked seasons, watch your skills improve with detailed post-match analytics, and rise through the leaderboards. Join 40 million players worldwide in Apex Strikers' competitive arena.",
    shortDescription: 'Competitive 5v5 tactical FPS with 30 unique agents.',
    price: 0,
    originalPrice: 0,
    discount: 0,
    genre: ['FPS', 'Action'],
    developer: 'Pinnacle Interactive',
    publisher: 'Pinnacle Interactive',
    releaseDate: new Date('2023-01-15'),
    tags: ['fps', 'competitive', 'free-to-play', 'tactical'],
    coverImage: 'https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=600&q=80',
    fileSize: '22 GB',
    isFeatured: true,
    ageRating: 'M',
    averageRating: 4.2,
    reviewCount: 15600,
    purchaseCount: 75000,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i3-7320',
        memory: '4 GB RAM',
        graphics: 'NVIDIA GTX 1050 Ti',
        storage: '22 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i5-12400F',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 3060',
        storage: '22 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Verdant Chronicles',
    slug: 'verdant-chronicles',
    description:
      "An epic fantasy RPG with a world that breathes and changes around you. Over 500 quests, 8 fully voiced companions, and a moral alignment system where every choice shapes your destiny and the fate of kingdoms. Verdant Chronicles features hand-crafted open world environments spanning tundras, jungles, deserts, and ancient ruins in a 120-hour campaign.",
    shortDescription: 'Epic 120-hour fantasy RPG with 8 companions and a living world.',
    price: 54.99,
    originalPrice: 59.99,
    discount: 8,
    genre: ['RPG', 'Adventure'],
    developer: 'GreenLeaf Studios',
    publisher: 'GreenLeaf Studios',
    releaseDate: new Date('2024-04-05'),
    tags: ['fantasy', 'rpg', 'story-rich', 'open-world'],
    coverImage: 'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=600&q=80',
    fileSize: '55 GB',
    isFeatured: true,
    ageRating: 'T',
    averageRating: 4.9,
    reviewCount: 6800,
    purchaseCount: 31000,
    systemRequirements: {
      minimum: {
        os: 'Windows 10 64-bit',
        processor: 'Intel Core i7-8700K',
        memory: '12 GB RAM',
        graphics: 'NVIDIA RTX 2060',
        storage: '55 GB SSD',
      },
      recommended: {
        os: 'Windows 11',
        processor: 'Intel Core i9-12900K',
        memory: '32 GB RAM',
        graphics: 'NVIDIA RTX 4070',
        storage: '55 GB NVMe SSD',
      },
    },
  },
  {
    title: 'PixelQuest: Retro Saga',
    slug: 'pixelquest-retro-saga',
    description:
      "A love letter to classic platformers. PixelQuest brings the magic of retro gaming into the modern era with tight controls, 50 hand-crafted levels, hidden secrets at every turn, and a chiptune soundtrack that will burrow into your heart. Challenge rooms, time trials, and a co-op mode make this an indie gem you'll return to again and again.",
    shortDescription: 'Charming retro platformer with 50 levels and co-op mode.',
    price: 14.99,
    originalPrice: 19.99,
    discount: 25,
    genre: ['Platformer', 'Indie'],
    developer: 'BitByte Creations',
    publisher: 'BitByte Creations',
    releaseDate: new Date('2023-08-22'),
    tags: ['platformer', 'retro', 'pixel-art', 'indie', 'co-op'],
    coverImage: 'https://images.unsplash.com/photo-1550745165-9bc0b252726f?w=600&q=80',
    fileSize: '1.5 GB',
    isFeatured: false,
    ageRating: 'E',
    averageRating: 4.7,
    reviewCount: 3900,
    purchaseCount: 19500,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i3-6100',
        memory: '4 GB RAM',
        graphics: 'Any DirectX 11 compatible',
        storage: '2 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i5-6600',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 960',
        storage: '2 GB SSD',
      },
    },
  },
  {
    title: 'Iron Battalion',
    slug: 'iron-battalion',
    description:
      "Command the most immersive WWII real-time strategy experience ever made. Lead authentic historical units across 40 missions spanning North Africa, Western Europe, and the Eastern Front. Research technologies, manage supply chains, and execute flanking maneuvers that change the course of history. Iron Battalion's AI adapts to every strategy you try.",
    shortDescription: 'Deep WWII real-time strategy across 40 historical missions.',
    price: 39.99,
    originalPrice: 39.99,
    discount: 0,
    genre: ['Strategy'],
    developer: 'WarGames Workshop',
    publisher: 'Historical Interactive',
    releaseDate: new Date('2024-06-01'),
    tags: ['strategy', 'ww2', 'historical', 'rts'],
    coverImage: 'https://images.unsplash.com/photo-1519389950473-47ba0277781c?w=600&q=80',
    fileSize: '18 GB',
    isFeatured: false,
    ageRating: 'T',
    averageRating: 4.5,
    reviewCount: 1820,
    purchaseCount: 9600,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-6500',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 1060',
        storage: '18 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i7-9700K',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 2070',
        storage: '18 GB NVMe SSD',
      },
    },
  },
  {
    title: 'NeonBrawl Arena',
    slug: 'neonbrawl-arena',
    description:
      'The flashiest, most explosive fighting game in years. 50 fighters across 5 unique factions clash in neon-lit arenas from cyberpunk streets to interdimensional battlegrounds. NeonBrawl features frame-perfect online netcode, a deep combo system accessible to newcomers, full story mode, and a thriving esports scene with monthly tournaments.',
    shortDescription: 'Explosive 2D fighter with 50 characters and top-tier netcode.',
    price: 44.99,
    originalPrice: 49.99,
    discount: 10,
    genre: ['Fighting', 'Action'],
    developer: 'Clash Circuit Studios',
    publisher: 'Clash Circuit Studios',
    releaseDate: new Date('2024-03-01'),
    tags: ['fighting', 'esports', 'multiplayer', 'neon'],
    coverImage: 'https://images.unsplash.com/photo-1538481199705-c710c4e965fc?w=600&q=80',
    fileSize: '28 GB',
    isFeatured: false,
    ageRating: 'T',
    averageRating: 4.4,
    reviewCount: 2700,
    purchaseCount: 14200,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i5-6600',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 1060',
        storage: '28 GB SSD',
      },
      recommended: {
        os: 'Windows 11',
        processor: 'Intel Core i7-8700',
        memory: '16 GB RAM',
        graphics: 'NVIDIA RTX 2070',
        storage: '28 GB NVMe SSD',
      },
    },
  },
  {
    title: 'Mind Maze: Puzzles Unleashed',
    slug: 'mind-maze-puzzles-unleashed',
    description:
      'A groundbreaking puzzle game that challenges your perception of reality. 300 handcrafted puzzles across 10 mind-bending worlds that bend space, time, and logic. Each world introduces a new mechanic that evolves across the chapter, creating an experience that is always surprising. Mind Maze won five indie game awards and has a Metacritic score of 94.',
    shortDescription: 'Award-winning puzzle game with 300 mind-bending challenges.',
    price: 17.99,
    originalPrice: 22.99,
    discount: 22,
    genre: ['Puzzle', 'Indie'],
    developer: 'Cerebral Pixels',
    publisher: 'Cerebral Pixels',
    releaseDate: new Date('2023-11-14'),
    tags: ['puzzle', 'indie', 'mind-bending', 'award-winning'],
    coverImage: 'https://images.unsplash.com/photo-1614632537239-e2258b30c5ed?w=600&q=80',
    fileSize: '3 GB',
    isFeatured: false,
    ageRating: 'E',
    averageRating: 4.8,
    reviewCount: 5600,
    purchaseCount: 28000,
    systemRequirements: {
      minimum: {
        os: 'Windows 10',
        processor: 'Intel Core i3-8100',
        memory: '4 GB RAM',
        graphics: 'NVIDIA GTX 750 Ti',
        storage: '4 GB SSD',
      },
      recommended: {
        os: 'Windows 10/11',
        processor: 'Intel Core i5-8400',
        memory: '8 GB RAM',
        graphics: 'NVIDIA GTX 1060',
        storage: '4 GB SSD',
      },
    },
  },
];

async function seed() {
  try {
    await mongoose.connect(MONGO_URI);
    console.log('Connected to MongoDB');

    const User = require('../models/User');
    const Game = require('../models/Game');

    await Game.deleteMany({});
    await User.deleteMany({});

    const createdGames = await Game.insertMany(games);
    console.log(`Seeded ${createdGames.length} games`);

    const adminPassword = await bcrypt.hash('Admin@123', 12);
    const userPassword = await bcrypt.hash('User@123', 12);

    const admin = await User.create({
      username: 'admin',
      email: 'admin@playverse.com',
      password: 'Admin@123',
      role: 'admin',
    });

    const demoUser = await User.create({
      username: 'gamer_pro',
      email: 'demo@playverse.com',
      password: 'User@123',
      role: 'user',
    });

    console.log(`Admin created: ${admin.email} / Admin@123`);
    console.log(`Demo user created: ${demoUser.email} / User@123`);
    console.log('Database seeded successfully!');
  } catch (err) {
    console.error('Seed error:', err);
  } finally {
    await mongoose.disconnect();
  }
}

seed();
