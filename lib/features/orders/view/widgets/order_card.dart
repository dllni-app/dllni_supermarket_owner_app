import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_buttons.dart';
import '../../data/models/get_orders_model.dart';

class OrderCard extends StatelessWidget {
  final OrderStatus status;
  final GetOrdersModelDataItem order;
  final void Function() onAcceptTap;
  final void Function() onRejectTap;
  final void Function() onViewDetailsTap;
  final void Function() onCourierHandoverTap;
  final bool isCourierHandoverLoading;

  const OrderCard({
    super.key,
    required this.status,
    required this.order,
    required this.onAcceptTap,
    required this.onRejectTap,
    required this.onViewDetailsTap,
    required this.onCourierHandoverTap,
    this.isCourierHandoverLoading = false,
  });

  bool get canAccept => status == OrderStatus.pending;
  bool get canReject => status == OrderStatus.pending;
  bool get canCourierHandover =>
      status == OrderStatus.accepted ||
      status == OrderStatus.preparing ||
      status == OrderStatus.readyForPickup;

  String get statusLabel => switch (status) {
        OrderStatus.pending => 'Pending',
        OrderStatus.accepted => 'Accepted',
        OrderStatus.preparing => 'Preparing',
        OrderStatus.readyForPickup => 'Ready',
        OrderStatus.pickedUp => 'Picked up',
        OrderStatus.completed => 'Completed',
        OrderStatus.cancelled => 'Cancelled',
        OrderStatus.rejected => 'Rejected',
        OrderStatus.unknown => 'Unknown',
      };

  bool get hasUnavailableItems =>
      (order.availableItems ?? const <bool>[]).any((value) => value == false);

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? const <String>[];
    final availableItems = order.availableItems ?? const <bool>[];
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: AppText.bodyMedium('#${order.orderNumber ?? order.id}', fontWeight: FontWeight.w700)),
              AppText.labelSmall(statusLabel, fontWeight: FontWeight.w700),
            ],
          ),
          const SizedBox(height: 8),
          AppText.labelMedium('Supermarket customer', color: const Color(0xFF6B7280)),
          const SizedBox(height: 8),
          AppText.bodyMedium('${order.totalAmount ?? '0'} SYP', fontWeight: FontWeight.w700),
          const SizedBox(height: 12),
          ...List.generate(items.length, (index) {
            final available = availableItems.length > index ? availableItems[index] : true;
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    available ? Icons.check_circle : Icons.warning_amber_rounded,
                    size: 16,
                    color: available ? const Color(0xFF24B364) : const Color(0xFFFF4C51),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: AppText.labelMedium('${index + 1}- ${items[index]}')),
                ],
              ),
            );
          }),
          if (hasUnavailableItems)
            AppText.labelSmall('Some items are not available in stock', color: const Color(0xFFFF4C51), fontWeight: FontWeight.w700),
          const SizedBox(height: 12),
          _actions(),
        ],
      ),
    );
  }

  Widget _actions() {
    if (canAccept || canReject) {
      return Row(
        children: [
          Expanded(child: AppButton(title: 'Accept', onTap: onAcceptTap)),
          const SizedBox(width: 12),
          AppOutlinedButton(color: const Color(0xFFFF4C51), title: 'Reject', onTap: onRejectTap),
        ],
      );
    }
    if (canCourierHandover) {
      if (isCourierHandoverLoading) {
        return const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5)));
      }
      return AppButton(color: const Color(0xFF24B364), title: 'Courier handover', onTap: onCourierHandoverTap);
    }
    return AppButton(icon: Icons.arrow_forward_rounded, title: 'Details', onTap: onViewDetailsTap);
  }
}

enum OrderStatus { pending, accepted, preparing, readyForPickup, pickedUp, completed, cancelled, rejected, unknown }

enum PaymentWay { cash }
