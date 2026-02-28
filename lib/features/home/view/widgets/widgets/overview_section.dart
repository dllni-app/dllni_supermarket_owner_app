import 'package:common_package/theme/text_theme.dart';
import 'package:common_package/widgets/app_text.dart';
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
    final width = MediaQuery.sizeOf(context).width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "نظرة عامة اليوم",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                height: 1.333,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(8)),
                border: Border.all(color: Color(0xFFF3F4F6)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 2,
                    color: Color(0x0D000000),
                  ),
                ],
              ),
              child: Text(
                dateLabel,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 12),
        Container(
          width: width,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1E2A78), Color(0xFF27359C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Color(0x33EAB308)),
            boxShadow: [
              BoxShadow(
                blurRadius: 32,
                offset: const Offset(0, 8),
                color: Color(0x33000000),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              AppText(
                "إجمالي المبيعات",
                style: textTheme.labelLarge!.copyWith(
                  color: Color(0xFFFFEEFF),
                  fontWeight: FontWeight.w400,
                ),
              ),
              Row(
                spacing: 10,
                children: [
                  AppText(
                    (totalSales ?? 0).toStringAsFixed(0),
                    style: textTheme.displaySmall!.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFFFFFFF),
                      letterSpacing: .75,
                    ),
                  ),
                  AppText(
                    "ل.س",
                    style: textTheme.labelLarge!.copyWith(
                      color: Color(0xFFFACC15),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                spacing: 8,
                children: [
                  Container(
                    child: AppText(
                      "",
                      style: TextStyle(fontSize: 11, color: Color(0xFFBBF7D0)),
                    ),
                  ),
                  AppText(
                    "مقارنة بالأمس",
                    style: TextStyle(fontSize: 12, color: Color(0xFFFFEEFF)),
                  ),
                ],
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
