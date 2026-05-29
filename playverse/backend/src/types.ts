export type UserRole = "user" | "admin";

export interface User {
  id: string;
  name: string;
  email: string;
  passwordHash: string;
  role: UserRole;
  favoriteGenres: string[];
  createdAt: string;
}

export interface Review {
  id: string;
  userId: string;
  userName: string;
  rating: number;
  comment: string;
  createdAt: string;
}

export interface Game {
  id: string;
  slug: string;
  title: string;
  publisher: string;
  genre: string;
  description: string;
  price: number;
  discountPercent: number;
  tags: string[];
  minSystemRequirements: {
    os: string;
    cpu: string;
    ram: string;
    gpu: string;
    storage: string;
  };
  downloadUrl: string;
  heroImage: string;
  active: boolean;
  reviews: Review[];
}

export interface CartItem {
  gameId: string;
  quantity: number;
}

export interface Order {
  id: string;
  userId: string;
  gameIds: string[];
  amountPaid: number;
  paymentMethod: "card" | "paypal" | "upi";
  status: "paid";
  createdAt: string;
}

export interface LibraryItem {
  userId: string;
  gameId: string;
  orderId: string;
  addedAt: string;
}

export interface WishlistItem {
  userId: string;
  gameId: string;
  addedAt: string;
}

export interface StoreState {
  users: User[];
  games: Game[];
  carts: Record<string, CartItem[]>;
  orders: Order[];
  library: LibraryItem[];
  wishlists: WishlistItem[];
}

export interface AuthenticatedRequestContext {
  id: string;
  role: UserRole;
  email: string;
  name: string;
}
