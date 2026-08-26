import 'package:flutter/material.dart';
import 'app_localization.dart';

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

  String? get localFallback {
    if (url.contains('1532550907401')) return 'assets/food/chicken.jpg';
    if (url.contains('1512058564366')) return 'assets/food/rice.jpg';
    if (url.contains('1525351484163')) return 'assets/food/egg.jpg';
    if (url.contains('1568702846914') || url.contains('1560806887')) {
      return 'assets/food/apple.jpg';
    }
    if (url.contains('1490645935967') || url.contains('1547592180')) {
      return 'assets/food/salad.jpg';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final cacheWidth = width.isFinite
        ? (width * MediaQuery.devicePixelRatioOf(context)).round()
        : null;
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: cacheWidth,
        gaplessPlayback: true,
        filterQuality: FilterQuality.medium,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F2F6),
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          final asset = localFallback;
          return Container(
            width: width,
            height: height,
            color: const Color(0xFFF1F2F6),
            child: asset == null
                ? Icon(fallback, color: const Color(0xFF77819A))
                : Image.asset(asset, width: width, height: height, fit: fit),
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
