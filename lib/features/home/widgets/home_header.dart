import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/theme/app_colors.dart';
import 'package:my_plan/features/settings/pages/settings_screen.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 72,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, 'Good morning, Mahmoud 👋'),
                  style: const TextStyle(
                    color: AppColors.text,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  translateText(context, 'Sunday, 23 August'),
                  style: const TextStyle(
                    color: AppColors.muted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            key: const ValueKey('open-settings'),
            tooltip: translateText(context, 'Settings'),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const SettingsScreen(),
              ),
            ),
            icon: const Icon(Icons.settings_outlined, color: AppColors.text),
          ),
        ],
      ),
    );
  }
}
