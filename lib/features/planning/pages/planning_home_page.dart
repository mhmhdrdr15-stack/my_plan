import 'package:flutter/material.dart';

import 'package:my_plan/core/state/app_state.dart';

class PlanningHomePage extends StatelessWidget {
  const PlanningHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: appState.planning,
      builder: (context, _) {
        final planning = appState.planning;
        return Scaffold(
          backgroundColor: const Color(0xFFF7F7FB),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => planning.load(),
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  const Text(
                    'Planning',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF18182B),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Create meal templates and plan your week.',
                    style: TextStyle(fontSize: 14, color: Color(0xFF85899D)),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Daily targets',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${planning.dailyCalories.round()} kcal',
                            style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Protein ${planning.dailyProtein.round()}g • Carbs ${planning.dailyCarbs.round()}g • Fat ${planning.dailyFat.round()}g',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF5E6278),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Templates',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            planning.templates.isEmpty
                                ? 'No templates yet.'
                                : '${planning.templates.length} templates saved',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5E6278),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
