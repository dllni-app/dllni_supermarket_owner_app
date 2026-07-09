import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
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

  bool get hasPrimaryAction =>
      status == OrderStatus.pending ||
      status == OrderStatus.preparing ||
      status == OrderStatus.readyForPickup;

  String get orderDelay {
    final parsedDate = _tryParseDate(order.updatedAt ?? order.createdAt);
    if (parsedDate == null) return 'غير محدد';

    final diffDate = DateTime.now().difference(parsedDate);
    if (diffDate.inDays != 0) return '${diffDate.inDays} يوم';
    if (diffDate.inHours != 0) return '${diffDate.inHours} ساعة';
    if (diffDate.inMinutes != 0) return '${diffDate.inMinutes} دقيقة';
    return 'الآن';
  }

  String get stageLabel => switch (status) {
    OrderStatus.pending => 'بانتظار قبول الطلب من المتجر',
    OrderStatus.accepted => 'المندوب في الطريق',
    OrderStatus.preparing => 'يتم تجهيز المنتجات',
    OrderStatus.readyForPickup => 'بانتظار تسليم الطلب للمندوب',
    OrderStatus.pickedUp => 'تم تسليم الطلب للمندوب',
    OrderStatus.completed => 'تم تسليم الطلب',
    OrderStatus.rejected => 'تم رفض الطلب',
    OrderStatus.cancelled => 'تم إلغاء الطلب',
  };

  Color get statusColor => switch (status) {
    OrderStatus.completed ||
    OrderStatus.readyForPickup => const Color(0xFF24B364),
    OrderStatus.accepted || OrderStatus.pickedUp => const Color(0xFF2563EB),
    OrderStatus.preparing => AppColors.accent,
    OrderStatus.rejected || OrderStatus.cancelled => const Color(0xFFEF4444),
    _ => AppColors.primary,
  };

  IconData get statusIcon => switch (status) {
    OrderStatus.pending => Icons.fiber_manual_record_rounded,
    OrderStatus.accepted => Icons.verified_rounded,
    OrderStatus.preparing => Icons.inventory_2_rounded,
    OrderStatus.readyForPickup => Icons.check_circle_rounded,
    OrderStatus.pickedUp => Icons.local_shipping_rounded,
    OrderStatus.completed => Icons.done_all_rounded,
    OrderStatus.rejected || OrderStatus.cancelled => Icons.cancel_rounded,
  };

  String get statusLabel => switch (status) {
    OrderStatus.pending => 'طلب جديد',
    OrderStatus.accepted => 'تم قبول الطلب',
    OrderStatus.preparing => 'قيد التحضير',
    OrderStatus.readyForPickup => 'جاهز للتسليم',
    OrderStatus.pickedUp => 'قيد التسليم',
    OrderStatus.completed => 'مكتمل',
    OrderStatus.rejected => 'مرفوض',
    OrderStatus.cancelled => 'ملغي',
  };

  String get totalAmountText => '${_formatMoney(order.totalAmount)} ل.س';

  @override
  Widget build(BuildContext context) {
    final items = order.items ?? const <String>[];

    return InkWell(
      onTap: () => _openDetails(context),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: statusColor.withValues(alpha: .14)),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 8),
              blurRadius: 24,
              spreadRadius: -14,
              color: Color(0x33000000),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AppText(
                        'رقم الطلب',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Directionality(
                        textDirection: TextDirection.ltr,
                        child: AppText(
                          '#${order.orderNumber ?? '-'}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusBadge(
                  label: statusLabel,
                  icon: statusIcon,
                  color: statusColor,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppText(
                    totalAmountText,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                  ),
                ),
                _MetaChip(
                  icon: Icons.access_time_rounded,
                  label: 'منذ $orderDelay',
                  color: const Color(0xFF6B7280),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: .06),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, size: 18, color: statusColor),
                  const SizedBox(width: 8),
                  Expanded(
                    child: AppText(
                      stageLabel,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (items.isNotEmpty) ...[
              const SizedBox(height: 12),
              _ItemsPreview(
                items: items,
                availableItems: order.availableItems ?? const <bool>[],
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                _MetaChip(
                  icon: Icons.inventory_2_outlined,
                  label: '${items.length} منتجات',
                  color: const Color(0xFF4B5563),
                ),
                const SizedBox(width: 8),
                _MetaChip(
                  icon: Icons.payments_outlined,
                  label: 'نقدي',
                  color: const Color(0xFF4B5563),
                ),
              ],
            ),
            if (hasPrimaryAction) ...[
              const SizedBox(height: 14),
              _ActionSection(
                status: status,
                onAcceptTap: onAcceptTap,
                onRejectTap: onRejectTap,
                onOpenDetailsTap: () => _openDetails(context),
                onCourierHandoverTap: onCourierHandoverTap,
                isCourierHandoverLoading: isCourierHandoverLoading,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatMoney(String? value) {
    final amount = double.tryParse(value ?? '');
    if (amount == null) return value ?? '0';
    if (amount == amount.roundToDouble()) return amount.toStringAsFixed(0);
    return amount.toStringAsFixed(2);
  }

  void _openDetails(BuildContext context) {
    onViewDetailsTap();
    final id = order.id;
    if (id == null) return;
    context.pushRoute('/orders/order_details', arguments: id);
  }

  DateTime? _tryParseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    return DateTime.tryParse(value) ??
        DateTime.tryParse(value.replaceFirst(' ', 'T'));
  }
}

enum OrderStatus {
  pending,
  accepted,
  preparing,
  readyForPickup,
  pickedUp,
  completed,
  rejected,
  cancelled,
}

enum PaymentWay { cash }

class _ActionSection extends StatelessWidget {
  final OrderStatus status;
  final VoidCallback onAcceptTap;
  final VoidCallback onRejectTap;
  final VoidCallback onOpenDetailsTap;
  final VoidCallback onCourierHandoverTap;
  final bool isCourierHandoverLoading;

  const _ActionSection({
    required this.status,
    required this.onAcceptTap,
    required this.onRejectTap,
    required this.onOpenDetailsTap,
    required this.onCourierHandoverTap,
    required this.isCourierHandoverLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (status == OrderStatus.pending) {
      return Row(
        children: [
          Expanded(
            child: AppButton(title: 'قبول الطلب', onTap: onAcceptTap),
          ),
          const SizedBox(width: 12),
          AppOutlinedButton(
            color: const Color(0xFFFF4C51),
            title: 'رفض',
            onTap: onRejectTap,
          ),
        ],
      );
    }

    if (status == OrderStatus.readyForPickup) {
      if (isCourierHandoverLoading) {
        return const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2.5),
          ),
        );
      }

      return SizedBox(
        width: context.width,
        child: AppButton(
          color: const Color(0xFF24B364),
          title: 'تسليم للمندوب',
          onTap: onCourierHandoverTap,
        ),
      );
    }

    return SizedBox(
      width: context.width,
      child: AppButton(
        icon: Icons.arrow_forward_rounded,
        title: 'عرض التفاصيل',
        onTap: onOpenDetailsTap,
      ),
    );
  }
}

class _ItemsPreview extends StatelessWidget {
  final List<String> items;
  final List<bool> availableItems;

  const _ItemsPreview({required this.items, required this.availableItems});

  @override
  Widget build(BuildContext context) {
    final visibleItems = items.take(3).toList();
    final hiddenCount = items.length - visibleItems.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        children: [
          ...List.generate(
            visibleItems.length,
            (index) => Padding(
              padding: EdgeInsets.only(
                bottom: index == visibleItems.length - 1 && hiddenCount == 0
                    ? 0
                    : 8,
              ),
              child: _RequirementRow(
                label: '${index + 1}- ${visibleItems[index]}',
                isAvailable: index < availableItems.length
                    ? availableItems[index]
                    : true,
              ),
            ),
          ),
          if (hiddenCount > 0)
            Align(
              alignment: Alignment.centerRight,
              child: AppText(
                '+ $hiddenCount منتجات أخرى',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          AppText(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _RequirementRow extends StatelessWidget {
  final String label;
  final bool isAvailable;

  const _RequirementRow({required this.label, required this.isAvailable});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
          color: isAvailable
              ? const Color(0xFF24B364)
              : const Color(0xFFEF4444),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: AppText(
            label,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xE52F2B3D),
              fontSize: 12,
              height: 1.333,
            ),
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StatusBadge({
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          AppText(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
