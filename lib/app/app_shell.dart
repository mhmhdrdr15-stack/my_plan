import 'package:flutter/material.dart';
import 'app_router.dart';
import 'package:my_plan/core/navigation/app_bottom_nav.dart';
import 'package:my_plan/features/food_log/pages/add_food_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int currentTab = 0;

  final screens = <Widget?>[AppRouter.screenForTab(0), null, null, null];

  void selectTab(int index) {
    if (screens[index] == null) {
      screens[index] = AppRouter.screenForTab(index);
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
