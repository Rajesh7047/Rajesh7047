import { buildSeedStore } from "./seed.js";
import {
  CartItem,
  Game,
  LibraryItem,
  Order,
  Review,
  StoreState,
  User,
  WishlistItem
} from "../types.js";

let state: StoreState = buildSeedStore();

export const getState = (): StoreState => state;

export const resetState = (): void => {
  state = buildSeedStore();
};

export const createUser = (user: User): User => {
  state.users.push(user);
  return user;
};

export const updateUser = (user: User): User => {
  const index = state.users.findIndex((item) => item.id === user.id);
  if (index >= 0) {
    state.users[index] = user;
  }
  return user;
};

export const saveCart = (userId: string, cart: CartItem[]): CartItem[] => {
  state.carts[userId] = cart;
  return cart;
};

export const addOrder = (order: Order): Order => {
  state.orders.push(order);
  return order;
};

export const addLibraryItems = (items: LibraryItem[]): void => {
  state.library.push(...items);
};

export const saveWishlist = (
  userId: string,
  wishlistItems: WishlistItem[]
): WishlistItem[] => {
  state.wishlists = state.wishlists.filter((item) => item.userId !== userId);
  state.wishlists.push(...wishlistItems);
  return wishlistItems;
};

export const updateGame = (game: Game): Game => {
  const index = state.games.findIndex((item) => item.id === game.id);
  if (index >= 0) {
    state.games[index] = game;
  } else {
    state.games.push(game);
  }
  return game;
};

export const appendGameReview = (gameId: string, review: Review): Game | null => {
  const game = state.games.find((item) => item.id === gameId);
  if (!game) {
    return null;
  }

  game.reviews.push(review);
  return game;
};
