# Architecture Notes

This Flutter app uses a feature-first clean architecture-ish structure.

## Folder conventions

- App-level screens / shells: `lib/screens/`
- Feature modules: `lib/features/<feature>/`
  - Domain: `lib/features/<feature>/domain/`
  - Data: `lib/features/<feature>/data/`
  - Presentation (UI + state): `lib/features/<feature>/presentation/`
  - Feature-owned route UI + Bloc/Cubit providers: `lib/features/<feature>/presentation/pages/`
- Shared cross-feature utilities/constants: `lib/core/` (for example, `lib/core/constants`, `lib/core/utils`)
- Shared UI components/config: `lib/common_components/`

## Routing rule

- `lib/common_components/config/routing/route_generator.dart` should be a thin adapter: route name -> page widget.
- Feature pages are responsible for creating their own Bloc/Cubit providers.

