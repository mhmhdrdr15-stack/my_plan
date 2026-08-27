import 'package:flutter/material.dart';
import 'package:my_plan/features/food_log/pages/add_food_screen.dart';
import 'package:my_plan/core/navigation/app_bottom_nav.dart';
import 'package:my_plan/core/localization/app_localization.dart';
import 'package:my_plan/core/state/app_state.dart';
import 'package:my_plan/features/food_log/pages/log_screen.dart';
import 'package:my_plan/features/notifications/pages/notification_settings_page.dart';
import 'package:my_plan/features/plan/pages/plan_screen.dart';
import 'package:my_plan/features/nutrition/pages/progress_screen.dart';
import 'package:my_plan/core/widgets/reusable_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const primary = Color(0xFF4B24F5);
  static const darkText = Color(0xFF111827);
  static const secondaryText = Color(0xFF62708C);
  static const cardBorder = Color(0xFFF0F1F5);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: [
            _header(context),
            const SizedBox(height: 24),
            _profileCard(context),
            const SizedBox(height: 18),
            _premiumCard(context),
            const SizedBox(height: 24),
            _settingsSection(context, 'Goals & Profile', [
              const _SettingData(
                Icons.my_location_rounded,
                'Goals',
                'Calorie, macros, water and more',
              ),
              const _SettingData(
                Icons.person_outline_rounded,
                'Profile Information',
                'Update your personal details',
              ),
              const _SettingData(
                Icons.monitor_weight_outlined,
                'Body Stats',
                'Weight, height, activity level & more',
              ),
              const _SettingData(
                Icons.flag_outlined,
                'Activity Level',
                'Moderately active',
              ),
            ]),
            const SizedBox(height: 24),
            _settingsSection(context, 'Preferences', [
              const _SettingData(
                Icons.notifications_none_rounded,
                'Notifications',
                'Meal, water and progress reminders',
              ),
              const _SettingData(
                Icons.water_drop_outlined,
                'Units',
                'Metric (kg, cm, kcal)',
              ),
              const _SettingData(
                Icons.palette_outlined,
                'Appearance',
                'Light mode',
              ),
              const _SettingData(Icons.language_rounded, 'Language', 'English'),
            ]),
            const SizedBox(height: 24),
            _settingsSection(context, 'Account & Data', [
              const _SettingData(
                Icons.shield_outlined,
                'Privacy',
                'Manage your privacy settings',
              ),
              const _SettingData(
                Icons.cloud_upload_outlined,
                'Backup & Restore',
                'Backup your data to the cloud',
              ),
              const _SettingData(
                Icons.delete_outline_rounded,
                'Delete Account',
                'Permanently delete your account and data',
                danger: true,
              ),
            ]),
            const SizedBox(height: 24),
            _settingsSection(context, 'Support', [
              const _SettingData(
                Icons.help_outline_rounded,
                'Help Center',
                'FAQs and support articles',
              ),
              const _SettingData(
                Icons.mail_outline_rounded,
                'Contact Us',
                'We are here to help',
              ),
              const _SettingData(
                Icons.info_outline_rounded,
                'About',
                'App version 2.3.0',
              ),
            ]),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 0,
        onItemSelected: (index) {
          final destination = switch (index) {
            1 => const PlanScreen(),
            2 => const LogFoodScreen(),
            3 => const ProgressScreen(),
            _ => null,
          };
          if (destination != null) {
            Navigator.of(
              context,
            ).push(MaterialPageRoute<void>(builder: (_) => destination));
          }
        },
        onAdd: () => Navigator.of(
          context,
        ).push(MaterialPageRoute<void>(builder: (_) => const AddFoodScreen())),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          tooltip: 'Back',
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                translateText(context, 'Settings'),
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.w700,
                  color: darkText,
                ),
              ),
              SizedBox(height: 7),
              Text(
                translateText(context, 'Manage your account and preferences.'),
                style: TextStyle(fontSize: 14, color: secondaryText),
              ),
            ],
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(
              Icons.notifications_none_rounded,
              size: 32,
              color: darkText,
            ),
            Positioned(
              right: -1,
              top: -2,
              child: Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: Color(0xFFE7002A),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _profileCard(BuildContext context) {
    return _card(
      height: 106,
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xFFE8EEFA),
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: AppNetworkImage(
                url:
                    'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?auto=format&fit=crop&w=240&q=80',
                fallback: Icons.person_rounded,
                width: 70,
                height: 70,
                radius: 0,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, 'Mahmoud'),
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  'alex.johnson@example.com',
                  style: TextStyle(fontSize: 12, color: Color(0xFF8A96AA)),
                ),
                SizedBox(height: 7),
                _PremiumBadge(),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, size: 25, color: darkText),
        ],
      ),
    );
  }

  Widget _premiumCard(BuildContext context) {
    return Container(
      height: 112,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          colors: [Color(0xFFF1ECFF), Color(0xFFE1D8FF)],
        ),
        border: Border.all(color: const Color(0xFFD8CCFF)),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: primary,
            child: Icon(
              Icons.workspace_premium_rounded,
              color: Colors.white,
              size: 29,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  translateText(context, 'Go Premium'),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: darkText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  translateText(
                    context,
                    'Unlock all features and insights\nto reach your goals faster.',
                  ),
                  style: TextStyle(
                    fontSize: 11.5,
                    height: 1.4,
                    color: Color(0xFF30394F),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(
                  content: Text(translateText(context, 'Premium plan preview is coming soon')),
                  behavior: SnackBarBehavior.floating,
                ),
              ),
            child: Text(
              translateText(context, 'View Plan'),
              style: TextStyle(color: primary, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsSection(
    BuildContext context,
    String title,
    List<_SettingData> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translateText(context, title),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: darkText,
          ),
        ),
        const SizedBox(height: 9),
        _card(
          child: Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                _SettingRow(item: items[i]),
                if (i < items.length - 1)
                  const Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 12,
                    color: Color(0xFFF1F2F5),
                  ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _card({required Widget child, double? height}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: cardBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x08000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _PremiumBadge extends StatelessWidget {
  const _PremiumBadge();
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
    decoration: BoxDecoration(
      color: const Color(0xFFF1ECFF),
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.workspace_premium_rounded,
          size: 14,
          color: SettingsScreen.primary,
        ),
        SizedBox(width: 4),
        Text(
          'Premium',
          style: TextStyle(
            fontSize: 11,
            color: SettingsScreen.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class _SettingData {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool danger;
  const _SettingData(
    this.icon,
    this.title,
    this.subtitle, {
    this.danger = false,
  });
}

class _SettingRow extends StatelessWidget {
  final _SettingData item;
  const _SettingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.danger
        ? const Color(0xFFE11D48)
        : SettingsScreen.primary;
    return InkWell(
      onTap: () => _handleTap(context),
      child: SizedBox(
        height: 72,
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.danger
                    ? const Color(0xFFFFEFF3)
                    : const Color(0xFFF1EEFF),
                shape: BoxShape.circle,
              ),
              child: Icon(item.icon, size: 22, color: color),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translateText(context, item.title),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.title == 'Language'
                        ? translateText(
                            context,
                            appState.locale.languageCode == 'ar'
                                ? 'Arabic'
                                : 'English',
                          )
                        : translateText(context, item.subtitle),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: SettingsScreen.secondaryText,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            const Icon(
              Icons.chevron_right_rounded,
              size: 23,
              color: Color(0xFF354055),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleTap(BuildContext context) async {
    if (item.title == 'Notifications') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const NotificationSettingsPage(),
        ),
      );
      return;
    }
    if (item.title == 'Language') {
      final selectedLanguage = await showDialog<Locale>(
        context: context,
        builder: (dialogContext) {
          final currentLocale = appState.locale;
          return AlertDialog(
            title: Text(translateText(dialogContext, 'Language')),
            contentPadding: const EdgeInsets.symmetric(vertical: 8),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _languageOption(
                  dialogContext,
                  const Locale('en'),
                  'English',
                  currentLocale,
                ),
                _languageOption(
                  dialogContext,
                  const Locale('ar'),
                  'Arabic',
                  currentLocale,
                ),
              ],
            ),
          );
        },
      );
      if (selectedLanguage == null || !context.mounted) return;
      await appState.setLocale(selectedLanguage);
      appLocale.value = selectedLanguage;
      return;
    }
    if (!context.mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${item.title}: coming soon')));
  }

  Widget _languageOption(
    BuildContext context,
    Locale locale,
    String label,
    Locale currentLocale,
  ) {
    final selected = currentLocale.languageCode == locale.languageCode;
    return ListTile(
      title: Text(translateText(context, label)),
      trailing: selected
          ? const Icon(Icons.check_rounded, color: SettingsScreen.primary)
          : null,
      onTap: () => Navigator.of(context).pop(locale),
    );
  }
}
