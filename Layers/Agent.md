# Architecture Layers

The project follows **Clean Architecture** with three layers per feature: **Data**, **Domain**, and **Presentation**. Dependencies always point inward — Presentation depends on Domain, Data depends on Domain, and Domain depends on nothing outside Swift.

---

## Layer Overview

```
┌─────────────────────────────────────────┐
│            Presentation Layer           │
│   Views  ←  ViewModel  ←  UseCase      │
├─────────────────────────────────────────┤
│               Domain Layer              │
│   Entities · Repository Protocols ·     │
│   UseCase Protocols + Implementations   │
├─────────────────────────────────────────┤
│               Data Layer                │
│   Repository Impl · Remote DataSource · │
│   Local DataSource · DTOs · Endpoints   │
└─────────────────────────────────────────┘
         ↓ network        ↓ local
   Shopify Admin API    SwiftData / UserDefaults
```

---

## 1. Domain Layer

The innermost layer. Pure Swift — no UIKit, Firebase, or networking imports.

### Entities
Plain Swift structs representing the core business objects.

| Entity | Module | Key Properties |
|---|---|---|
| `Product` | Home, BrandProducts | `id`, `title`, `vendor`, `productType`, `price`, `sizes`, `imageUrl` |
| `Brand` | Home | `id`, `title`, `imageUrl` |
| `BannerProduct` | Home | Static mock data for the carousel |
| `ProductDetailsEntity` | ProductDetails | `id`, `title`, `description`, `images`, `variants` |
| `ProductSearch` | Search | `id`, `title`, `vendor`, `price`, `imageUrl` |
| `SavedProduct` | Favourite | `id`, `title`, `price`, `imageUrl` |
| `Cart` | Cart | `draftOrderId`, `lineItems`, `totalPrice` |
| `CartLineItem` | Cart | `variantId`, `quantity`, `price`, `title` |
| `AppUser` | Auth | `uid`, `email` |

### Repository Protocols
Owned by the Domain layer; implemented by the Data layer.

```
HomeRepositoryProtocol         → fetchHomeData(), fetchMoreProducts(limit:)
ProductDetailsRepo             → getProductDetails(id:)
SearchRepositoryProtocol       → fetchAllProducts()
CartRepository                 → createDraftOrder(), getDraftOrder(), updateQuantity(), removeLineItem(), clearCart()
SavedProductsRepository        → getAll(), toggle(), remove()
RecentSearchesRepositoryProtocol → getRecentSearches(), save(), remove(), clearAll()
AuthRepositoryProtocol         → signIn(), signUp()
CustomerRepositoryProtocol     → findCustomer(email:), createCustomer()
TokenStorageProtocol           → save(), get(), delete()
```

### Use Cases
One business action per class. Each has a protocol so it can be swapped in tests.

**Pattern:**
```swift
protocol GetProductDetailsUseCaseProtocol {
    func execute(productId: Int) async throws -> ProductDetailsEntity
}

final class GetProductDetailsUseCase: GetProductDetailsUseCaseProtocol {
    private let repo: ProductDetailsRepo
    func execute(productId: Int) async throws -> ProductDetailsEntity {
        try await repo.getProductDetails(id: productId)
    }
}
```

---

## 2. Data Layer

Implements domain repository protocols. Handles networking, DTO decoding, local persistence, and mapping.

### Remote Data Sources
Call `NetworkService.shared.request(_:)` with a typed `APIEndpoint`.

| Data Source | Module | Endpoint file |
|---|---|---|
| `HomeRemoteDataSource` | Home | `ProductsEndpoint` |
| `ProductDetailsDataSource` | ProductDetails | `ProductDetailsEndPoint` |
| `SearchRemoteDataSource` | Search | `SearchEndpoint` |
| `CartRemoteDataSource` | Cart | `CartEndpoint` |
| `ShopifyRemoteDataSource` | Auth | `ShopifyAuthEndpoint` |

### Local Data Sources
| Data Source | Module | Storage |
|---|---|---|
| `SavedProductsLocalDataSourceImpl` | Favourite | SwiftData (`SavedProductModel`) |
| `RecentSearchesLocalDataSource` | Search | UserDefaults |

### Endpoints
Each module defines an enum or struct conforming to `APIEndpoint`:

```swift
protocol APIEndpoint {
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem]? { get }
    var body: (any Encodable)? { get }
    var fullURL: URL? { get }
}
```

The base URL is built from `ShopifyConfig`:
```
https://mad46-ios-team8.myshopify.com/admin/api/2024-01/
```
The access token is read from `Info.plist` at runtime via `ShopifyConfig.accessToken`.

### DTOs (Data Transfer Objects)
Codable structs that mirror Shopify's JSON responses. Never leave the Data layer.

Examples: `ProductDTO`, `VendorDTO`, `ImageDTO`, `DraftOrderDTO`, `MetafieldDTO`, `InventoryLevelResponseDTO`, `ProductDetailsDTO`

Decoding uses `.convertFromSnakeCase` on `JSONDecoder`, so `product_type` in JSON maps to `productType` in Swift automatically.

### Repository Implementations
Map DTOs to domain entities and coordinate between remote and local data sources.

**Example — SavedProductsRepositoryImpl:**
```swift
func toggle(product: SavedProduct) throws {
    if localDataSource.exists(id: product.id) {
        try localDataSource.delete(id: product.id)
    } else {
        try localDataSource.save(product)
    }
}
```

### SwiftData Model
`SavedProductModel` is the on-device persistence model for favourites. It is defined in the Data layer and mapped to the `SavedProduct` domain entity in `SavedProductsRepositoryImpl`. The `ModelContainer` is created in `DrapeApp` and injected via `.modelContainer(container)`.

---

## 3. Presentation Layer

SwiftUI Views and ViewModels. Views are passive — they read state and call ViewModel methods.

### ViewModels
Two patterns are used across the app:

| Pattern | Modules |
|---|---|
| `@Observable` | Auth (SignIn, Signup), ProductDetails |
| `ObservableObject` + `@Published` | Home, BrandProducts, Cart, Search, Favourites |

All ViewModels are `@MainActor` (either via annotation or class-level attribute) to ensure UI updates are always on the main thread.

ViewModels never import Alamofire, Firebase, SwiftData, or URLSession directly — all I/O goes through use case protocols.

### Views
- Observe their ViewModel with `@StateObject` (for `ObservableObject`) or `@State` (for `@Observable`).
- Broken into small sub-views in a `components/` subfolder.
- Call ViewModel methods in `.task {}`, `.onAppear {}`, or button actions.

### UI State Enums
Used to make impossible states impossible:

```swift
// ProductDetails
enum ProductDetailsState { case idle, loading, success(ProductDetailsEntity), failure(String) }

// Cart
enum CartViewState { case loading, empty, success(CartUIState), failure(String) }

// Search
enum SearchState { case loading, recentResults, success([ProductSearch]), noResult }
```

### Factories & Entry Points
Each module pairs a **Factory** with an **EntryPoint**:

- `*ModuleFactory` — builds the full dependency graph and returns a ready View
- `*EntryPoint` — a SwiftUI View that calls the factory; used as the tab destination

```
TabView
  └── HomeEntryPoint
        └── HomeModuleFactory.makeHomeView(modelContext:)
              └── HomeScreen(viewModel: HomeViewModel(...))
```

---

## 4. Core / Shared Layer

Utilities used across all modules.

| File | Purpose |
|---|---|
| `NetworkService` | Protocol-backed URLSession wrapper; singleton via `.shared` |
| `NetworkError` | Typed errors: `invalidURL`, `serverError(statusCode:)`, `decodingFailed`, `unknown` |
| `APIEndpoint` | Protocol all endpoint enums conform to |
| `HTTPMethod` | Enum: `GET`, `POST`, `PUT`, `DELETE`, `PATCH` |
| `ShopifyConfig` | Base URL, API version, access token — single source of truth |
| `AppRouter` | `@Observable` navigation driver injected into the environment |
| `AppScreen` | Enum of all root screens: `splash`, `onBoarding`, `signIn`, `signUp`, `home` |
| `CustomButton` | Reusable primary button |
| `CustomTextField` | Styled text field with validation states |
| `CustomSearchField` | Search bar component |
| `SliderFilterView` | Price range slider used in the Home filter sheet |

---

## Module Folder Structure

Each feature follows this consistent layout:

```
Modules/<Feature>/
├── Data/
│   ├── DataSources/     (remote + local)
│   ├── Models/          (DTOs + Mappers)
│   ├── Network/         (Endpoint definition)
│   └── Repositories/    (protocol implementations)
├── Domain/
│   ├── Entities/
│   ├── RepositoryProtocols/  (or Repositories/)
│   └── UseCases/
├── Presentation/
│   ├── ViewModels/
│   ├── View/ (or Views/)
│   │   └── Components/ (or components/)
│   └── Models/          (UI state structs/enums)
├── <Feature>ModuleFactory.swift
└── <Feature>EntryPoint.swift
```

Auth follows the same split but lives in `Auth/` at the root rather than `Modules/`.


