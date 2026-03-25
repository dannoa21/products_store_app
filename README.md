# products_store_app

## 1. Setup & Run Instructions
This app is a Flutter “Product Catalog” using the DummyJSON Products API.

### Flutter version used
Flutter `3.35.4` (stable).

### Prerequisites
- Flutter SDK installed (3.x)
- An Android emulator/device or iOS simulator/device

### Setup
1. Install dependencies:
   - `flutter pub get`

### Run
- Debug / run on a device:
  - `flutter run`
- Run in release mode:
  - `flutter run --release`

## 2. Architecture Overview
This project follows a feature-first, clean architecture-ish structure documented in `ARCHITECTURE.md`.

### Folder structure (high level)
- App wiring / app shell:
  - `lib/main.dart` (root widget, repositories, `MaterialApp` theme + routing)
  - `lib/common_components/config/routing/route_generator.dart` (route name -> page)
  - `lib/screens/` (app-level screens, e.g. `TestingScreen`)
- Feature module: `lib/features/product/`
  - `domain/` (repository interfaces + value objects)
  - `data/` (remote repositories + mappers)
  - `presentation/`
    - `pages/` (UI)
    - `blocs/` (Cubits + state classes)
- Shared code
  - `lib/core/` (network, constants, utils)
  - `lib/common_components/` (theme + reusable widgets)

### State management approach
- Uses `flutter_bloc` with `Cubit` + explicit state classes.
- Cubit provisioning is done at the UI boundary of each feature page:
  - `ProductHomeScreen` creates `ProductCubit` + `CategoryCubit` via `MultiBlocProvider`.
  - `ProductDetailScreen` creates `ProductDetailCubit` via `BlocProvider` (keyed by `productId` so switching products recreates the cubit).
- UI renders explicit states with `BlocBuilder` / `BlocConsumer`, including:
  - Product list: `ProductInitial`, `ProductLoading`, `ProductLoadingMore`, `ProductLoaded`, `ProductError`
  - Product detail: `ProductDetailInitial`, `ProductDetailLoading`, `ProductDetailLoaded`, `ProductDetailError`

### Key architectural decisions
- Repository abstraction:
  - Domain defines `ProductRepository` / `CategoryRepository`
  - Data layer implements them using remote repositories (`ProductRemoteRepository`, `CategoryRemoteRepository`)
- Data validation / “imperfect API” handling:
  - Centralized in `lib/core/utils/data_sanitizer.dart`
  - Product mappers use `DataSanitizer` to provide defaults and to log warnings/errors without crashing the UI.
- Routing rule:
  - `RouteGenerator` is a thin route-name adapter (see `lib/common_components/config/routing/route_generator.dart`)
  - Feature pages own their own Cubit creation.

## 3. Design System Rationale
### Theming
- Centralized theming is implemented in `lib/common_components/config/theme/app_theme.dart`.
- Both light and dark themes are defined (`AppTheme.light` and `AppTheme.dark`) using `ColorScheme`.
- Typography is standardized through `TextTheme` (e.g. `headlineMedium`, `titleMedium`, `bodyMedium`).
- The app theme is wired into `MaterialApp` via:
  - `theme: AppTheme.light`
  - `darkTheme: AppTheme.dark`
  - `themeMode` is currently fixed to light (there is a TODO to add an in-app toggle).

### Reusable component API choices
The UI uses a small set of reusable, themed components so screens stay declarative:
- `ProductCard` (`lib/features/product/presentation/pages/product_card.dart`)
  - API: `ProductCard(product: ..., onTap: ...)`
  - Rationale: takes a domain `Product` and exposes interaction via a callback, keeping presentation consistent across list contexts.
- `CategoryChipsRow` (`lib/features/product/presentation/pages/category_chips_row.dart`)
  - API: `CategoryChipsRow(categories, selectedCategorySlug, onSelected)`
  - Rationale: stateless/presentational widget; selection changes propagate upward through `onSelected`.
- `ImageViewer` (`lib/common_components/widgets/image_viewer.dart`)
  - API supports sizing (`width`/`height`), shape/radius (`borderRadius`/`boxShape`), rendering (`boxFit`), and consistent loading/failure UI (`placeholder`, `errorPlaceholder`)
  - Rationale: wraps `extended_image` to standardize image loading + caching and to avoid per-screen image handling logic.

### Deviations from the spec (design-system-related)
- The app has a consistent theme and reusable components, but it does not implement skeleton/shimmer placeholders for the initial list load (it uses a standard `CircularProgressIndicator` instead).
- In the interest of saving time, GoRouter was not used; this repo uses `MaterialApp.onGenerateRoute` with `RouteGenerator` and passes `productId` via `RouteSettings.arguments` instead. There is no URL-based deep linking.

## 4. Limitations
Areas that would be improved with more time (or where the current implementation is a shortcut relative to the assessment spec):

- Navigation + deep linking (spec requirement)
  - The assessment encourages GoRouter with deep-linkable URLs like `/products/:id`.
  - In the interest of saving time, GoRouter was not used; this repo uses `MaterialApp.onGenerateRoute` with `RouteGenerator` and passes `productId` via `RouteSettings.arguments` instead. There is no URL-based deep linking.
- Skeleton/shimmer loading states (spec requirement)
  - Initial loading uses a spinner rather than skeleton/shimmer placeholders.
- ErrorState retry coverage (spec requirement)
  - When loading fails with an empty list, the UI shows `ProductError.message` but does not provide a visible retry button in that state (the snackbar retry is only shown when there are existing products).
- Search + pagination interaction bug/limitation
  - `ProductCubit` supports infinite scroll by calling the repository with `skip/limit`.
  - `ProductRemoteRepository.getProducts()` builds the request URL by conditionally overwriting the base endpoint:
    - search requests drop pagination parameters (`limit/skip`)
    - category requests drop the search query when both are provided (last condition wins)
  - Because of this, pagination and the “search + category filters work together” requirement may not behave correctly for filtered results.
- Testing coverage (spec requirement) -- For all testing types
  - The repo contains only a generic Flutter widget smoke test (`test/widget_test.dart`), not unit tests for Cubit/data validation nor widget tests for at least two design system components.
- Additional reference repo for unimplemented features:
  - See the related `ar_indoor_nav_admin` codebase here: https://github.com/Group16AAiT/ar_indoor_navigation/tree/main/ar_indoor_nav_admin

## 5. AI Tools Usage
Briefly document your actual AI tool usage here (edit to match what you really used):
- AI tool(s) used: ChatGPT, Cursor, Antigravity
  - Added centralized data validation + logging via `DataSanitizer`, then used it in the product/product-detail mappers so missing/invalid API fields don’t crash the UI (`lib/core/utils/data_sanitizer.dart`, `lib/features/product/data/mappers/*`)
  - Designed reusable image UI primitives to standardize loading + failure rendering (`ImageViewer` + `ImagePlaceholder`), backed by `extended_image` (`lib/common_components/widgets/image_viewer.dart`, `lib/common_components/widgets/image_placeholder.dart`)
  - Implemented the tablet responsive master-detail layout using constants (`LayoutConstants.tabletBreakpoint`, `dualScreenMasterWidth`) and conditional rendering in `ProductHomeScreen` (`lib/core/constants/layout_constants.dart`, `lib/features/product/presentation/pages/product_home_screen.dart`)
  - Shaped the Bloc/Cubit state modeling for the product list and pagination flows (explicit loading/error/loaded states and bottom loader behavior) (`lib/features/product/presentation/blocs/product_cubit.dart`, `lib/features/product/presentation/blocs/product_state.dart`)
- What you changed/refined after AI output:
  - Adjusted the component and Cubit interfaces to match how the UI is already composed (feature pages own Cubit provisioning; the detail cubit is recreated with `ValueKey(productId)` in `ProductDetailScreen`)
  - Tightened data handling so the UI displays consistent fallbacks (e.g., invalid/negative price -> “Price unavailable”, invalid image URLs -> placeholder)
