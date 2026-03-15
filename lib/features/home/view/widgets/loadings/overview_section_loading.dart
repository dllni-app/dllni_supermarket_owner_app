import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../core/themes/app_gradients.dart';
import '../overview_state_card.dart';
import '../selling_indicator.dart';

class OverviewSectionLoading extends StatelessWidget {
  const OverviewSectionLoading({super.key, this.showQuickPoints = true});
  final bool showQuickPoints;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        spacing: 12,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppGradients.gradient,
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
                            12450.formatWithComma(),
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
                          SellingIndicator(percent: 15),
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
              ],
            ),
          ),
          if (showQuickPoints)
            Row(
              spacing: 12,
              children: [
                Expanded(
                  child: OverviewStatCard(
                    backgroundColor: const Color(0x333B82F6),
                    foregroundColor: const Color(0xFF60A5FA),
                    icon: FontAwesomeIcons.receipt,
                    label: "طلبات جديدة",
                    value: 24,
                  ),
                ),
                Expanded(
                  child: OverviewStatCard(
                    backgroundColor: const Color(0x33F97316),
                    foregroundColor: const Color(0xFFFB923C),
                    icon: FontAwesomeIcons.fireBurner,
                    label: "قيد التحضير",
                    value: 8,
                  ),
                ),
                Expanded(
                  child: OverviewStatCard(
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
      ),
    );
  }
}
