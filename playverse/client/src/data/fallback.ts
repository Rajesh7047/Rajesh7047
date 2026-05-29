import type { CartView, Game, Purchase, User } from "../types";

export const fallbackGames: Game[] = [
  {
    id: "game-neon-odyssey",
    slug: "neon-odyssey",
    title: "Neon Odyssey",
    publisher: "HelioForge",
    developer: "HelioForge",
    genre: "Action RPG",
    tags: ["Cyberpunk", "Open World", "Story Rich"],
    platforms: ["Windows", "Steam Deck"],
    price: 59.99,
    finalPrice: 50.99,
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
    tags: ["Base Building", "Co-op", "Sci-Fi"],
    platforms: ["Windows", "macOS", "Linux"],
    price: 39.99,
    finalPrice: 39.99,
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
    tags: ["Fantasy", "Puzzle", "Single Player"],
    platforms: ["Windows", "macOS"],
    price: 29.99,
    finalPrice: 22.49,
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
  }
];

export const fallbackUser: User = {
  id: "user-demo-player",
  name: "Aarav Gamer",
  email: "player@playverse.test",
  role: "customer",
  avatar: "AG",
  favoriteGenres: ["Action RPG", "Strategy"],
  ownedGameIds: ["game-mythfall-legends"],
  wishlistGameIds: ["game-neon-odyssey"]
};

export const emptyCart: CartView = {
  items: [],
  subtotal: 0,
  discount: 0,
  total: 0
};

export const fallbackPurchase: Purchase = {
  id: "order-demo",
  gameIds: ["game-mythfall-legends"],
  total: 22.49,
  status: "paid",
  licenseKeys: { "game-mythfall-legends": "PV-DEMO-2026" },
  downloadLinks: { "game-mythfall-legends": "/downloads/game-mythfall-legends/demo" },
  createdAt: new Date().toISOString()
};
