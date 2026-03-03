import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_shadows.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/utils/app_svgs.dart';
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
  final num totalSales;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
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
                height: 1.5,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: Color(0xFFF3F4F6)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [AppShadows.shadow],
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

        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6100C6), Color(0xFF1E2A78)],
              stops: [.03, 0.4],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0x33EAB308)),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 8),
                blurRadius: 32,
                color: const Color(0x33000000),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  spacing: 4,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "إجمالي المبيعات",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFFFEEFF),
                        height: 1.333,
                      ),
                    ),
                    Row(
                      children: [
                        AppText(
                          totalSales.formatWithComma(),
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.75,
                            height: 1.2,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                        AppText(
                          "ل.س",
                          style: TextStyle(
                            color: Color(0xFFFACC15),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      spacing: 8,
                      children: [
                        _SellingIndicator(percent: 15),
                        AppText(
                          "مقارنة بالأمس",
                          style: TextStyle(
                            color: const Color(0x7FFFEEFF),
                            fontSize: 12,
                            height: 1.333,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              AppImage.asset(AppImages.databases, size: 60),
            ],
          ),
        ),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: _OverviewStatCard(
                backgroundColor: const Color(0x333B82F6),
                foregroundColor: const Color(0xFF60A5FA),
                icon: FontAwesomeIcons.receipt,
                label: "طلبات جديدة",
                value: 24,
              ),
            ),
            Expanded(
              child: _OverviewStatCard(
                backgroundColor: const Color(0x33F97316),
                foregroundColor: const Color(0xFFFB923C),
                icon: FontAwesomeIcons.fireBurner,
                label: "قيد التحضير",
                value: 8,
              ),
            ),
            Expanded(
              child: _OverviewStatCard(
                backgroundColor: const Color(0x3322C55E),
                foregroundColor: const Color(0xFF4ADE80),
                icon: FontAwesomeIcons.checkDouble,
                label: "مكتمل",
                value: 156,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OverviewStatCard extends StatelessWidget {
  const _OverviewStatCard({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.icon,
    required this.value,
    required this.label,
  });
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border(
            bottom: BorderSide(
              width: 2,
              color: backgroundColor.withValues(alpha: 1),
            ),
            top: BorderSide(color: const Color(0x33EAB308)),
            left: BorderSide(color: const Color(0x33EAB308)),
            right: BorderSide(color: const Color(0x33EAB308)),
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 32,
              offset: const Offset(0, 8),
              color: const Color(0x33000000),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: foregroundColor, size: 16),
            ),
            SizedBox(height: 8),
            AppText(
              value.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF2D2339),
                height: 1.333,
              ),
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: Color(0xFF9CA3AF),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SellingIndicator extends StatelessWidget {
  final num percent;

  const _SellingIndicator({required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: percent >= 0 ? const Color(0x3322C55E) : const Color(0x33EF4444),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        spacing: 4,
        children: [
          AppImage.asset(AppSvgs.up, size: 13),
          AppText(
            "${percent > 0 ? "+$percent" : percent}%",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 12,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}
