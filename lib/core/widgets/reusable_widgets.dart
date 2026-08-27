import 'package:flutter/material.dart';
import 'package:my_plan/core/localization/app_localization.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.color = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(20)),
    this.boxShadow = const [
      BoxShadow(color: Color(0x0D0D1020), blurRadius: 18, offset: Offset(0, 6)),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        border: Border.all(color: const Color(0xFFEEF0F4)),
        boxShadow: boxShadow,
      ),
      child: child,
    );
  }
}

class AppNetworkImage extends StatelessWidget {
  static const Map<String, String> _fallbackAssetMap = {
    '1532550907401': 'assets/food/chicken.jpg',
    '1512058564366': 'assets/food/rice.jpg',
    '1525351484163': 'assets/food/egg.jpg',
    '1568702846914': 'assets/food/apple.jpg',
    '1560806887': 'assets/food/apple.jpg',
    '1490645935967': 'assets/food/salad.jpg',
    '1547592180': 'assets/food/salad.jpg',
  };

  final String url;
  final IconData fallback;
  final double width;
  final double height;
  final double radius;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.url,
    required this.fallback,
    required this.width,
    required this.height,
    this.radius = 10,
    this.fit = BoxFit.cover,
  });

  String get localFallback {
    for (final entry in _fallbackAssetMap.entries) {
      if (url.contains(entry.key)) {
        return entry.value;
      }
    }
    return 'assets/food/bread.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final asset = localFallback;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.asset(
        asset,
        width: width,
        height: height,
        fit: fit,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F2F6),
            child: Icon(fallback, color: const Color(0xFF77819A)),
          );
        },
      ),
    );
  }
}

class AppSectionHeader extends StatelessWidget {
  final String title;
  final String action;
  final VoidCallback? onAction;

  const AppSectionHeader({
    super.key,
    required this.title,
    required this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final actionText = Text(
      translateText(context, action),
      style: const TextStyle(
        color: Color(0xFF5B35F5),
        fontSize: 12,
        fontWeight: FontWeight.w700,
      ),
    );

    return Row(
      children: [
        Expanded(
          child: Text(
            translateText(context, title),
            style: const TextStyle(
              color: Color(0xFF17203A),
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        onAction == null
            ? actionText
            : GestureDetector(onTap: onAction, child: actionText),
      ],
    );
  }
}

class SmallStatus extends StatelessWidget {
  final String text;
  final Color background;
  final Color foreground;

  const SmallStatus({
    super.key,
    required this.text,
    required this.background,
    required this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: foreground,
          fontSize: 9,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
