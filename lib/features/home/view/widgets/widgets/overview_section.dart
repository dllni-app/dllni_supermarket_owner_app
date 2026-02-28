import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../models/home_models.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({
    super.key,
    required this.stats,
    required this.dateLabel,
    required this.totalSales,
  });

  final List<OverviewStatData> stats;
  final String dateLabel;
  final num? totalSales;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "نظرة عامة اليوم",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            Text(
              dateLabel,
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          padding: EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2A78), Color(0xFF27359C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                blurRadius: 18,
                offset: const Offset(0, 8),
                color: Colors.black.withOpacity(0.08),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "إجمالي المبيعات",
                style: TextStyle(fontSize: 12, color: Color(0xFFE5E7EB)),
              ),
              SizedBox(height: 6),
              Text(
                "${(totalSales ?? 0).toStringAsFixed(0)} ل.س",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Text(
                "٪15+ مقارنة الشهر الماضي",
                style: TextStyle(fontSize: 11, color: Color(0xFFBBF7D0)),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: stats
              .map(
                (item) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: OverviewStatCard(data: item),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class OverviewStatCard extends StatelessWidget {
  const OverviewStatCard({super.key, required this.data});

  final OverviewStatData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 6),
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: data.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(data.icon, color: data.color, size: 18),
          ),
          SizedBox(height: 8),
          Text(
            data.value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          SizedBox(height: 4),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 11,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
