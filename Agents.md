# Agents — ViewModels & Use Cases

This document describes every ViewModel in the app and the Use Cases it depends on.

---

## AppRouter

**File:** `Core/Navigation/AppRouter.swift`  
**Type:** `@Observable` class — injected into the SwiftUI environment at the root

Not a ViewModel, but the central navigation agent. Holds `currentScreen: AppScreen` and exposes methods (`showHome()`, `showSignIn()`, etc.) that any view can call to trigger a full-screen transition.

---

## SignInViewModel

**File:** `Auth/Presentation/ViewModel/SignInViewModel.swift`  
**Type:** `@Observable`

| Responsibility | Detail |
|---|---|
| Form validation | Real-time email regex check and password length check |
| Sign in | Calls `SignInUseCase`, receives back a Shopify customer ID |
| Error handling | Shows alert on Firebase auth failure |

**Use Cases:**
- `SignInUseCase` (Firebase sign in + Shopify customer lookup)

**State:** `email`, `password`, `emailState`, `passwordState`, `isLoading`, `showAlert`, `alertMessage`, `shopifyCustomerID`

---

## SignupViewModel

**File:** `Auth/Presentation/ViewModel/Signup_ViewModel.swift`  
**Type:** `@Observable`

Handles registration: validates form fields, creates a Firebase user, then creates a matching Shopify customer.

**Use Cases:**
- `SignUpUseCase`

---

## HomeViewModel

**File:** `Modules/Home/Presentation/HomeViewModel.swift`  
**Type:** `ObservableObject` / `@MainActor`  
**Created by:** `HomeModuleFactory`

The most feature-rich ViewModel in the app.

| Responsibility | Detail |
|---|---|
| Load home data | Fetches products + brands in one call; extracts unique categories |
| Infinite scroll | Triggers `loadMoreProducts` near the bottom of the list |
| Local filtering | Filters `products` by category, price range, and size — no API call |
| Sorting | Sorts `filteredProducts` by relevance, price low→high, or price high→low |
| Favourites | `toggleFavorite` writes to SwiftData; `savedProductIDs` set drives heart icon state |
| Featured carousel | Populated from static mock `BannerProduct.mockBanners` |

**Use Cases:**
- `GetHomeScreenDataUseCaseProtocol` — initial products + brands fetch
- `LoadMoreProductsUseCaseProtocol` — pagination
- `ToggleSaveProductUseCaseProtocol` — save/unsave a product locally
- `GetSavedProductsUseCaseProtocol` — read saved IDs to update heart icons

**Published state:** `products`, `brands`, `categories`, `selectedCategory`, `isLoading`, `isLoadingMore`, `errorMessage`, `featuredProducts`, `sortOption`, `priceRange`, `selectedSizes`, `savedProductIDs`

**Computed:** `filteredProducts`, `availableSizes`, `maxProductPrice`

---

## BrandProductsViewModel

**File:** `Modules/BrandProducts/Presentation/ViewModels/BrandProductsViewModel.swift`  
**Type:** `ObservableObject` / `@MainActor`  
**Created by:** `BrandProductsModuleFactory`

Loads products for a single brand (vendor) with the same infinite scroll and favourite toggle logic as `HomeViewModel`.

**Use Cases:**
- `GetProductsByVendorUseCaseProtocol`
- `ToggleSaveProductUseCaseProtocol`
- `GetSavedProductsUseCaseProtocol`

**Published state:** `products`, `isLoading`, `isLoadingMore`, `errorMessage`, `savedProductIDs`

---

## ProductDetailsViewModel

**File:** `Modules/ProductDetails/Presentation/ViewModel/ProductDetailsViewModel.swift`  
**Type:** `@Observable`

Simple state machine with four states: `idle → loading → success(ProductDetailsEntity) / failure(String)`.

**Use Cases:**
- `GetProductDetailsUseCase`

**State:** `state: ProductDetailsState`

---

## SearchViewModel

**File:** `Modules/Search/Presentation/ViewModels/SearchViewModel.swift`  
**Type:** `ObservableObject` / `@MainActor`

| Responsibility | Detail |
|---|---|
| Fetch all products | Done once on first search; result cached in `products` |
| Local filtering | `filterProducts()` runs on every `searchText` change — no API call |
| Recent searches | Save, remove, and clear via `RecentSearchesRepositoryProtocol` (UserDefaults) |

**Use Cases:**
- `FetchAllProductsUseCaseProtocol`

**State:** `state: SearchState` (`loading`, `recentResults`, `success`, `noResult`), `searchText`, `recentSearches`

---

## CartViewModel

**File:** `Modules/Cart/Presentation/ViewModels/CartViewModel.swift`  
**Type:** `ObservableObject` / `@MainActor`

| Intention | What it does |
|---|---|
| `loadCart` | Fetches existing draft order by ID; sets state to `empty` if no ID |
| `createCart` | Creates a new Shopify Draft Order with the given line items |
| `increment` / `decrement` | Applies change locally immediately, then debounces 500ms before API sync |
| `removeItem` | Optimistic removal from UI; reverts on failure |
| `clearCart` | Deletes the entire draft order |

**Use Cases:**
- `GetDraftOrderUseCaseProtocol`
- `CreateDraftOrderUseCaseProtocol`
- `UpdateCartItemQuantityUseCaseProtocol`
- `RemoveCartLineItemUseCaseProtocol`
- `ClearCartUseCaseProtocol`

**State:** `state: CartViewState` (`loading`, `empty`, `success(CartUIState)`, `failure`)

---

## SavedProductsViewModel

**File:** `Modules/Favourite/Presentation/ViewModels/SavedProductsViewModel.swift`  
**Type:** `ObservableObject` / `@MainActor`  
**Created by:** `FavoriteModuleFactory`

Reads and removes saved products from SwiftData. Synchronous — no network calls.

**Use Cases:**
- `GetSavedProductsUseCaseProtocol`
- `RemoveSavedProductUseCaseProtocol`

**State:** `products: [SavedProduct]`, `errorMessage`

---

## Shared Infrastructure

| Agent | File | Role |
|---|---|---|
| `NetworkService` | `Core/Network/NetworkService.swift` | Protocol-backed URLSession singleton; used by all remote data sources |
| `ShopifyConfig` | `Core/Config/ShopifyConfig.swift` | Centralises base URL, API version, and access token from `Info.plist` |
| `AppRouter` | `Core/Navigation/AppRouter.swift` | Global navigation state injected into the SwiftUI environment |
| `FirebaseAuthRepository` | `Auth/Data/Repositories/FirebaseAuthRepository.swift` | Wraps Firebase Auth sign-in and registration |
| `ShopifyCustomerRepository` | `Auth/Data/Repositories/ShopifyCustomerRepository.swift` | Looks up and creates Shopify customers by email |
| `KeychainTokenStorage` | `Auth/Data/Repositories/KeychainTokenStorage.swift` | Persists auth tokens securely in the iOS Keychain |
