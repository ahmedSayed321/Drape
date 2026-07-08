# Drape — Design Document

## Overview

A native iOS e-commerce application built with SwiftUI that integrates with the Shopify Admin REST API. The app allows users to browse fashion products by brand and category, save favourites locally, manage a cart via Shopify Draft Orders, and complete purchases. Authentication is dual-layered: Firebase handles identity, while a matching Shopify customer account is looked up for order association.

---

## Tech Stack

| Concern | Technology |
|---|---|
| UI Framework | SwiftUI |
| State Management | `@Observable` + `ObservableObject` / `@Published` (mixed per feature) |
| Networking | URLSession (native — no third-party HTTP library) |
| Authentication | Firebase Auth + Shopify Customer API |
| Local Persistence | SwiftData (saved/favourite products) |
| Navigation | `AppRouter` — `@Observable` class injected via environment |
| Backend | Shopify Admin REST API 2024-01 |

---

## App Navigation Flow

```
Launch
  │
  └── SplashScreen (checks auth state)
        │
        ├── First launch → OnBoardingScreen
        │
        ├── Not logged in → SignInView / SignupView
        │
        └── Logged in → ContentView (TabView)
              ├── Home
              ├── Search
              ├── Cart
              ├── Favourites
              └── Account
```

Navigation is driven by `AppRouter`, an `@Observable` class injected into the SwiftUI environment at the root. Each screen calls `router.showHome()`, `router.showSignIn()`, etc. to transition — no `NavigationStack` push at the root level.

---

## Screens

### Splash
- Entry point on every launch.
- Checks auth state (Firebase + stored customer ID) and routes to Onboarding, SignIn, or Home.

### Onboarding
- Shown once on first launch to introduce the app.

### Authentication
- **Sign In**: Firebase email/password login, then looks up the Shopify customer ID by email. Validates form in real time before allowing submission.
- **Sign Up**: Firebase registration, then creates a matching Shopify customer. Inline field validation with error/success states.

### Home
- Loads products and brands in a single API call (`GetHomeScreenDataUseCase`).
- Features: auto-scrolling banner carousel (mock data), brand horizontal list, category chip filter, paginated product grid.
- Supports **infinite scroll** — triggers `loadMoreProducts` when the user scrolls near the last 3 items.
- **Filter sheet**: price range slider, size multi-select, sort (relevance / price low-high / price high-low).
- Favourite toggle updates SwiftData immediately — no network call needed.

### Brand Products
- Shows all products for a selected brand (vendor), with the same infinite scroll and favourite toggle as Home.
- Tapping a product navigates to Product Details.

### Product Details
- Displays images, title, price, sizes, description for a product fetched by ID.
- Uses a `ProductDetailsState` enum: `idle`, `loading`, `success`, `failure`.

### Search
- Pre-fetches all products once on first search, then filters **locally** on every keystroke — no repeated API calls.
- Persists recent searches locally via `RecentSearchesRepositoryImpl` (UserDefaults).
- States: `loading`, `recentResults`, `success`, `noResult`.

### Cart
- Backed by Shopify Draft Orders.
- Quantity changes are applied **optimistically** to the UI immediately, then debounced 500ms before syncing to the API — avoids excessive requests while the user taps rapidly.
- Supports: increment/decrement quantity, remove item, clear cart.
- `CartViewState` enum: `loading`, `empty`, `success(CartUIState)`, `failure`.

### Favourites
- Saved products are stored **locally** in SwiftData — no network calls.
- Supports removing a saved product. List refreshes immediately.

### Account
- Placeholder screen for user account details.


---

## Key Design Decisions

- **AppRouter for navigation**: A single `@Observable` `AppRouter` injected at the root replaces scattered `NavigationLink` and `AppStorage` flags. Any screen can trigger a global navigation change by calling a method on the router.
- **Local favourites (SwiftData)**: Favourites are stored on-device only, making the feature available offline and instant. The `SavedProductModel` is the SwiftData model; `SavedProduct` is the domain entity.
- **Native URLSession**: No Alamofire dependency. The `NetworkService` is a protocol-backed singleton (`NetworkService.shared`) that uses `async/await` with `URLSession`.
- **Optimistic cart UI**: Quantity changes reflect immediately in the UI while the debounced network call runs in the background. If the API call fails, the UI reverts to the last known good state.
- **Local search filtering**: All products are fetched once, then filtered in memory. Avoids N API calls for N keystrokes.
- **Factory + EntryPoint pattern**: Each module has a `*ModuleFactory` that builds the full dependency graph, and a `*EntryPoint` view that calls the factory. Views stay free of construction logic.
- **Secrets management**: The Shopify access token is read at runtime from `Info.plist` (set via a build config), never hardcoded — see `ShopifyConfig.accessToken`.
