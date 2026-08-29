import 'package:flutter/material.dart';

class AppProgressHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String progress;
  final double value;

  const AppProgressHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.value,
  });

  static const Color primary = Color(0xFF5B35F5);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        13,
        20,
        10,
      ),
      child: Column(
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF85899D),
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                progress,
                style: const TextStyle(
                  color: primary,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 11),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: value.clamp(0.0, 1.0),
              minHeight: 5,
              backgroundColor:
                  const Color(0xFFEDE9FD),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}