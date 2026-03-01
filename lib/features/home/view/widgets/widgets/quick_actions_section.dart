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
        Row(
          children: actions
              .map(
                (action) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: QuickActionChip(data: action),
                  ),
                ),
              )
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
    final isPrimary = data.icon == Icons.add;
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isPrimary ? data.color : AppColors.white,
              borderRadius: BorderRadius.circular(26),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Icon(
              data.icon,
              color: isPrimary ? Colors.white : data.color,
              size: 22,
            ),
          ),
          SizedBox(height: 8),
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
