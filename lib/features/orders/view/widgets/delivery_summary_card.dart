import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../data/models/delivery_summary_model.dart';

class DeliverySummaryCard extends StatelessWidget {
  const DeliverySummaryCard({super.key, required this.summary});

  final DeliverySummaryModel summary;

  @override
  Widget build(BuildContext context) {
    if (!summary.enabled) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.onPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText.headlineMedium(
                  'حالة التوصيل',
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (summary.statusLabelAr != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xffEEF2FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    summary.statusLabelAr!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xff1E2A78),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          if (summary.timeline.isNotEmpty) ...[
            const SizedBox(height: 16),
            ...summary.timeline.map((stage) {
              final color = stage.completed
                  ? const Color(0xff10B981)
                  : stage.active
                      ? const Color(0xff1E2A78)
                      : const Color(0xffD1D5DB);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      stage.completed
                          ? Icons.check_circle_rounded
                          : stage.active
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                      color: color,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stage.label,
                            style: TextStyle(
                              fontWeight:
                                  stage.active ? FontWeight.w700 : FontWeight.w500,
                            ),
                          ),
                          if (stage.timestamp != null)
                            Text(
                              _formatTime(stage.timestamp!),
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xff6B7280),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
          if (summary.cancellationReason != null &&
              summary.cancellationReason!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'سبب الإلغاء: ${summary.cancellationReason}',
              style: const TextStyle(color: Color(0xffDC2626), fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTime(String raw) {
    try {
      final dt = DateTime.parse(raw).toLocal();
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return raw;
    }
  }
}
