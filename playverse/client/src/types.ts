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
  finalPrice?: number;
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

export interface User {
  id: string;
  name: string;
  email: string;
  role: "customer" | "admin";
  avatar: string;
  favoriteGenres: string[];
  ownedGameIds: string[];
  wishlistGameIds: string[];
}

export interface CartItemView {
  game: Game;
  finalPrice: number;
}

export interface CartView {
  items: CartItemView[];
  subtotal: number;
  discount: number;
  total: number;
}

export interface Purchase {
  id: string;
  gameIds: string[];
  total: number;
  status: "paid" | "refunded";
  licenseKeys: Record<string, string>;
  downloadLinks: Record<string, string>;
  createdAt: string;
}
