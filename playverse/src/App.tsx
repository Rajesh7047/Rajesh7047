import type { FormEvent } from 'react'
import { useCallback, useEffect, useMemo, useState } from 'react'
import {
  BadgeCheck,
  CreditCard,
  Download,
  Gamepad2,
  Heart,
  MonitorSmartphone,
  Search,
  ShieldCheck,
  Sparkles,
  Star,
  TrendingUp,
  Users,
  Zap,
} from 'lucide-react'
import {
  Link,
  NavLink,
  Route,
  Routes,
  useNavigate,
  useParams,
} from 'react-router-dom'

type PaymentMethod = 'Card' | 'PayPal' | 'Wallet'

type Game = {
  id: string
  slug: string
  title: string
  studio: string
  genre: string
  shortDescription: string
  description: string
  price: number
  salePrice?: number
  rating: number
  reviewCount: number
  players: string
  featured: boolean
  releaseWindow: string
  banner: string
  tags: string[]
  platforms: string[]
  highlights: string[]
  accent: [string, string]
  system: {
    os: string
    ram: number
    storage: number
    cpuTier: number
    gpuTier: number
    cpuLabel: string
    gpuLabel: string
  }
}

type Review = {
  id: string
  gameId: string
  author: string
  rating: number
  headline: string
  body: string
  createdAt: string
}

type Order = {
  id: string
  gameIds: string[]
  total: number
  createdAt: string
  paymentMethod: PaymentMethod
}

type UserProfile = {
  name: string
  email: string
  plan: string
  tagline: string
}

type HardwareProfile = {
  os: string
  ram: number
  storage: number
  cpuTier: number
  gpuTier: number
}

type InstallerJob = {
  gameId: string
  progress: number
  status: string
}

type StoreApi = {
  games: Game[]
  featuredGames: Game[]
  recommendedGames: Game[]
  wishlist: string[]
  cartItems: Game[]
  libraryItems: Game[]
  orders: Order[]
  reviews: Review[]
  session: UserProfile | null
  hardware: HardwareProfile
  paymentMethod: PaymentMethod
  setPaymentMethod: (method: PaymentMethod) => void
  setHardware: (profile: HardwareProfile) => void
  updateSession: (profile: UserProfile | null) => void
  toggleWishlist: (gameId: string) => void
  addToCart: (gameId: string) => void
  removeFromCart: (gameId: string) => void
  completeCheckout: () => void
  publishGame: (draft: AdminDraft) => void
  submitReview: (gameId: string, rating: number, headline: string, body: string) => void
  launchInstaller: (gameId: string) => void
  installerJob: InstallerJob | null
}

type AdminDraft = {
  title: string
  studio: string
  genre: string
  price: number
  tagLine: string
}

const defaultSession: UserProfile = {
  name: 'Nova Singh',
  email: 'nova@playverse.gg',
  plan: 'Pro',
  tagline: 'Competitive co-op collector and strategy fan',
}

const defaultHardware: HardwareProfile = {
  os: 'Windows 11',
  ram: 16,
  storage: 320,
  cpuTier: 8,
  gpuTier: 8,
}

const seedGames: Game[] = [
  {
    id: 'eclipse-protocol',
    slug: 'eclipse-protocol',
    title: 'Eclipse Protocol',
    studio: 'Aster Forge',
    genre: 'Action RPG',
    shortDescription: 'Tactical combat, neon cities, and live squad decisions in a kinetic cyberpunk world.',
    description:
      'Lead an elite response unit through sprawling megacities where every mission changes faction control, unlocks new augment paths, and shapes the black-market economy.',
    price: 59,
    salePrice: 44,
    rating: 4.8,
    reviewCount: 1284,
    players: '1-4 players',
    featured: true,
    releaseWindow: 'Live now',
    banner: 'Best seller',
    tags: ['story-rich', 'co-op', 'cyberpunk', 'loot'],
    platforms: ['Windows', 'Steam Deck'],
    highlights: ['Branching squad choices', 'Cross-save cloud sync', 'Adaptive haptic profiles'],
    accent: ['#7c3aed', '#22d3ee'],
    system: {
      os: 'Windows 10+',
      ram: 12,
      storage: 90,
      cpuTier: 6,
      gpuTier: 6,
      cpuLabel: 'Ryzen 5 / i5',
      gpuLabel: 'RTX 2060 / RX 6600',
    },
  },
  {
    id: 'orbital-drift',
    slug: 'orbital-drift',
    title: 'Orbital Drift',
    studio: 'Signal Harbor',
    genre: 'Racing',
    shortDescription: 'Anti-gravity circuits, live tournaments, and precision drifting above ruined moons.',
    description:
      'Build your pilot profile, tune hovercraft loadouts, and dominate ranked circuits designed around split-second boosts and gravity slingshots.',
    price: 39,
    salePrice: 29,
    rating: 4.6,
    reviewCount: 864,
    players: 'Online multiplayer',
    featured: true,
    releaseWindow: 'Season 4',
    banner: 'Tournament drop',
    tags: ['competitive', 'racing', 'esports', 'fast'],
    platforms: ['Windows'],
    highlights: ['Live leaderboard ladders', 'Ghost replay coaching', 'Seasonal cosmetics'],
    accent: ['#f97316', '#facc15'],
    system: {
      os: 'Windows 10+',
      ram: 8,
      storage: 48,
      cpuTier: 5,
      gpuTier: 5,
      cpuLabel: 'Ryzen 3 / i3',
      gpuLabel: 'GTX 1660 / RX 580',
    },
  },
  {
    id: 'verdant-keepers',
    slug: 'verdant-keepers',
    title: 'Verdant Keepers',
    studio: 'Moss Lantern',
    genre: 'Simulation',
    shortDescription: 'Grow a floating ecosystem, restore weather patterns, and co-create serene biomes.',
    description:
      'Balance ecology, trade routes, and cozy city-building systems as you restore life to drifting islands after a planetary collapse.',
    price: 34,
    rating: 4.7,
    reviewCount: 611,
    players: 'Solo / co-op',
    featured: false,
    releaseWindow: 'Freshly updated',
    banner: 'Cozy hit',
    tags: ['simulation', 'cozy', 'builder', 'strategy'],
    platforms: ['Windows', 'macOS'],
    highlights: ['Detailed ecology systems', 'Relaxed automation loops', 'Shared co-op farms'],
    accent: ['#10b981', '#84cc16'],
    system: {
      os: 'Windows 10+',
      ram: 8,
      storage: 30,
      cpuTier: 4,
      gpuTier: 4,
      cpuLabel: 'Ryzen 3 / i3',
      gpuLabel: 'GTX 1060 / RX 570',
    },
  },
  {
    id: 'chrono-shift',
    slug: 'chrono-shift',
    title: 'Chrono Shift',
    studio: 'Iris Core',
    genre: 'Adventure',
    shortDescription: 'Solve layered time fractures with cinematic puzzles and bold art direction.',
    description:
      'Manipulate parallel timelines to rescue a collapsing archive city, combining exploration, stealth, and timeline rewriting puzzles.',
    price: 49,
    salePrice: 35,
    rating: 4.9,
    reviewCount: 1520,
    players: 'Single player',
    featured: true,
    releaseWindow: 'Critics choice',
    banner: 'Editors pick',
    tags: ['puzzle', 'story-rich', 'adventure', 'cinematic'],
    platforms: ['Windows', 'macOS'],
    highlights: ['Reactive soundtrack', 'Timeline rewind mechanics', 'Photo mode'],
    accent: ['#2563eb', '#a855f7'],
    system: {
      os: 'Windows 10+',
      ram: 10,
      storage: 62,
      cpuTier: 5,
      gpuTier: 5,
      cpuLabel: 'Ryzen 5 / i5',
      gpuLabel: 'RTX 3050 / RX 6600M',
    },
  },
  {
    id: 'citadel-zero',
    slug: 'citadel-zero',
    title: 'Citadel Zero',
    studio: 'Null Atlas',
    genre: 'Strategy',
    shortDescription: 'A grand strategy sandbox where diplomacy, sabotage, and orbital defense collide.',
    description:
      'Manage an interstellar alliance, negotiate unstable peace treaties, and command fleet logistics in a living galaxy simulation.',
    price: 52,
    rating: 4.5,
    reviewCount: 742,
    players: 'Solo / async multiplayer',
    featured: false,
    releaseWindow: 'New campaign',
    banner: 'Deep strategy',
    tags: ['strategy', '4x', 'simulation', 'mod support'],
    platforms: ['Windows', 'Linux'],
    highlights: ['Massive galaxy map', 'Faction diplomacy engine', 'Mod-friendly setup'],
    accent: ['#0f172a', '#38bdf8'],
    system: {
      os: 'Windows 10+',
      ram: 16,
      storage: 70,
      cpuTier: 7,
      gpuTier: 4,
      cpuLabel: 'Ryzen 7 / i7',
      gpuLabel: 'GTX 1660 / RX 590',
    },
  },
  {
    id: 'mythic-allies',
    slug: 'mythic-allies',
    title: 'Mythic Allies',
    studio: 'Northglass',
    genre: 'RPG',
    shortDescription: 'Form elemental parties, tackle raids, and unlock synergy-based combat trees.',
    description:
      'Recruit mythical companions, craft raid-ready builds, and complete weekly world events designed around coordinated elemental combos.',
    price: 55,
    salePrice: 41,
    rating: 4.4,
    reviewCount: 988,
    players: '1-5 players',
    featured: false,
    releaseWindow: 'Raid season',
    banner: 'Guild favorite',
    tags: ['rpg', 'co-op', 'raids', 'buildcraft'],
    platforms: ['Windows'],
    highlights: ['Shared raid finder', 'Guild progression', 'Element combo system'],
    accent: ['#ec4899', '#8b5cf6'],
    system: {
      os: 'Windows 10+',
      ram: 12,
      storage: 78,
      cpuTier: 6,
      gpuTier: 6,
      cpuLabel: 'Ryzen 5 / i5',
      gpuLabel: 'RTX 2060 / RX 6600',
    },
  },
  {
    id: 'signal-hunters',
    slug: 'signal-hunters',
    title: 'Signal Hunters',
    studio: 'Quiet Phase',
    genre: 'Shooter',
    shortDescription: 'Squad extraction missions with stealth routing, contracts, and high-stakes loot.',
    description:
      'Deploy into dynamic exclusion zones where changing weather, faction patrols, and intel contracts determine how you escape with your haul.',
    price: 42,
    rating: 4.3,
    reviewCount: 431,
    players: '3-player squads',
    featured: false,
    releaseWindow: 'Night ops update',
    banner: 'Extraction mode',
    tags: ['shooter', 'co-op', 'tactical', 'loot'],
    platforms: ['Windows'],
    highlights: ['Contract-based missions', 'Dynamic threat levels', 'Voice squad commands'],
    accent: ['#ef4444', '#f97316'],
    system: {
      os: 'Windows 10+',
      ram: 16,
      storage: 85,
      cpuTier: 7,
      gpuTier: 7,
      cpuLabel: 'Ryzen 7 / i7',
      gpuLabel: 'RTX 3070 / RX 6700 XT',
    },
  },
  {
    id: 'echoes-of-atlas',
    slug: 'echoes-of-atlas',
    title: 'Echoes of Atlas',
    studio: 'Tidal Circuit',
    genre: 'Open World',
    shortDescription: 'Traverse fractured continents with co-op expeditions, airships, and relic hunting.',
    description:
      'Map forgotten ruins, customize your expedition ship, and uncover ancient engines that reshape traversal across a massive seamless world.',
    price: 64,
    salePrice: 52,
    rating: 4.7,
    reviewCount: 1207,
    players: 'Single player / co-op',
    featured: true,
    releaseWindow: 'Expansion ready',
    banner: 'Premium launch',
    tags: ['open-world', 'adventure', 'co-op', 'exploration'],
    platforms: ['Windows', 'Steam Deck'],
    highlights: ['Airship base building', 'Shared expeditions', 'World events'],
    accent: ['#14b8a6', '#2563eb'],
    system: {
      os: 'Windows 10+',
      ram: 16,
      storage: 110,
      cpuTier: 7,
      gpuTier: 7,
      cpuLabel: 'Ryzen 7 / i7',
      gpuLabel: 'RTX 3070 / RX 6800',
    },
  },
]

const seedReviews: Review[] = [
  {
    id: 'review-1',
    gameId: 'eclipse-protocol',
    author: 'Harper',
    rating: 5,
    headline: 'The slickest squad combat loop this year',
    body: 'Mission pacing is excellent and the squad decisions actually matter. The progression systems feel premium.',
    createdAt: '2026-05-08',
  },
  {
    id: 'review-2',
    gameId: 'chrono-shift',
    author: 'Jules',
    rating: 5,
    headline: 'Puzzle design that keeps surprising you',
    body: 'Every chapter introduces a new timeline rule without overwhelming the player. Visual storytelling is top tier.',
    createdAt: '2026-05-12',
  },
  {
    id: 'review-3',
    gameId: 'verdant-keepers',
    author: 'Mira',
    rating: 4,
    headline: 'Cozy, strategic, and easy to settle into',
    body: 'The ecosystem simulation is deeper than it first appears. Great soundtrack and satisfying automation tools.',
    createdAt: '2026-05-15',
  },
]

function usePersistentState<T>(key: string, fallback: T) {
  const [value, setValue] = useState<T>(() => {
    const storedValue = window.localStorage.getItem(key)
    if (!storedValue) {
      return fallback
    }

    try {
      return JSON.parse(storedValue) as T
    } catch {
      return fallback
    }
  })

  useEffect(() => {
    window.localStorage.setItem(key, JSON.stringify(value))
  }, [key, value])

  return [value, setValue] as const
}

function formatCurrency(amount: number) {
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
    maximumFractionDigits: 0,
  }).format(amount)
}

function toSlug(value: string) {
  return value
    .toLowerCase()
    .trim()
    .replace(/[^a-z0-9]+/g, '-')
    .replace(/^-+|-+$/g, '')
}

function App() {
  const navigate = useNavigate()
  const [games, setGames] = usePersistentState<Game[]>('playverse.games', seedGames)
  const [wishlist, setWishlist] = usePersistentState<string[]>('playverse.wishlist', [
    'orbital-drift',
    'echoes-of-atlas',
  ])
  const [cart, setCart] = usePersistentState<string[]>('playverse.cart', ['mythic-allies'])
  const [library, setLibrary] = usePersistentState<string[]>('playverse.library', [
    'eclipse-protocol',
    'chrono-shift',
  ])
  const [orders, setOrders] = usePersistentState<Order[]>('playverse.orders', [
    {
      id: 'order-1001',
      gameIds: ['eclipse-protocol', 'chrono-shift'],
      total: 79,
      createdAt: '2026-05-14',
      paymentMethod: 'Card',
    },
  ])
  const [reviews, setReviews] = usePersistentState<Review[]>('playverse.reviews', seedReviews)
  const [session, setSession] = usePersistentState<UserProfile | null>(
    'playverse.session',
    defaultSession,
  )
  const [paymentMethod, setPaymentMethod] = usePersistentState<PaymentMethod>(
    'playverse.payment',
    'Card',
  )
  const [hardware, setHardware] = usePersistentState<HardwareProfile>(
    'playverse.hardware',
    defaultHardware,
  )
  const [catalogQuery, setCatalogQuery] = useState('')
  const [catalogGenre, setCatalogGenre] = useState('All')
  const [catalogSort, setCatalogSort] = useState('featured')
  const [notice, setNotice] = useState('')
  const [installerJob, setInstallerJob] = useState<InstallerJob | null>(null)

  const resolveGames = useCallback(
    (ids: string[]) =>
      ids.map((id) => games.find((game) => game.id === id)).filter(Boolean) as Game[],
    [games],
  )

  const cartItems = resolveGames(cart)
  const libraryItems = resolveGames(library)

  const featuredGames = useMemo(
    () => games.filter((game) => game.featured).slice(0, 4),
    [games],
  )

  const recommendedGames = useMemo(() => {
    const affinity = new Set(
      [...libraryItems, ...resolveGames(wishlist)].flatMap((game) => [
        game.genre,
        ...game.tags,
      ]),
    )

    return games
      .filter((game) => !library.includes(game.id))
      .map((game) => {
        const score = [
          game.genre,
          ...game.tags,
          ...(wishlist.includes(game.id) ? ['wishlisted'] : []),
        ].reduce((total, item) => total + (affinity.has(item) ? 1 : 0), game.rating)
        return { game, score }
      })
      .sort((left, right) => right.score - left.score)
      .slice(0, 3)
      .map((entry) => entry.game)
  }, [games, library, libraryItems, resolveGames, wishlist])

  const totalCart = cartItems.reduce(
    (sum, item) => sum + (item.salePrice ?? item.price),
    0,
  )
  const genres = ['All', ...new Set(games.map((game) => game.genre))]

  const filteredGames = useMemo(() => {
    const normalizedQuery = catalogQuery.trim().toLowerCase()

    const nextGames = games.filter((game) => {
      const matchesQuery =
        !normalizedQuery ||
        [game.title, game.studio, game.genre, ...game.tags].some((value) =>
          value.toLowerCase().includes(normalizedQuery),
        )
      const matchesGenre = catalogGenre === 'All' || game.genre === catalogGenre
      return matchesQuery && matchesGenre
    })

    return [...nextGames].sort((left, right) => {
      switch (catalogSort) {
        case 'rating':
          return right.rating - left.rating
        case 'price-low':
          return (left.salePrice ?? left.price) - (right.salePrice ?? right.price)
        case 'price-high':
          return (right.salePrice ?? right.price) - (left.salePrice ?? left.price)
        case 'reviews':
          return right.reviewCount - left.reviewCount
        default:
          return Number(right.featured) - Number(left.featured)
      }
    })
  }, [catalogGenre, catalogQuery, catalogSort, games])

  useEffect(() => {
    if (!notice) {
      return
    }

    const timeoutId = window.setTimeout(() => setNotice(''), 3400)
    return () => window.clearTimeout(timeoutId)
  }, [notice])

  useEffect(() => {
    if (!installerJob || installerJob.progress >= 100) {
      return
    }

    const timeoutId = window.setTimeout(() => {
      setInstallerJob((currentJob) => {
        if (!currentJob) {
          return null
        }

        const nextProgress = Math.min(currentJob.progress + 18, 100)
        const nextStatus =
          nextProgress >= 100
            ? 'Installation complete'
            : nextProgress > 70
              ? 'Verifying files'
              : nextProgress > 40
                ? 'Deploying runtime'
                : 'Preparing installer'

        return {
          ...currentJob,
          progress: nextProgress,
          status: nextStatus,
        }
      })
    }, 450)

    return () => window.clearTimeout(timeoutId)
  }, [installerJob])

  useEffect(() => {
    if (!installerJob || installerJob.progress < 100) {
      return
    }

    const game = games.find((entry) => entry.id === installerJob.gameId)
    const timeoutId = window.setTimeout(() => {
      setNotice(`${game?.title ?? 'Your game'} is installed and ready to launch.`)
      setInstallerJob(null)
    }, 900)

    return () => window.clearTimeout(timeoutId)
  }, [games, installerJob])

  const toggleWishlist = (gameId: string) => {
    setWishlist((current) =>
      current.includes(gameId)
        ? current.filter((id) => id !== gameId)
        : [...current, gameId],
    )
    setNotice(
      wishlist.includes(gameId)
        ? 'Removed from wishlist.'
        : 'Saved to wishlist.',
    )
  }

  const addToCart = (gameId: string) => {
    if (library.includes(gameId)) {
      setNotice('This title is already in your library.')
      return
    }

    if (cart.includes(gameId)) {
      navigate('/checkout')
      setNotice('That title is already in your bag.')
      return
    }

    setCart((current) => [...current, gameId])
    setNotice('Added to bag.')
  }

  const removeFromCart = (gameId: string) => {
    setCart((current) => current.filter((id) => id !== gameId))
  }

  const compareHardware = (game: Game) => {
    const blockers: string[] = []

    if (hardware.ram < game.system.ram) {
      blockers.push(`RAM ${hardware.ram} GB < required ${game.system.ram} GB`)
    }
    if (hardware.storage < game.system.storage) {
      blockers.push(
        `Storage ${hardware.storage} GB < required ${game.system.storage} GB`,
      )
    }
    if (hardware.cpuTier < game.system.cpuTier) {
      blockers.push('CPU tier below requirement')
    }
    if (hardware.gpuTier < game.system.gpuTier) {
      blockers.push('GPU tier below requirement')
    }
    if (!hardware.os.startsWith('Windows')) {
      blockers.push(`Windows installer required, detected ${hardware.os}`)
    }

    return {
      isCompatible: blockers.length === 0,
      blockers,
    }
  }

  const launchInstaller = (gameId: string) => {
    const game = games.find((entry) => entry.id === gameId)
    if (!game) {
      return
    }

    const verdict = compareHardware(game)
    if (!verdict.isCompatible) {
      setNotice(`Compatibility check failed: ${verdict.blockers.join(', ')}`)
      return
    }

    setInstallerJob({
      gameId,
      progress: 12,
      status: 'Analyzing device',
    })
    setNotice(`Installing ${game.title}...`)
  }

  const completeCheckout = () => {
    if (!cartItems.length) {
      setNotice('Your bag is empty.')
      return
    }

    if (!session) {
      navigate('/account')
      setNotice('Sign in to complete checkout.')
      return
    }

    const newlyOwned = cart.filter((id) => !library.includes(id))
    if (!newlyOwned.length) {
      setCart([])
      setNotice('Everything in the bag is already owned.')
      return
    }

    setLibrary((current) => [...new Set([...current, ...newlyOwned])])
    setOrders((current) => [
      {
        id: `order-${Date.now()}`,
        gameIds: newlyOwned,
        total: totalCart,
        createdAt: new Date().toISOString().slice(0, 10),
        paymentMethod,
      },
      ...current,
    ])
    setCart([])
    navigate('/library')
    setNotice(`Purchase confirmed via ${paymentMethod}. Licenses added to your library.`)
  }

  const submitReview = (
    gameId: string,
    rating: number,
    headline: string,
    body: string,
  ) => {
    if (!library.includes(gameId) || !session) {
      setNotice('You need to own the game before reviewing it.')
      return
    }

    setReviews((current) => [
      {
        id: crypto.randomUUID(),
        gameId,
        author: session.name,
        rating,
        headline,
        body,
        createdAt: new Date().toISOString().slice(0, 10),
      },
      ...current,
    ])
    setNotice('Review published.')
  }

  const publishGame = (draft: AdminDraft) => {
    const slug = toSlug(draft.title)
    if (!slug) {
      return
    }

    const gradients: Array<[string, string]> = [
      ['#8b5cf6', '#ec4899'],
      ['#0ea5e9', '#22c55e'],
      ['#f97316', '#ef4444'],
      ['#14b8a6', '#2563eb'],
    ]

    const game: Game = {
      id: slug,
      slug,
      title: draft.title,
      studio: draft.studio,
      genre: draft.genre,
      shortDescription: draft.tagLine,
      description: `${draft.tagLine} This release page was added from the admin console so the team can manage catalog expansion without touching code.`,
      price: draft.price,
      rating: 4.5,
      reviewCount: 0,
      players: 'Single player',
      featured: true,
      releaseWindow: 'Upcoming drop',
      banner: 'Admin spotlight',
      tags: ['new release', draft.genre.toLowerCase()],
      platforms: ['Windows'],
      highlights: ['Managed from admin panel', 'Ready for merchandising', 'System profile included'],
      accent: gradients[games.length % gradients.length],
      system: {
        os: 'Windows 10+',
        ram: 8,
        storage: 50,
        cpuTier: 5,
        gpuTier: 5,
        cpuLabel: 'Ryzen 3 / i3',
        gpuLabel: 'GTX 1660 / RX 580',
      },
    }

    setGames((current) => [game, ...current.filter((entry) => entry.slug !== slug)])
    setNotice(`${draft.title} published to the catalog.`)
  }

  const store: StoreApi = {
    games,
    featuredGames,
    recommendedGames,
    wishlist,
    cartItems,
    libraryItems,
    orders,
    reviews,
    session,
    hardware,
    paymentMethod,
    setPaymentMethod,
    setHardware,
    updateSession: setSession,
    toggleWishlist,
    addToCart,
    removeFromCart,
    completeCheckout,
    publishGame,
    submitReview,
    launchInstaller,
    installerJob,
  }

  return (
    <div className="shell">
      <header className="topbar">
        <Link className="brand" to="/">
          <div className="brand-mark">
            <Gamepad2 size={20} />
          </div>
          <div>
            <strong>PlayVerse</strong>
            <span>PC game marketplace</span>
          </div>
        </Link>

        <form
          className="search-shell"
          onSubmit={(event) => {
            event.preventDefault()
            navigate('/catalog')
          }}
        >
          <Search size={18} />
          <input
            aria-label="Search the catalog"
            value={catalogQuery}
            onChange={(event) => setCatalogQuery(event.target.value)}
            placeholder="Search games, genres, or studios"
          />
        </form>

        <nav className="nav-links">
          <NavLink to="/">Home</NavLink>
          <NavLink to="/catalog">Catalog</NavLink>
          <NavLink to="/library">Library</NavLink>
          <NavLink to="/admin">Admin</NavLink>
        </nav>

        <div className="topbar-actions">
          <Link className="pill-link" to="/account">
            {session?.name ?? 'Sign in'}
          </Link>
          <Link className="icon-pill" to="/account" aria-label="Wishlist">
            <Heart size={16} />
            <span>{wishlist.length}</span>
          </Link>
          <Link className="icon-pill" to="/checkout" aria-label="Cart">
            <CreditCard size={16} />
            <span>{cart.length}</span>
          </Link>
        </div>
      </header>

      {notice ? <div className="toast">{notice}</div> : null}

      {installerJob ? (
        <div className="installer-banner">
          <div>
            <strong>
              {games.find((game) => game.id === installerJob.gameId)?.title}
            </strong>
            <span>{installerJob.status}</span>
          </div>
          <div className="progress-track">
            <span style={{ width: `${installerJob.progress}%` }} />
          </div>
          <strong>{installerJob.progress}%</strong>
        </div>
      ) : null}

      <main className="page-shell">
        <Routes>
          <Route path="/" element={<HomePage store={store} />} />
          <Route
            path="/catalog"
            element={
              <CatalogPage
                store={store}
                query={catalogQuery}
                genre={catalogGenre}
                sort={catalogSort}
                genres={genres}
                setQuery={setCatalogQuery}
                setGenre={setCatalogGenre}
                setSort={setCatalogSort}
                filteredGames={filteredGames}
              />
            }
          />
          <Route path="/game/:slug" element={<GamePage store={store} />} />
          <Route path="/library" element={<LibraryPage store={store} />} />
          <Route path="/checkout" element={<CheckoutPage store={store} />} />
          <Route path="/account" element={<AccountPage store={store} />} />
          <Route path="/admin" element={<AdminPage store={store} />} />
        </Routes>
      </main>

      <footer className="footer">
        <div>
          <strong>Built from the PlayVerse project brief</strong>
          <p>
            Professional storefront UX, account flows, bag, recommendations,
            reviews, compatibility checks, and admin controls.
          </p>
        </div>
        <div className="footer-metrics">
          <span>{games.length} catalog titles</span>
          <span>{orders.length} recorded orders</span>
          <span>{reviews.length} community reviews</span>
        </div>
      </footer>
    </div>
  )
}

function HomePage({ store }: { store: StoreApi }) {
  const heroGame = store.featuredGames[0]
  const valueCards = [
    {
      icon: ShieldCheck,
      title: 'Secure checkout flows',
      description: 'Streamlined bag and payment steps designed to feel like a trusted launcher storefront.',
    },
    {
      icon: Download,
      title: 'Automated install readiness',
      description: 'Each owned title checks compatibility against saved hardware before installation begins.',
    },
    {
      icon: Sparkles,
      title: 'Personalized discovery',
      description: 'Recommendations prioritize genres and tags already present in your wishlist and library.',
    },
  ]

  return (
    <div className="page-grid">
      <section className="hero-card">
        <div className="hero-copy">
          <span className="eyebrow">Modern game storefront</span>
          <h1>Buy, organize, and install standout PC games from one polished hub.</h1>
          <p>
            PlayVerse reimagines the academic project as a premium marketplace
            with merchandising, community trust signals, seamless checkout, and
            install-first library workflows.
          </p>
          <div className="hero-actions">
            <Link className="primary-button" to="/catalog">
              Explore catalog
            </Link>
            <Link className="ghost-button" to={`/game/${heroGame.slug}`}>
              View featured release
            </Link>
          </div>
          <div className="hero-stats">
            <StatChip icon={TrendingUp} label="Store rating" value="4.8 / 5" />
            <StatChip icon={Users} label="Community" value="10k simulated users" />
            <StatChip icon={BadgeCheck} label="Admin ready" value="Live controls" />
          </div>
        </div>

        <article
          className="spotlight-card"
          style={{
            background: `linear-gradient(135deg, ${heroGame.accent[0]}, ${heroGame.accent[1]})`,
          }}
        >
          <span className="spotlight-badge">{heroGame.banner}</span>
          <h2>{heroGame.title}</h2>
          <p>{heroGame.shortDescription}</p>
          <div className="spotlight-meta">
            <span>{heroGame.genre}</span>
            <span>{heroGame.players}</span>
            <span>{heroGame.releaseWindow}</span>
          </div>
          <div className="spotlight-price">
            <strong>{formatCurrency(heroGame.salePrice ?? heroGame.price)}</strong>
            {heroGame.salePrice ? <span>{formatCurrency(heroGame.price)}</span> : null}
          </div>
        </article>
      </section>

      <section className="value-grid">
        {valueCards.map((card) => (
          <article className="glass-card" key={card.title}>
            <card.icon size={20} />
            <h3>{card.title}</h3>
            <p>{card.description}</p>
          </article>
        ))}
      </section>

      <section className="section-stack">
        <div className="section-heading">
          <div>
            <span className="eyebrow">Featured games</span>
            <h2>High-conversion merchandising tailored for a gaming audience</h2>
          </div>
          <Link className="text-link" to="/catalog">
            See full catalog
          </Link>
        </div>

        <div className="card-grid">
          {store.featuredGames.map((game) => (
            <GameCard key={game.id} game={game} store={store} />
          ))}
        </div>
      </section>

      <section className="section-stack">
        <div className="section-heading">
          <div>
            <span className="eyebrow">Recommendations</span>
            <h2>Smart suggestions from your activity, not generic filler</h2>
          </div>
        </div>
        <div className="card-grid">
          {store.recommendedGames.map((game) => (
            <GameCard key={game.id} game={game} store={store} compact />
          ))}
        </div>
      </section>

      <section className="community-grid">
        <article className="panel">
          <span className="eyebrow">Community and reviews</span>
          <h2>Peer validation gives every listing social proof.</h2>
          <p>
            The original brief emphasized ratings, reviews, and gamer
            interaction. This build keeps that intact with game-level reviews and
            player-centric merchandising.
          </p>
        </article>
        <article className="panel panel-dark">
          <span className="eyebrow">Install-first library</span>
          <h2>Purchased titles are launch-ready.</h2>
          <p>
            Hardware profiles, compatibility checks, and progress feedback make
            the post-purchase experience feel like a launcher instead of a simple
            receipt page.
          </p>
          <Link className="ghost-button light" to="/library">
            Open library
          </Link>
        </article>
      </section>
    </div>
  )
}

function CatalogPage({
  store,
  query,
  genre,
  sort,
  genres,
  setQuery,
  setGenre,
  setSort,
  filteredGames,
}: {
  store: StoreApi
  query: string
  genre: string
  sort: string
  genres: string[]
  setQuery: (value: string) => void
  setGenre: (value: string) => void
  setSort: (value: string) => void
  filteredGames: Game[]
}) {
  return (
    <div className="page-grid">
      <section className="panel">
        <span className="eyebrow">Browse games</span>
        <h1>Categories, search, and high-signal discovery</h1>
        <p>
          Search by title, genre, tags, or studio. The catalog is organized to
          mirror the browsing goals described in the project report.
        </p>
      </section>

      <section className="filters">
        <label>
          Search
          <input
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder="Try action RPG, Signal Harbor, or cyberpunk"
          />
        </label>

        <label>
          Genre
          <select value={genre} onChange={(event) => setGenre(event.target.value)}>
            {genres.map((entry) => (
              <option key={entry} value={entry}>
                {entry}
              </option>
            ))}
          </select>
        </label>

        <label>
          Sort
          <select value={sort} onChange={(event) => setSort(event.target.value)}>
            <option value="featured">Featured</option>
            <option value="rating">Top rated</option>
            <option value="reviews">Most reviewed</option>
            <option value="price-low">Price: low to high</option>
            <option value="price-high">Price: high to low</option>
          </select>
        </label>
      </section>

      <div className="catalog-count">
        Showing <strong>{filteredGames.length}</strong> titles
      </div>

      <div className="card-grid">
        {filteredGames.map((game) => (
          <GameCard key={game.id} game={game} store={store} />
        ))}
      </div>
    </div>
  )
}

function GamePage({ store }: { store: StoreApi }) {
  const { slug } = useParams()
  const game = store.games.find((entry) => entry.slug === slug)
  const [reviewRating, setReviewRating] = useState(5)
  const [headline, setHeadline] = useState('')
  const [body, setBody] = useState('')

  if (!game) {
    return (
      <section className="panel">
        <h1>Game not found</h1>
        <p>The requested release is not in the current catalog.</p>
      </section>
    )
  }

  const gameReviews = store.reviews.filter((review) => review.gameId === game.id)
  const ownsGame = store.libraryItems.some((entry) => entry.id === game.id)

  return (
    <div className="page-grid">
      <section
        className="detail-hero"
        style={{
          background: `radial-gradient(circle at top left, ${game.accent[0]}, transparent 40%), linear-gradient(135deg, rgba(12, 17, 29, 0.96), rgba(18, 24, 39, 0.94))`,
        }}
      >
        <div className="detail-copy">
          <span className="eyebrow">{game.banner}</span>
          <h1>{game.title}</h1>
          <p>{game.description}</p>
          <div className="meta-row">
            <span>{game.genre}</span>
            <span>{game.players}</span>
            <span>{game.platforms.join(' / ')}</span>
          </div>
          <div className="hero-actions">
            <button className="primary-button" onClick={() => store.addToCart(game.id)}>
              Add to bag - {formatCurrency(game.salePrice ?? game.price)}
            </button>
            <button
              className="ghost-button light"
              onClick={() => store.toggleWishlist(game.id)}
            >
              {store.wishlist.includes(game.id) ? 'Saved to wishlist' : 'Save to wishlist'}
            </button>
          </div>
        </div>
        <div className="detail-panel">
          <div className="metric-block">
            <Star size={18} />
            <strong>{game.rating}</strong>
            <span>{game.reviewCount} store reviews</span>
          </div>
          <div className="metric-block">
            <MonitorSmartphone size={18} />
            <strong>{game.system.ram} GB RAM</strong>
            <span>{game.system.storage} GB storage</span>
          </div>
          <div className="metric-block">
            <Zap size={18} />
            <strong>{game.releaseWindow}</strong>
            <span>{game.highlights[0]}</span>
          </div>
        </div>
      </section>

      <section className="two-column">
        <article className="panel">
          <h2>Why players buy it</h2>
          <ul className="feature-list">
            {game.highlights.map((item) => (
              <li key={item}>{item}</li>
            ))}
          </ul>
        </article>

        <article className="panel">
          <h2>System requirements</h2>
          <dl className="requirements-grid">
            <div>
              <dt>OS</dt>
              <dd>{game.system.os}</dd>
            </div>
            <div>
              <dt>RAM</dt>
              <dd>{game.system.ram} GB</dd>
            </div>
            <div>
              <dt>CPU</dt>
              <dd>{game.system.cpuLabel}</dd>
            </div>
            <div>
              <dt>GPU</dt>
              <dd>{game.system.gpuLabel}</dd>
            </div>
          </dl>
        </article>
      </section>

      <section className="panel">
        <div className="section-heading">
          <div>
            <span className="eyebrow">Player reviews</span>
            <h2>Community feedback and proof of quality</h2>
          </div>
        </div>
        <div className="review-grid">
          {gameReviews.length ? (
            gameReviews.map((review) => (
              <article className="review-card" key={review.id}>
                <div className="review-topline">
                  <strong>{review.headline}</strong>
                  <span>{Array.from({ length: review.rating }, () => '★').join('')}</span>
                </div>
                <p>{review.body}</p>
                <small>
                  {review.author} • {review.createdAt}
                </small>
              </article>
            ))
          ) : (
            <p>No reviews yet. Be the first to add one.</p>
          )}
        </div>
      </section>

      <section className="panel">
        <span className="eyebrow">Write a review</span>
        <h2>{ownsGame ? 'Share your experience' : 'Own the game to review it'}</h2>
        <form
          className="review-form"
          onSubmit={(event) => {
            event.preventDefault()
            store.submitReview(game.id, reviewRating, headline, body)
            setHeadline('')
            setBody('')
            setReviewRating(5)
          }}
        >
          <label>
            Rating
            <select
              value={reviewRating}
              onChange={(event) => setReviewRating(Number(event.target.value))}
              disabled={!ownsGame}
            >
              {[5, 4, 3, 2, 1].map((value) => (
                <option key={value} value={value}>
                  {value}
                </option>
              ))}
            </select>
          </label>
          <label>
            Headline
            <input
              value={headline}
              onChange={(event) => setHeadline(event.target.value)}
              disabled={!ownsGame}
              placeholder="What stood out most?"
            />
          </label>
          <label>
            Review
            <textarea
              rows={4}
              value={body}
              onChange={(event) => setBody(event.target.value)}
              disabled={!ownsGame}
              placeholder="Explain why you would recommend this game."
            />
          </label>
          <button className="primary-button" type="submit" disabled={!ownsGame}>
            Publish review
          </button>
        </form>
      </section>
    </div>
  )
}

function LibraryPage({ store }: { store: StoreApi }) {
  const compatibilitySummary = store.libraryItems.map((game) => ({
    game,
    verdict:
      store.hardware.ram >= game.system.ram &&
      store.hardware.storage >= game.system.storage &&
      store.hardware.cpuTier >= game.system.cpuTier &&
      store.hardware.gpuTier >= game.system.gpuTier &&
      store.hardware.os.startsWith('Windows'),
  }))

  return (
    <div className="page-grid">
      <section className="section-heading">
        <div>
          <span className="eyebrow">My library</span>
          <h1>Owned games, license history, and installer readiness</h1>
        </div>
      </section>

      <section className="two-column">
        <article className="panel">
          <h2>Hardware profile</h2>
          <p className="subtle-copy">
            Saved device specs help the platform simulate compatibility checks
            before installation, matching the report&apos;s install-first workflow.
          </p>
          <div className="hardware-grid">
            <label>
              OS
              <select
                value={store.hardware.os}
                onChange={(event) =>
                  store.setHardware({ ...store.hardware, os: event.target.value })
                }
              >
                <option value="Windows 11">Windows 11</option>
                <option value="Windows 10">Windows 10</option>
                <option value="macOS Sonoma">macOS Sonoma</option>
              </select>
            </label>
            <label>
              RAM (GB)
              <input
                type="number"
                value={store.hardware.ram}
                onChange={(event) =>
                  store.setHardware({
                    ...store.hardware,
                    ram: Number(event.target.value) || 0,
                  })
                }
              />
            </label>
            <label>
              Storage free (GB)
              <input
                type="number"
                value={store.hardware.storage}
                onChange={(event) =>
                  store.setHardware({
                    ...store.hardware,
                    storage: Number(event.target.value) || 0,
                  })
                }
              />
            </label>
            <label>
              CPU tier (1-10)
              <input
                type="number"
                min="1"
                max="10"
                value={store.hardware.cpuTier}
                onChange={(event) =>
                  store.setHardware({
                    ...store.hardware,
                    cpuTier: Number(event.target.value) || 0,
                  })
                }
              />
            </label>
            <label>
              GPU tier (1-10)
              <input
                type="number"
                min="1"
                max="10"
                value={store.hardware.gpuTier}
                onChange={(event) =>
                  store.setHardware({
                    ...store.hardware,
                    gpuTier: Number(event.target.value) || 0,
                  })
                }
              />
            </label>
          </div>
        </article>

        <article className="panel">
          <h2>Install readiness</h2>
          <div className="status-stack">
            {compatibilitySummary.map(({ game, verdict }) => (
              <div className="status-row" key={game.id}>
                <span>{game.title}</span>
                <strong className={verdict ? 'status-ok' : 'status-warn'}>
                  {verdict ? 'Ready to install' : 'Upgrade needed'}
                </strong>
              </div>
            ))}
          </div>
        </article>
      </section>

      <div className="card-grid">
        {store.libraryItems.map((game) => (
          <article className="library-card" key={game.id}>
            <div
              className="library-cover"
              style={{
                background: `linear-gradient(135deg, ${game.accent[0]}, ${game.accent[1]})`,
              }}
            />
            <div className="library-copy">
              <h3>{game.title}</h3>
              <p>{game.shortDescription}</p>
              <div className="meta-row">
                <span>{game.genre}</span>
                <span>{game.system.storage} GB</span>
              </div>
            </div>
            <button className="primary-button" onClick={() => store.launchInstaller(game.id)}>
              Install now
            </button>
          </article>
        ))}
      </div>
    </div>
  )
}

function CheckoutPage({ store }: { store: StoreApi }) {
  return (
    <div className="page-grid">
      <section className="section-heading">
        <div>
          <span className="eyebrow">Checkout</span>
          <h1>Bag, payment flow, and digital license fulfillment</h1>
        </div>
      </section>

      <section className="two-column">
        <article className="panel">
          <h2>Your bag</h2>
          <div className="status-stack">
            {store.cartItems.length ? (
              store.cartItems.map((game) => (
                <div className="cart-row" key={game.id}>
                  <div>
                    <strong>{game.title}</strong>
                    <p>{game.genre}</p>
                  </div>
                  <div className="cart-actions">
                    <strong>{formatCurrency(game.salePrice ?? game.price)}</strong>
                    <button onClick={() => store.removeFromCart(game.id)}>Remove</button>
                  </div>
                </div>
              ))
            ) : (
              <p>Your bag is empty. Add titles from the catalog to continue.</p>
            )}
          </div>
        </article>

        <article className="panel">
          <h2>Payment method</h2>
          <div className="payment-methods">
            {(['Card', 'PayPal', 'Wallet'] as PaymentMethod[]).map((method) => (
              <button
                key={method}
                className={method === store.paymentMethod ? 'payment-pill active' : 'payment-pill'}
                onClick={() => store.setPaymentMethod(method)}
              >
                {method}
              </button>
            ))}
          </div>
          <ul className="feature-list">
            <li>Encrypted transaction messaging</li>
            <li>Instant license delivery to your library</li>
            <li>Receipt and order history saved to your account</li>
          </ul>
          <div className="checkout-total">
            <span>Total</span>
            <strong>
              {formatCurrency(
                store.cartItems.reduce(
                  (sum, item) => sum + (item.salePrice ?? item.price),
                  0,
                ),
              )}
            </strong>
          </div>
          <button
            className="primary-button"
            onClick={() => store.completeCheckout()}
            disabled={!store.cartItems.length}
          >
            Complete purchase
          </button>
        </article>
      </section>
    </div>
  )
}

function AccountPage({ store }: { store: StoreApi }) {
  const [mode, setMode] = useState<'login' | 'register'>('login')
  const [draft, setDraft] = useState<UserProfile>(
    store.session ?? {
      name: '',
      email: '',
      plan: 'Explorer',
      tagline: '',
    },
  )

  const saveProfile = (event: FormEvent) => {
    event.preventDefault()
    store.updateSession(draft)
  }

  if (!store.session) {
    return (
      <section className="panel auth-panel">
        <span className="eyebrow">Account access</span>
        <h1>{mode === 'login' ? 'Sign in' : 'Create your account'}</h1>
        <form className="review-form" onSubmit={saveProfile}>
          <label>
            Name
            <input
              value={draft.name}
              onChange={(event) => setDraft({ ...draft, name: event.target.value })}
              required
            />
          </label>
          <label>
            Email
            <input
              type="email"
              value={draft.email}
              onChange={(event) => setDraft({ ...draft, email: event.target.value })}
              required
            />
          </label>
          <label>
            Tagline
            <input
              value={draft.tagline}
              onChange={(event) => setDraft({ ...draft, tagline: event.target.value })}
            />
          </label>
          <button className="primary-button" type="submit">
            {mode === 'login' ? 'Enter PlayVerse' : 'Create profile'}
          </button>
        </form>
        <button className="ghost-button" onClick={() => setMode(mode === 'login' ? 'register' : 'login')}>
          Switch to {mode === 'login' ? 'register' : 'login'}
        </button>
      </section>
    )
  }

  return (
    <div className="page-grid">
      <section className="two-column">
        <article className="panel">
          <span className="eyebrow">Your profile</span>
          <h1>{store.session.name}</h1>
          <p>{store.session.tagline}</p>
          <div className="hero-stats">
            <StatChip icon={Users} label="Membership" value={store.session.plan} />
            <StatChip icon={Heart} label="Wishlist" value={`${store.wishlist.length} titles`} />
            <StatChip icon={CreditCard} label="Orders" value={`${store.orders.length}`} />
          </div>
        </article>

        <article className="panel">
          <h2>Update account</h2>
          <form className="review-form" onSubmit={saveProfile}>
            <label>
              Name
              <input
                value={draft.name}
                onChange={(event) => setDraft({ ...draft, name: event.target.value })}
              />
            </label>
            <label>
              Email
              <input
                type="email"
                value={draft.email}
                onChange={(event) => setDraft({ ...draft, email: event.target.value })}
              />
            </label>
            <label>
              Plan
              <select
                value={draft.plan}
                onChange={(event) => setDraft({ ...draft, plan: event.target.value })}
              >
                <option value="Explorer">Explorer</option>
                <option value="Pro">Pro</option>
                <option value="Creator">Creator</option>
              </select>
            </label>
            <label>
              Tagline
              <input
                value={draft.tagline}
                onChange={(event) => setDraft({ ...draft, tagline: event.target.value })}
              />
            </label>
            <button className="primary-button" type="submit">
              Save profile
            </button>
          </form>
          <button
            className="ghost-button"
            onClick={() => {
              store.updateSession(null)
              setDraft({
                name: '',
                email: '',
                plan: 'Explorer',
                tagline: '',
              })
            }}
          >
            Sign out
          </button>
        </article>
      </section>

      <section className="two-column">
        <article className="panel">
          <h2>Order history</h2>
          <div className="status-stack">
            {store.orders.map((order) => (
              <div className="status-row" key={order.id}>
                <span>
                  {order.id} • {order.createdAt}
                </span>
                <strong>
                  {order.paymentMethod} • {formatCurrency(order.total)}
                </strong>
              </div>
            ))}
          </div>
        </article>

        <article className="panel">
          <h2>Wishlist snapshot</h2>
          <div className="status-stack">
            {store.wishlist.length ? (
              store.wishlist
                .map((id) => store.games.find((game) => game.id === id))
                .filter(Boolean)
                .map((game) => (
                  <div className="status-row" key={game!.id}>
                    <span>{game!.title}</span>
                    <strong>{formatCurrency(game!.salePrice ?? game!.price)}</strong>
                  </div>
                ))
            ) : (
              <p>No saved titles yet.</p>
            )}
          </div>
        </article>
      </section>
    </div>
  )
}

function AdminPage({ store }: { store: StoreApi }) {
  const [draft, setDraft] = useState<AdminDraft>({
    title: '',
    studio: '',
    genre: 'Action RPG',
    price: 49,
    tagLine: '',
  })

  const grossRevenue = store.orders.reduce((sum, order) => sum + order.total, 0)

  return (
    <div className="page-grid">
      <section className="section-heading">
        <div>
          <span className="eyebrow">Admin dashboard</span>
          <h1>Manage listings, monitor sales, and publish new drops</h1>
        </div>
      </section>

      <section className="value-grid">
        <article className="glass-card">
          <TrendingUp size={20} />
          <h3>{formatCurrency(grossRevenue)}</h3>
          <p>Recorded storefront revenue</p>
        </article>
        <article className="glass-card">
          <Users size={20} />
          <h3>{store.orders.length}</h3>
          <p>Orders captured in the demo ledger</p>
        </article>
        <article className="glass-card">
          <Gamepad2 size={20} />
          <h3>{store.games.length}</h3>
          <p>Catalog titles ready for merchandising</p>
        </article>
      </section>

      <section className="two-column">
        <article className="panel">
          <h2>Add a new game</h2>
          <form
            className="review-form"
            onSubmit={(event) => {
              event.preventDefault()
              store.publishGame(draft)
              setDraft({
                title: '',
                studio: '',
                genre: 'Action RPG',
                price: 49,
                tagLine: '',
              })
            }}
          >
            <label>
              Title
              <input
                value={draft.title}
                onChange={(event) => setDraft({ ...draft, title: event.target.value })}
                required
              />
            </label>
            <label>
              Studio
              <input
                value={draft.studio}
                onChange={(event) => setDraft({ ...draft, studio: event.target.value })}
                required
              />
            </label>
            <label>
              Genre
              <input
                value={draft.genre}
                onChange={(event) => setDraft({ ...draft, genre: event.target.value })}
                required
              />
            </label>
            <label>
              Price
              <input
                type="number"
                min="1"
                value={draft.price}
                onChange={(event) =>
                  setDraft({ ...draft, price: Number(event.target.value) || 0 })
                }
                required
              />
            </label>
            <label>
              Merchandising line
              <textarea
                rows={3}
                value={draft.tagLine}
                onChange={(event) => setDraft({ ...draft, tagLine: event.target.value })}
                required
              />
            </label>
            <button className="primary-button" type="submit">
              Publish listing
            </button>
          </form>
        </article>

        <article className="panel">
          <h2>Latest catalog entries</h2>
          <div className="status-stack">
            {store.games.slice(0, 6).map((game) => (
              <div className="status-row" key={game.id}>
                <span>
                  {game.title} • {game.genre}
                </span>
                <strong>{game.featured ? 'Featured' : 'Catalog'}</strong>
              </div>
            ))}
          </div>
        </article>
      </section>
    </div>
  )
}

function GameCard({
  game,
  store,
  compact = false,
}: {
  game: Game
  store: StoreApi
  compact?: boolean
}) {
  const owned = store.libraryItems.some((entry) => entry.id === game.id)
  const saved = store.wishlist.includes(game.id)

  return (
    <article className={compact ? 'game-card compact' : 'game-card'}>
      <div
        className="cover"
        style={{
          background: `linear-gradient(135deg, ${game.accent[0]}, ${game.accent[1]})`,
        }}
      >
        <span>{game.banner}</span>
      </div>
      <div className="game-copy">
        <div className="game-topline">
          <div>
            <small>{game.genre}</small>
            <h3>{game.title}</h3>
          </div>
          <button
            className={saved ? 'icon-toggle active' : 'icon-toggle'}
            onClick={() => store.toggleWishlist(game.id)}
            aria-label="Toggle wishlist"
          >
            <Heart size={16} />
          </button>
        </div>
        <p>{game.shortDescription}</p>
        <div className="meta-row">
          <span>{game.players}</span>
          <span>{game.rating}★</span>
        </div>
        <div className="card-actions">
          <Link className="text-link" to={`/game/${game.slug}`}>
            Details
          </Link>
          {owned ? (
            <Link className="primary-button small" to="/library">
              In library
            </Link>
          ) : (
            <button className="primary-button small" onClick={() => store.addToCart(game.id)}>
              {formatCurrency(game.salePrice ?? game.price)}
            </button>
          )}
        </div>
      </div>
    </article>
  )
}

function StatChip({
  icon: Icon,
  label,
  value,
}: {
  icon: typeof TrendingUp
  label: string
  value: string
}) {
  return (
    <div className="stat-chip">
      <Icon size={16} />
      <div>
        <small>{label}</small>
        <strong>{value}</strong>
      </div>
    </div>
  )
}

export default App
