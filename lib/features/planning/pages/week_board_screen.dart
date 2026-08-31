import 'package:flutter/material.dart';
import 'package:my_plan/data/shared/models/weekly_plan.dart';

class WeekBoardScreen extends StatefulWidget {
  final WeeklyPlan initialPlan;

  const WeekBoardScreen({super.key, required this.initialPlan});

  @override
  State<WeekBoardScreen> createState() => _WeekBoardScreenState();
}

class _WeekBoardScreenState extends State<WeekBoardScreen> {
  late WeeklyPlan plan;

  @override
  void initState() {
    super.initState();
    plan = widget.initialPlan;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FB),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context, plan),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Color(0xFF18182B),
          ),
        ),
        title: const Text(
          'الأسبوع',
          style: TextStyle(
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
                child: Row(
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF5B35F5),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'مكتمل ${plan.assignments.length} من ${plan.totalSlots} خانات',
                        style: const TextStyle(
                          color: Color(0xFF18182B),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: plan.days.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final day = plan.days[index];
                    final assignments = plan.assignments
                        .where((assignment) => assignment.dayIndex == index)
                        .toList();

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE7E7EF)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            day,
                            style: const TextStyle(
                              color: Color(0xFF18182B),
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (assignments.isEmpty)
                            const Text(
                              'لا توجد وجبات مخصصة لهذا اليوم',
                              style: TextStyle(
                                color: Color(0xFF85899D),
                                fontSize: 12,
                              ),
                            )
                          else
                            ...assignments.map((assignment) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Row(
                                  children: [
                                    Text(
                                      assignment.mealType,
                                      style: const TextStyle(
                                        color: Color(0xFF5B35F5),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      assignment.template.name,
                                      style: const TextStyle(
                                        color: Color(0xFF18182B),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
