import 'package:flutter/material.dart';

class LowStockAlertCard extends StatelessWidget {
  final String productName;
  final int remaining;
  final Function() refreshAlert;
  const LowStockAlertCard({
    super.key,
    required this.refreshAlert,
    required this.productName,
    required this.remaining,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFEE6C6)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.05),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.warning_rounded,
              color: const Color(0xFFFF9F43),
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تنبيه مخزون منخفض",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFFF9F43),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "مادة \"$productName\" قاربت على النفاد ($remaining قطع)",
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
          SizedBox(width: 12),
          InkWell(
            onTap: refreshAlert,
            child: Container(
              width: 58,
              height: 28,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Text(
                "تحديث",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Color(0xff6C63FF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NoLowStockCard extends StatelessWidget {
  const NoLowStockCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            blurRadius: 14,
            offset: const Offset(0, 6),
            color: Colors.black.withValues(alpha: 0.04),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            Icons.inventory_2_outlined,
            color: const Color(0xFF94A3B8),
            size: 20,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              "لا يوجد تنبيهات مخزون منخفض حالياً",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
