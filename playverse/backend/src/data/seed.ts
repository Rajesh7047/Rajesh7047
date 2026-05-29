import bcrypt from "bcryptjs";
import { StoreState } from "../types.js";

const now = new Date().toISOString();

export const buildSeedStore = (): StoreState => ({
  users: [
    {
      id: "u-admin",
      name: "PlayVerse Admin",
      email: "admin@playverse.dev",
      passwordHash: bcrypt.hashSync("Admin@123", 10),
      role: "admin",
      favoriteGenres: ["action", "rpg"],
      createdAt: now
    },
    {
      id: "u-demo",
      name: "Demo Gamer",
      email: "demo@playverse.dev",
      passwordHash: bcrypt.hashSync("Demo@1234", 10),
      role: "user",
      favoriteGenres: ["rpg", "adventure", "indie"],
      createdAt: now
    }
  ],
  games: [
    {
      id: "g-1",
      slug: "stellar-raiders",
      title: "Stellar Raiders",
      publisher: "Nebula Forge",
      genre: "action",
      description: "High-speed co-op shooter across contested galaxies.",
      price: 49.99,
      discountPercent: 15,
      tags: ["co-op", "multiplayer", "sci-fi"],
      minSystemRequirements: {
        os: "Windows 10",
        cpu: "Intel i5 10th Gen",
        ram: "16 GB",
        gpu: "NVIDIA GTX 1660",
        storage: "45 GB"
      },
      downloadUrl: "https://downloads.playverse.dev/stellar-raiders/setup.exe",
      heroImage:
        "https://images.unsplash.com/photo-1542751371-adc38448a05e?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: [
        {
          id: "r-1",
          userId: "u-demo",
          userName: "Demo Gamer",
          rating: 5,
          comment: "Excellent pacing and intense team combat.",
          createdAt: now
        }
      ]
    },
    {
      id: "g-2",
      slug: "mythbound-legends",
      title: "Mythbound Legends",
      publisher: "Rune Harbor",
      genre: "rpg",
      description: "Narrative-rich fantasy RPG with dynamic choices.",
      price: 59.99,
      discountPercent: 10,
      tags: ["single-player", "fantasy", "story-rich"],
      minSystemRequirements: {
        os: "Windows 11",
        cpu: "AMD Ryzen 5 3600",
        ram: "16 GB",
        gpu: "NVIDIA RTX 2060",
        storage: "70 GB"
      },
      downloadUrl:
        "https://downloads.playverse.dev/mythbound-legends/installer.exe",
      heroImage:
        "https://images.unsplash.com/photo-1511512578047-dfb367046420?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: []
    },
    {
      id: "g-3",
      slug: "city-sim-pro",
      title: "City Sim Pro",
      publisher: "Urban Pixel",
      genre: "simulation",
      description: "Design, budget, and scale your own smart city.",
      price: 39.99,
      discountPercent: 0,
      tags: ["strategy", "building", "management"],
      minSystemRequirements: {
        os: "Windows 10",
        cpu: "Intel i5 9th Gen",
        ram: "12 GB",
        gpu: "NVIDIA GTX 1060",
        storage: "35 GB"
      },
      downloadUrl: "https://downloads.playverse.dev/city-sim-pro/setup.exe",
      heroImage:
        "https://images.unsplash.com/photo-1477959858617-67f85cf4f1df?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: []
    },
    {
      id: "g-4",
      slug: "driftx-underground",
      title: "DriftX Underground",
      publisher: "Overdrive Studio",
      genre: "racing",
      description: "Street racing with deep tuning and weather physics.",
      price: 29.99,
      discountPercent: 20,
      tags: ["racing", "online", "competitive"],
      minSystemRequirements: {
        os: "Windows 10",
        cpu: "Intel i3 10th Gen",
        ram: "8 GB",
        gpu: "NVIDIA GTX 1050",
        storage: "25 GB"
      },
      downloadUrl:
        "https://downloads.playverse.dev/driftx-underground/setup.exe",
      heroImage:
        "https://images.unsplash.com/photo-1492144534655-ae79c964c9d7?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: []
    },
    {
      id: "g-5",
      slug: "chrono-odyssey",
      title: "Chrono Odyssey",
      publisher: "Epoch Labs",
      genre: "adventure",
      description: "Time-shifting puzzles and cinematic boss encounters.",
      price: 44.99,
      discountPercent: 5,
      tags: ["adventure", "single-player", "puzzle"],
      minSystemRequirements: {
        os: "Windows 10",
        cpu: "AMD Ryzen 5 2600",
        ram: "12 GB",
        gpu: "NVIDIA GTX 1660",
        storage: "38 GB"
      },
      downloadUrl:
        "https://downloads.playverse.dev/chrono-odyssey/installer.exe",
      heroImage:
        "https://images.unsplash.com/photo-1486572788966-cfd3df1f5b42?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: []
    },
    {
      id: "g-6",
      slug: "void-strategy",
      title: "Void Strategy",
      publisher: "Quantum Tactics",
      genre: "strategy",
      description: "Large-scale tactical combat in procedurally generated sectors.",
      price: 34.99,
      discountPercent: 0,
      tags: ["strategy", "turn-based", "space"],
      minSystemRequirements: {
        os: "Windows 10",
        cpu: "Intel i5 8th Gen",
        ram: "8 GB",
        gpu: "NVIDIA GTX 970",
        storage: "22 GB"
      },
      downloadUrl: "https://downloads.playverse.dev/void-strategy/setup.exe",
      heroImage:
        "https://images.unsplash.com/photo-1462331940025-496dfbfc7564?auto=format&fit=crop&w=1200&q=80",
      active: true,
      reviews: []
    }
  ],
  carts: {
    "u-demo": [{ gameId: "g-3", quantity: 1 }]
  },
  orders: [],
  library: [
    {
      userId: "u-demo",
      gameId: "g-1",
      orderId: "seed-order",
      addedAt: now
    }
  ],
  wishlists: [
    {
      userId: "u-demo",
      gameId: "g-2",
      addedAt: now
    }
  ]
});
