# My Plan

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Target Architecture

The project follows a clean, scalable feature-first structure. The active application lives under `lib/app`, `lib/core`, `lib/data`, and `lib/features`. The legacy merge artifacts stay under `lib/legacy` and are not part of the active app flow.

```text
lib/
  app/
    app.dart                     App bootstrap and language scope
    app_router.dart              Route mapping for main tab screens
    app_shell.dart               Main shell with bottom navigation
    exports.dart                 App-layer public exports

  core/
    localization/               Arabic/English strings and locale handling
    navigation/                 Shared navigation widgets and tab logic
    state/                      App-wide state and controllers
    storage/                    SQLite access and persistence helpers
    theme/                      Color tokens and shared visual design values
    widgets/                    Reusable UI components and layouts
    exports.dart                 Core-layer public exports

  data/
    shared/
      models/                   Domain models used across features
      repositories/            Data access and persistence abstractions

  features/
    home/
      pages/
      widgets/
    food_log/
      pages/
      widgets/
    plan/
      pages/
      widgets/
    planning/
      pages/
      services/
      widgets/
    nutrition/
      pages/
    notifications/
      pages/
      models/
    settings/
      pages/
    exports.dart                 Feature-layer public exports

  legacy/
    README.md                   Archive rules and migration notes
    old_root/                   Old root-level files kept for reference only
    screens/                    Archived screen implementations no longer in use

  main.dart                     App entrypoint
  app_localization.dart         Deprecated compatibility export
  app_state.dart               Deprecated compatibility export
  database_helper.dart         Deprecated compatibility export
```

### Rules for future work
- Keep feature-specific screens, widgets, and services inside the matching feature folder.
- Put reusable cross-cutting logic in `core` only when it is truly shared.
- Keep domain/data models in `data/shared/models` and repository logic in `data/shared/repositories`.
- Do not import from `lib/legacy` in active features.
- If a feature becomes reused broadly, promote it to `core` only after it is clearly independent of a single screen.
- Prefer small, single-purpose files over large root-level screens.

### Active vs legacy
- Active app flow: `lib/app`, `lib/core`, `lib/data`, `lib/features`
- Legacy archive: `lib/legacy`
- Legacy code must remain read-only unless intentionally migrated back into active modules.

## Project Notes

The app includes a dashboard, meal plan, food log, progress view, local
preferences, and English/Arabic direction support. Run it with:

```bash
flutter pub get
flutter run
```

Validation commands:

```bash
flutter analyze
flutter test
flutter build apk --debug
```

Food and nutrition values are currently sample data. Images use Unsplash and
require network access; replace them with licensed local assets for production.
