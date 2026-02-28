import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../models/home_models.dart';

class OrdersActivitySection extends StatelessWidget {
  const OrdersActivitySection({super.key, required this.activity});

  final List<ActivityPoint> activity;

  @override
  Widget build(BuildContext context) {
    final maxValue = activity
        .map((e) => e.value)
        .fold<int>(0, (p, c) => c > p ? c : p);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "نشاط الطلبات (ساعات)",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.06),
              ),
            ],
          ),
          child: SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: activity
                  .map(
                    (point) => Expanded(
                      child: ActivityBar(
                        value: point.value,
                        maxValue: maxValue,
                        label: point.hour,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class ActivityBar extends StatelessWidget {
  const ActivityBar({
    super.key,
    required this.value,
    required this.maxValue,
    required this.label,
  });

  final int value;
  final int maxValue;
  final String label;

  @override
  Widget build(BuildContext context) {
    final heightFactor = maxValue == 0 ? 0.0 : value / maxValue;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            value.toString(),
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FractionallySizedBox(
                heightFactor: heightFactor,
                child: Container(
                  width: 18,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
