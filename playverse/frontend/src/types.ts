export interface User {
  id: string;
  name: string;
  email: string;
  role: "user" | "admin";
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
  finalPrice: number;
  averageRating: number;
  totalReviews: number;
  tags: string[];
  heroImage: string;
  minSystemRequirements: {
    os: string;
    cpu: string;
    ram: string;
    gpu: string;
    storage: string;
  };
  reviews: Review[];
}

export interface CartResponse {
  items: Array<{
    game: Game;
    quantity: number;
    lineTotal: number;
  }>;
  total: number;
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
