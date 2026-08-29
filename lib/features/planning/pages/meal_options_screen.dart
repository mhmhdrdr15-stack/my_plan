import 'package:flutter/material.dart';
import 'package:my_plan/data/shared/models/meal_template.dart';
import 'package:my_plan/data/shared/models/user_goal_profile.dart';
import 'package:my_plan/data/shared/models/weekly_plan.dart';

class MealOptionsScreen extends StatefulWidget {
  final String mealType;
  final String time;
  final WeeklyPlan plan;
  final UserGoalProfile goalProfile;
  final List<MealTemplate> templates;

  const MealOptionsScreen({
    super.key,
    required this.mealType,
    required this.time,
    required this.plan,
    required this.goalProfile,
    required this.templates,
  });

  @override
  State<MealOptionsScreen> createState() => _MealOptionsScreenState();
}

class _MealOptionsScreenState extends State<MealOptionsScreen> {
  late List<MealTemplate> _templates;

  @override
  void initState() {
    super.initState();
    _templates = List<MealTemplate>.from(widget.templates);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF18182B)),
        ),
        title: Text(
          widget.mealType,
          style: const TextStyle(
            color: Color(0xFF18182B),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'الوقت: ${widget.time}',
                  style: const TextStyle(
                    color: Color(0xFF696B7D),
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: _templates.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE7E7EF)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template.name,
                                  style: const TextStyle(
                                    color: Color(0xFF18182B),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  template.meal.name,
                                  style: const TextStyle(
                                    color: Color(0xFF85899D),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _templates.removeAt(index);
                              });
                            },
                            icon: const Icon(Icons.delete_outline_rounded),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF5B35F5),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context, _templates),
                  child: const Text(
                    'حفظ الخيارات',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
