import 'package:flutter/material.dart';

import '../models/food.dart';

class FoodCard extends StatelessWidget {
  final Food food;
  final bool selected;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.food,
    required this.selected,
    required this.onTap,
  });

  static const Color primary = Color(0xFF5B35F5);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        splashColor: primary.withValues(alpha: 0.06),
        highlightColor: primary.withValues(alpha: 0.03),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21),
            border: Border.all(
              color: selected
                  ? primary
                  : const Color(0xFFE7E7EF),
              width: selected ? 1.5 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _image(),
              const SizedBox(height: 10),
              Text(
                food.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF18182B),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                '${food.caloriesPer100g.round()} سعرة / 100غ',
                style: const TextStyle(
                  color: Color(0xFF85899D),
                  fontSize: 9,
                ),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  _macroBadge(
                    'P',
                    food.proteinPer100g.round(),
                  ),
                  const SizedBox(width: 4),
                  _macroBadge(
                    'C',
                    food.carbsPer100g.round(),
                  ),
                  const SizedBox(width: 4),
                  _macroBadge(
                    'F',
                    food.fatPer100g.round(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _image() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: 100,
            child: Image.network(
              food.imageUrl,
              fit: BoxFit.cover,
              filterQuality: FilterQuality.medium,
              loadingBuilder: (
                context,
                child,
                loadingProgress,
              ) {
                if (loadingProgress == null) {
                  return child;
                }

                return Container(
                  color: const Color(0xFFF1EDFF),
                  alignment: Alignment.center,
                  child: const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: primary,
                    ),
                  ),
                );
              },
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: const Color(0xFFF1EDFF),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.restaurant_rounded,
                    color: primary,
                    size: 28,
                  ),
                );
              },
            ),
          ),
        ),
        if (selected)
          Positioned(
            top: 8,
            right: 8,
            child: AnimatedScale(
              scale: selected ? 1 : 0.7,
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: Container(
                width: 29,
                height: 29,
                decoration: BoxDecoration(
                  color: primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 17,
                ),
              ),
            ),
          ),
        Positioned(
          top: 8,
          left: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 7,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.42),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              food.category,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _macroBadge(
    String label,
    int value,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F3FF),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label $valueغ',
        style: const TextStyle(
          color: primary,
          fontSize: 8,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}