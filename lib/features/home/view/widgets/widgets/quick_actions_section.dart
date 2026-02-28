import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../models/home_models.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key, required this.actions});

  final List<QuickActionData> actions;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إجراءات سريعة",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 12,
          children: actions
              .map((action) => QuickActionChip(data: action))
              .toList(),
        ),
      ],
    );
  }
}

class QuickActionChip extends StatelessWidget {
  const QuickActionChip({super.key, required this.data});

  final QuickActionData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 78,
      padding: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.05),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: data.color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          SizedBox(height: 6),
          Text(
            data.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF374151),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
