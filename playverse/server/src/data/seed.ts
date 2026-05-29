import bcrypt from "bcryptjs";
import type { Cart, Game, Purchase, Review, User } from "../types.js";

const now = new Date().toISOString();

export const seedGames: Game[] = [
  {
    id: "game-neon-odyssey",
    slug: "neon-odyssey",
    title: "Neon Odyssey",
    publisher: "HelioForge",
    developer: "HelioForge",
    genre: "Action RPG",
    tags: ["Cyberpunk", "Open World", "Controller", "Story Rich"],
    platforms: ["Windows", "Steam Deck"],
    price: 59.99,
    discountPercent: 15,
    heroImage: "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1200&q=80",
    trailerUrl: "https://example.com/trailers/neon-odyssey",
    description: "Hack, ride, and fight through a rain-soaked megacity powered by rogue AI factions.",
    longDescription:
      "Neon Odyssey blends kinetic melee combat, stealth hacking, and branching faction choices in a living cyberpunk city. Build your crew, upgrade your rig, and shape the future of ArcLight.",
    releaseDate: "2026-03-12",
    rating: 4.8,
    reviewCount: 3184,
    popularityScore: 98,
    ageRating: "16+",
    requirements: {
      minimum: { os: "Windows 10", processor: "Intel i5-8400", memoryGb: 8, gpu: "GTX 1060", storageGb: 80 },
      recommended: { os: "Windows 11", processor: "Ryzen 7 5800X", memoryGb: 16, gpu: "RTX 3070", storageGb: 80 }
    },
    downloadSizeGb: 76,
    featured: true,
    active: true
  },
  {
    id: "game-astral-forge",
    slug: "astral-forge",
    title: "Astral Forge",
    publisher: "Moonlit Works",
    developer: "Moonlit Works",
    genre: "Strategy",
    tags: ["Base Building", "Co-op", "Sci-Fi", "Tactical"],
    platforms: ["Windows", "macOS", "Linux"],
    price: 39.99,
    discountPercent: 0,
    heroImage: "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?auto=format&fit=crop&w=1200&q=80",
    trailerUrl: "https://example.com/trailers/astral-forge",
    description: "Command orbital foundries and defend fragile colonies across procedurally generated systems.",
    longDescription:
      "Astral Forge is a deep strategy sandbox where supply lines, diplomacy, and tactical fleet battles decide whether humanity survives beyond Earth.",
    releaseDate: "2025-11-01",
    rating: 4.6,
    reviewCount: 1410,
    popularityScore: 89,
    ageRating: "12+",
    requirements: {
      minimum: { os: "Windows 10", processor: "Intel i3-8100", memoryGb: 8, gpu: "GTX 970", storageGb: 45 },
      recommended: { os: "Windows 11", processor: "Intel i7-10700", memoryGb: 16, gpu: "RTX 2060", storageGb: 45 }
    },
    downloadSizeGb: 42,
    featured: true,
    active: true
  },
  {
    id: "game-mythfall-legends",
    slug: "mythfall-legends",
    title: "Mythfall Legends",
    publisher: "Amber Crown",
    developer: "Oak & Ember",
    genre: "Adventure",
    tags: ["Fantasy", "Puzzle", "Single Player", "Exploration"],
    platforms: ["Windows", "macOS"],
    price: 29.99,
    discountPercent: 25,
    heroImage: "https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=1200&q=80",
    trailerUrl: "https://example.com/trailers/mythfall-legends",
    description: "Uncover the fate of a vanished kingdom through environmental puzzles and ancient magic.",
    longDescription:
      "Mythfall Legends is a cinematic adventure filled with handcrafted ruins, companion-driven storytelling, and secrets that reward careful exploration.",
    releaseDate: "2024-09-22",
    rating: 4.5,
    reviewCount: 2240,
    popularityScore: 83,
    ageRating: "10+",
    requirements: {
      minimum: { os: "Windows 10", processor: "Intel i5-6500", memoryGb: 8, gpu: "GTX 1050", storageGb: 32 },
      recommended: { os: "Windows 11", processor: "Ryzen 5 5600", memoryGb: 16, gpu: "RTX 2060", storageGb: 32 }
    },
    downloadSizeGb: 29,
    featured: false,
    active: true
  },
  {
    id: "game-velocity-rift",
    slug: "velocity-rift",
    title: "Velocity Rift",
    publisher: "Apex Pixel",
    developer: "Apex Pixel",
    genre: "Racing",
    tags: ["Arcade", "Multiplayer", "Esports", "Fast-Paced"],
    platforms: ["Windows"],
    price: 24.99,
    discountPercent: 10,
    heroImage: "https://images.unsplash.com/photo-1511882150382-421056c89033?auto=format&fit=crop&w=1200&q=80",
    trailerUrl: "https://example.com/trailers/velocity-rift",
    description: "Anti-gravity racing with seasonal leagues, ship tuning, and split-second boost drafting.",
    longDescription:
      "Velocity Rift delivers precision racing across impossible circuits, with ghost challenges, live tournaments, and a garage full of performance builds.",
    releaseDate: "2025-06-18",
    rating: 4.4,
    reviewCount: 972,
    popularityScore: 79,
    ageRating: "7+",
    requirements: {
      minimum: { os: "Windows 10", processor: "Intel i5-7500", memoryGb: 8, gpu: "GTX 1050 Ti", storageGb: 25 },
      recommended: { os: "Windows 11", processor: "Intel i5-11600K", memoryGb: 16, gpu: "RTX 3060", storageGb: 25 }
    },
    downloadSizeGb: 22,
    featured: false,
    active: true
  },
  {
    id: "game-cozy-constellations",
    slug: "cozy-constellations",
    title: "Cozy Constellations",
    publisher: "Soft Lantern",
    developer: "Soft Lantern",
    genre: "Simulation",
    tags: ["Relaxing", "Crafting", "Management", "Family Friendly"],
    platforms: ["Windows", "macOS", "Linux"],
    price: 19.99,
    discountPercent: 0,
    heroImage: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?auto=format&fit=crop&w=1200&q=80",
    trailerUrl: "https://example.com/trailers/cozy-constellations",
    description: "Restore tiny planets, befriend star spirits, and design tranquil cosmic gardens.",
    longDescription:
      "Cozy Constellations is a gentle management sim about rebuilding homes across the stars. There are no fail states, only satisfying progress and charming discoveries.",
    releaseDate: "2026-01-30",
    rating: 4.9,
    reviewCount: 612,
    popularityScore: 86,
    ageRating: "Everyone",
    requirements: {
      minimum: { os: "Windows 10", processor: "Intel i3-6100", memoryGb: 4, gpu: "Intel UHD 630", storageGb: 12 },
      recommended: { os: "Windows 11", processor: "Intel i5-9400", memoryGb: 8, gpu: "GTX 1050", storageGb: 12 }
    },
    downloadSizeGb: 10,
    featured: true,
    active: true
  }
];

export async function buildSeedData(): Promise<{
  users: User[];
  carts: Cart[];
  reviews: Review[];
  purchases: Purchase[];
}> {
  const [customerHash, adminHash] = await Promise.all([
    bcrypt.hash("PlayerPass123", 10),
    bcrypt.hash("AdminPass123", 10)
  ]);

  const users: User[] = [
    {
      id: "user-demo-player",
      name: "Aarav Gamer",
      email: "player@playverse.test",
      passwordHash: customerHash,
      role: "customer",
      avatar: "AG",
      favoriteGenres: ["Action RPG", "Strategy"],
      ownedGameIds: ["game-mythfall-legends"],
      wishlistGameIds: ["game-neon-odyssey", "game-astral-forge"],
      createdAt: now
    },
    {
      id: "user-demo-admin",
      name: "PlayVerse Admin",
      email: "admin@playverse.test",
      passwordHash: adminHash,
      role: "admin",
      avatar: "PA",
      favoriteGenres: ["Simulation"],
      ownedGameIds: [],
      wishlistGameIds: [],
      createdAt: now
    }
  ];

  const reviews: Review[] = [
    {
      id: "review-mythfall-1",
      userId: "user-demo-player",
      gameId: "game-mythfall-legends",
      rating: 5,
      headline: "Beautiful world and clever puzzles",
      body: "The exploration loop feels polished and the story rewards patience. Great fit for a relaxed weekend.",
      createdAt: now
    }
  ];

  return {
    users,
    carts: [{ userId: "user-demo-player", items: [], updatedAt: now }],
    reviews,
    purchases: []
  };
}
