import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';
import '../models/home_models.dart';

class PreparingOrdersSection extends StatelessWidget {
  const PreparingOrdersSection({super.key, required this.orders});

  final List<PreparingOrderData> orders;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "قيد التحضير",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text(
                "عرض الجدول",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
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
          child: orders.isEmpty
              ? Text(
                  "لا توجد طلبات قيد التحضير",
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                    fontWeight: FontWeight.w600,
                  ),
                )
              : Column(
                  children: orders
                      .map(
                        (order) => Padding(
                          padding: EdgeInsets.only(bottom: 12),
                          child: PreparingOrderRow(data: order),
                        ),
                      )
                      .toList(),
                ),
        ),
      ],
    );
  }
}

class PreparingOrderRow extends StatelessWidget {
  const PreparingOrderRow({super.key, required this.data});

  final PreparingOrderData data;

  @override
  Widget build(BuildContext context) {
    final color = data.minutesSince <= 15
        ? const Color(0xFFFF7A00)
        : const Color(0xFF6B7280);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.timer, color: color, size: 16),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              data.id,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          ),
          Text(
            "منذ ${data.minutesSince} دقيقة",
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
