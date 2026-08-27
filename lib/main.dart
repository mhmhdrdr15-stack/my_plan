import 'package:flutter/material.dart';
import 'features/food_log/pages/add_food_screen.dart';
import 'core/localization/app_localization.dart';
import 'core/state/app_state.dart';
import 'core/navigation/app_bottom_nav.dart';
import 'features/food_log/pages/log_screen.dart';
import 'features/plan/pages/plan_screen.dart';
import 'features/nutrition/pages/progress_screen.dart';
import 'features/home/pages/home_screen.dart';

export 'features/home/pages/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await appState.load();
  appLocale.value = appState.locale;
  runApp(const NutritionApp());
}

// ===============================================================
// APP
// ===============================================================

class NutritionApp extends StatelessWidget {
  const NutritionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLanguageScope(child: AppShell());
  }
}

// ===============================================================
// HOME
// ===============================================================
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentTab = 0;

  final screens = <Widget?>[const HomeScreen(), null, null, null];

  void selectTab(int index) {
    if (screens[index] == null) {
      screens[index] = switch (index) {
        1 => const PlanScreen(showBottomNav: false),
        2 => const LogFoodScreen(showBottomNav: false),
        3 => const ProgressScreen(showBottomNav: false),
        _ => const HomeScreen(),
      };
    }
    setState(() => currentTab = index);
  }

  void openAddFood() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        pageBuilder: (_, animation, secondaryAnimation) => AddFoodScreen(
          onNavigate: (index) {
            Navigator.of(context).pop();
            selectTab(index);
          },
        ),
        transitionDuration: const Duration(milliseconds: 160),
        reverseTransitionDuration: const Duration(milliseconds: 120),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentTab,
        children: [
          for (final screen in screens) screen ?? const SizedBox.shrink(),
        ],
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: currentTab,
        onItemSelected: selectTab,
        onAdd: openAddFood,
      ),
    );
  }
}

