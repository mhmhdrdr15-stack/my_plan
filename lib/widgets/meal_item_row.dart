import 'package:flutter/material.dart';

import '../models/meal.dart';

class MealItemRow extends StatelessWidget {
  final MealItem item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback? onEditAmount;

  const MealItemRow({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    this.onEditAmount,
  });

  static const Color primary = Color(0xFF5B35F5);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: const Color(0xFFE7E7EF),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: SizedBox(
              width: 56,
              height: 56,
              child: Image.network(
                item.food.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (
                  context,
                  error,
                  stackTrace,
                ) {
                  return Container(
                    color: const Color(0xFFF1EDFF),
                    child: const Icon(
                      Icons.restaurant_rounded,
                      color: primary,
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.food.name,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.calories.round()} سعرة',
                  style: const TextStyle(
                    color: primary,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          _circleButton(
            icon: Icons.remove_rounded,
            onTap: onDecrease,
          ),
          GestureDetector(
            onTap: onEditAmount,
            child: SizedBox(
              width: 55,
              child: Text(
                '${item.amountInGrams.round()}غ',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
          _circleButton(
            icon: Icons.add_rounded,
            onTap: onIncrease,
          ),
        ],
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 29,
        height: 29,
        decoration: const BoxDecoration(
          color: Color(0xFFF0ECFF),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 15,
          color: primary,
        ),
      ),
    );
  }
}