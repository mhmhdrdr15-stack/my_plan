# My Plan

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:


For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Source Structure

Application code is organized by responsibility:

```text
lib/
	main.dart                         App entrypoint and dashboard composition
	core/
		localization/                   English/Arabic localization
		navigation/                     Shared bottom navigation
		state/                          App-wide ChangeNotifier state
		storage/                        SQLite database access
		theme/                          Shared colors and design tokens
		widgets/                        Reusable UI primitives
	features/
		food_log/                       Add food, log, history, and log widgets
		plan/                            Plan pages, editors, and plan widgets
		nutrition/                      Progress and meal detail pages
		notifications/                  Notification pages and models
		settings/                       Settings pages
```

When adding code, keep feature-specific code inside its feature folder. Move
only genuinely reusable code into `core`; avoid importing feature pages from
`core` to keep dependencies flowing in one direction.

The small root files `app_state.dart`, `app_localization.dart`, and
`database_helper.dart` are compatibility exports for older imports. New code
should import their `core/...` paths directly.

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
