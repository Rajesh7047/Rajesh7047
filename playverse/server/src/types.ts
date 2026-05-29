export type UserRole = "customer" | "admin";

export interface User {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  role: UserRole;
  avatar: string;
  favoriteGenres: string[];
  ownedGameIds: string[];
  wishlistGameIds: string[];
  createdAt: string;
}

export interface SystemRequirements {
  os: string;
  processor: string;
  memoryGb: number;
  gpu: string;
  storageGb: number;
}

export interface Game {
  id: string;
  slug: string;
  title: string;
  publisher: string;
  developer: string;
  genre: string;
  tags: string[];
  platforms: string[];
  price: number;
  discountPercent: number;
  heroImage: string;
  trailerUrl: string;
  description: string;
  longDescription: string;
  releaseDate: string;
  rating: number;
  reviewCount: number;
  popularityScore: number;
  ageRating: string;
  requirements: {
    minimum: SystemRequirements;
    recommended: SystemRequirements;
  };
  downloadSizeGb: number;
  featured: boolean;
  active: boolean;
}

export interface CartItem {
  gameId: string;
  addedAt: string;
}

export interface Cart {
  userId: string;
  items: CartItem[];
  updatedAt: string;
}

export interface Review {
  id: string;
  userId: string;
  gameId: string;
  rating: number;
  headline: string;
  body: string;
  createdAt: string;
}

export interface Purchase {
  id: string;
  userId: string;
  gameIds: string[];
  subtotal: number;
  discount: number;
  tax: number;
  total: number;
  paymentProvider: "card" | "paypal" | "stripe";
  status: "paid" | "refunded";
  licenseKeys: Record<string, string>;
  downloadLinks: Record<string, string>;
  createdAt: string;
}

export interface CompatibilityReport {
  gameId: string;
  compatible: boolean;
  warnings: string[];
}
