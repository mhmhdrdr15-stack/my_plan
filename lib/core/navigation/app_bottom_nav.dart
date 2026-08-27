import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onAdd;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
    required this.onAdd,
  });

  static const primary = Color(0xFF5B35F5);
  static const inactive = Color(0xFF68748E);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 12,
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 82,
          child: Row(
            children: [
              _item(Icons.home_rounded, 'Home', 'الرئيسية', 0, context),
              _item(Icons.assignment_outlined, 'Plan', 'الخطة', 1, context),
              Expanded(
                child: Center(
                  child: InkWell(
                    key: const ValueKey('app-nav-add'),
                    onTap: onAdd,
                    customBorder: const CircleBorder(),
                    child: Container(
                      width: 58,
                      height: 58,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [Color(0xFF6E48FF), primary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: const Icon(
                        Icons.add_rounded,
                        color: Colors.white,
                        size: 33,
                      ),
                    ),
                  ),
                ),
              ),
              _item(Icons.history_rounded, 'Log', 'السجل', 2, context),
              _item(Icons.bar_chart_rounded, 'Progress', 'التقدم', 3, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(
    IconData icon,
    String englishLabel,
    String arabicLabel,
    int index,
    BuildContext context,
  ) {
    final selected = currentIndex == index;
    final color = selected ? primary : inactive;
    final label = appText(context, englishLabel, arabicLabel);
    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          key: ValueKey('app-nav-$index'),
          onTap: () => onItemSelected(index),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: color),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
