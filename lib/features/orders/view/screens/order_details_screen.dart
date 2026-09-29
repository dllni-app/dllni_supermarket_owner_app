import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/store_owner_operations_service.dart';
import 'package:common_package/helpers/dio_network.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../data/models/get_order_details_model.dart';
import '../../domain/usecases/get_order_details_use_case.dart';
import '../manager/bloc/orders_bloc.dart';
import '../widgets/order_details_app_bar.dart';

String _formatDurationArabic(int minutes) {
  if (minutes < 0) return '';
  if (minutes < 60) return '$minutes دقيقة';
  if (minutes < 1440) return '${(minutes / 60).floor()} ساعة';
  return '${(minutes / 1440).floor()} يوم';
}

String _formatMoney(String? value) {
  final amount = double.tryParse(value ?? '');
  if (amount == null) return _safeText(value, fallback: '0');
  if (amount == amount.roundToDouble()) return amount.toStringAsFixed(0);
  return amount.toStringAsFixed(2);
}

String _modifierLabel(dynamic modifier) {
  if (modifier is Map) {
    final group = _safeText(modifier['groupName'], fallback: '');
    final name = _safeText(modifier['name'], fallback: '');
    final price = double.tryParse('${modifier['price'] ?? ''}') ?? 0;
    final title = group.isEmpty ? name : '$group: $name';
    return price > 0
        ? '$title (+${_formatMoney('$price')} ل.س)'
        : title;
  }
  return 'خيار #${_safeText(modifier)}';
}

String _formatTime(String? value) {
  final date = _parseDate(value);
  if (date == null) return 'غير محدد';
  return DateFormat.jm(
    'ar_DZ',
  ).format(date).replaceAll('مساءً', 'م').replaceAll('صباحاً', 'ص');
}

DateTime? _parseDate(String? value) {
  if (value == null || value.trim().isEmpty) return null;
  return DateTime.tryParse(value) ??
      DateTime.tryParse(value.replaceFirst(' ', 'T'));
}

String _safeText(dynamic value, {String fallback = '-'}) {
  if (value == null) return fallback;
  final text = value.toString().trim();
  return text.isEmpty || text == 'null' ? fallback : text;
}

Color _statusColor(String? status) {
  return switch (status) {
    'completed' || 'delivered' => const Color(0xFF24B364),
    'ready_for_pickup' => const Color(0xFF24B364),
    'accepted' || 'picked_up' || 'out_for_delivery' => const Color(0xFF2563EB),
    'preparing' => AppColors.accent,
    'rejected' || 'cancelled' || 'canceled' => const Color(0xFFEF4444),
    _ => AppColors.primary,
  };
}

IconData _statusIcon(String? status) {
  return switch (status) {
    'completed' || 'delivered' => Icons.done_all_rounded,
    'ready_for_pickup' => Icons.check_circle_rounded,
    'accepted' => Icons.verified_rounded,
    'picked_up' || 'out_for_delivery' => Icons.local_shipping_rounded,
    'preparing' => Icons.inventory_2_rounded,
    'rejected' || 'cancelled' || 'canceled' => Icons.cancel_rounded,
    _ => Icons.fiber_manual_record_rounded,
  };
}

class OrderDetailsLoading extends StatelessWidget {
  const OrderDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: const [
          _LoadingBlock(height: 174),
          SizedBox(height: 13),
          _LoadingBlock(height: 176),
          SizedBox(height: 13),
          _LoadingBlock(height: 220),
          SizedBox(height: 13),
          _LoadingBlock(height: 190),
        ],
      ),
    );
  }
}

@AutoRoutePage(path: '/orders/order_details')
class OrderDetailsScreen extends StatelessWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersBloc>()
        ..add(
          GetOrderDetailsEvent(params: GetOrderDetailsParams(orderId: orderId)),
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F6FA),
        body: Column(
          children: [
            OrderDetailsAppBar(title: 'تفاصيل الطلب', productId: '$orderId'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: BlocConsumer<OrdersBloc, OrdersState>(
                  listener: (context, state) {},
                  buildWhen: (previous, current) =>
                      previous.orderDetailsStatus != current.orderDetailsStatus,
                  builder: (context, state) {
                    if (state.orderDetailsStatus == BlocStatus.loading) {
                      return const OrderDetailsLoading();
                    }

                    if (state.orderDetailsStatus == BlocStatus.failed) {
                      return SizedBox(
                        width: context.width,
                        height: 250,
                        child: Center(
                          child: FailureWidget(
                            message: state.errorMessage.toString(),
                            onRetry: () {
                              context.read<OrdersBloc>().add(
                                GetOrderDetailsEvent(
                                  params: GetOrderDetailsParams(
                                    orderId: orderId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }

                    if (state.orderDetailsStatus == BlocStatus.success) {
                      final data = state.orderDetails?.data;
                      if (data == null) return const SizedBox();

                      return Column(
                        children: [
                          _OrderStatusCard(data: data),
                          _OrderManagementActions(
                            orderId: orderId,
                            data: data,
                          ),
                          const SizedBox(height: 13),
                          _OrderInfoCard(data: data),
                          const SizedBox(height: 13),
                          _CustomerCard(
                            customer: data.customer,
                            fulfillmentLabel:
                                data.fulfillmentTypeLabel ??
                                (data.fulfillmentType == 'pickup'
                                    ? 'استلام من المتجر'
                                    : 'توصيل'),
                          ),
                          if (data.store != null) ...[
                            const SizedBox(height: 13),
                            _StoreCard(store: data.store!),
                          ],
                          const SizedBox(height: 13),
                          _OrderDetailsCard(orderItems: data.items ?? const []),
                          const SizedBox(height: 13),
                          _BillCard(
                            price: data.subtotal,
                            discount: data.discountAmount,
                            fees: data.serviceFee,
                            deliveryFee: data.deliveryFee,
                            totalPrice: data.totalAmount,
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final String? price;
  final String? discount;
  final String? fees;
  final String? deliveryFee;
  final String? totalPrice;

  const _BillCard({
    required this.price,
    required this.discount,
    required this.fees,
    required this.deliveryFee,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SectionTitle(
            title: 'ملخص الدفع',
            icon: Icons.account_balance_wallet_rounded,
            color: Color(0xFF24B364),
          ),
          const SizedBox(height: 16),
          _PaymentRow(
            label: 'تكلفة المنتجات',
            value: '${_formatMoney(price)} ل.س',
          ),
          const SizedBox(height: 10),
          _PaymentRow(
            label: 'الخصم',
            value: '- ${_formatMoney(discount)} ل.س',
            valueColor: const Color(0xFF16A34A),
          ),
          const SizedBox(height: 10),
          _PaymentRow(
            label: 'تكلفة الخدمة',
            value: '+ ${_formatMoney(fees)} ل.س',
            valueColor: const Color(0xFFEF4444),
          ),
          const SizedBox(height: 10),
          _PaymentRow(
            label: 'رسوم التوصيل',
            value: '+ ${_formatMoney(deliveryFee)} ل.س',
            valueColor: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: _PaymentRow(
              label: 'الإجمالي',
              value: '${_formatMoney(totalPrice)} ل.س',
              isTotal: true,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFDCFCE7),
                  child: const Icon(
                    Icons.payments_rounded,
                    size: 14,
                    color: Color(0xFF16A34A),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    'طريقة الدفع غير متوفرة في بيانات الطلب',
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final GetOrderDetailsModelDataCustomer? customer;
  final String fulfillmentLabel;

  const _CustomerCard({
    required this.customer,
    required this.fulfillmentLabel,
  });

  @override
  Widget build(BuildContext context) {
    final phone = _safeText(customer?.phone, fallback: '');

    return _SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'معلومات الزبون',
            icon: Icons.person_rounded,
            trailing: fulfillmentLabel,
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: context.primary.withValues(alpha: .10),
                child: Icon(Icons.person_rounded, color: context.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      _safeText(customer?.name, fallback: 'زبون السوبرماركت'),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        height: 1.42,
                      ),
                    ),
                    const SizedBox(height: 6),
                    _InlineInfo(
                      icon: Icons.phone_rounded,
                      value: phone.isEmpty ? 'رقم الهاتف غير متوفر' : phone,
                    ),
                    const SizedBox(height: 5),
                    _InlineInfo(
                      icon: Icons.email_outlined,
                      value: _safeText(
                        customer?.email,
                        fallback: 'البريد الإلكتروني غير متوفر',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: () async {
              if (phone.isEmpty) {
                AppToast.showToast(
                  context: context,
                  message: 'رقم الهاتف غير متوفر',
                  type: ToastificationType.warning,
                );
                return;
              }

              final canLaunch = await canLaunchUrlString('tel:$phone');
              if (!context.mounted) return;

              if (!canLaunch) {
                await Clipboard.setData(ClipboardData(text: phone));
                if (!context.mounted) return;
                AppToast.showToast(
                  context: context,
                  message: 'تم نسخ رقم الهاتف',
                  type: ToastificationType.info,
                );
                return;
              }

              await launchUrlString('tel:$phone');
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.phone_rounded,
                    size: 17,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'اتصال بالزبون',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoTile({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 15, color: const Color(0xFF6B7280)),
              const SizedBox(width: 6),
              Expanded(
                child: AppText(
                  title,
                  textAlign: TextAlign.start,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          AppText(
            value,
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineInfo extends StatelessWidget {
  final IconData icon;
  final String value;

  const _InlineInfo({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: const Color(0xFF6B7280)),
        const SizedBox(width: 6),
        Expanded(
          child: AppText(
            value,
            textAlign: TextAlign.start,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w600,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class _LoadingBlock extends StatelessWidget {
  final double height;

  const _LoadingBlock({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
      ),
    );
  }
}

class _MiniBadge extends StatelessWidget {
  final String label;

  const _MiniBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6),
        borderRadius: BorderRadius.circular(8),
      ),
      child: AppText(
        label,
        style: const TextStyle(
          color: Color(0xFF4B5563),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  final List<GetOrderDetailsModelDataItemsItem> orderItems;

  const _OrderDetailsCard({required this.orderItems});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'تفاصيل المنتجات',
            icon: Icons.shopping_bag_rounded,
            trailing: '${orderItems.length} منتجات',
          ),
          const SizedBox(height: 16),
          if (orderItems.isEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(14),
              ),
              child: AppText(
                'لا توجد منتجات في هذا الطلب',
                style: const TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (_, index) => _ProductDetails(
                orderItem: orderItems[index],
                isLast: index == orderItems.length - 1,
              ),
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemCount: orderItems.length,
            ),
        ],
      ),
    );
  }
}

class _OrderInfoCard extends StatelessWidget {
  final GetOrderDetailsModelData data;

  const _OrderInfoCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final notes = _safeText(
      data.specialInstructions,
      fallback: 'لا توجد ملاحظات خاصة',
    );

    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'معلومات الطلب',
            icon: Icons.receipt_long_rounded,
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _InfoTile(
                  title: 'رقم الطلب',
                  value: '#${data.orderNumber ?? data.id ?? '-'}',
                  icon: Icons.tag_rounded,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                flex: 2,
                child: _InfoTile(
                  title: 'طريقة الدفع',
                  value: 'نقدي',
                  icon: Icons.payments_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: _InfoTile(
                  title: 'نوع الاستلام',
                  value: data.fulfillmentTypeLabel ?? _pickupModeLabel(data.fulfillmentType ?? data.pickupMode),
                  icon: Icons.delivery_dining_rounded,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 2,
                child: _InfoTile(
                  title: 'تاريخ الإنشاء',
                  value: _formatTime(data.createdAt),
                  icon: Icons.schedule_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.notes_rounded,
                  size: 18,
                  color: Color(0xFF6B7280),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    notes,
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _pickupModeLabel(String? value) {
    return switch (value) {
      'delivery' => 'توصيل',
      'pickup' => 'استلام من المتجر',
      "immediate_pickup" => 'استلام فوري من المتجر',
      _ => _safeText(value, fallback: 'توصيل'),
    };
  }
}

class _OrderStatusCard extends StatelessWidget {
  final GetOrderDetailsModelData data;

  const _OrderStatusCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final details = data.orderDetails;
    final status = details?.currentStatus ?? data.status;
    final color = _statusColor(status);
    final minutes = details?.statusElapsedMinutes ?? 0;
    final statusLabel =
        details?.currentStatusLabel ??
        _safeText(data.status, fallback: 'غير محدد');

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 12),
            blurRadius: 26,
            spreadRadius: -16,
            color: Color(0x66000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0x33FFFFFF),
                child: Icon(
                  _statusIcon(status),
                  size: 22,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'الحالة الحالية',
                      textAlign: TextAlign.start,
                      style: const TextStyle(
                        color: Color(0xE6FFFFFF),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AppText(
                      statusLabel,
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AppText(
                  details?.statusElapsedText ?? _formatDurationArabic(minutes),
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _TimeOrderOverlay(
                  title: 'وقت الاستلام',
                  subtitle: _formatTime(data.createdAt),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(
                  title: 'الوقت المتوقع',
                  subtitle: details?.expectedDeliveryTime ?? 'غير محدد',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(
                  title: 'منذ',
                  subtitle: _formatDurationArabic(minutes),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PaymentRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _PaymentRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: AppText(
            label,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: isTotal
                  ? const Color(0xFF111827)
                  : const Color(0xFF4B5563),
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
              height: 1.42,
            ),
          ),
        ),
        const SizedBox(width: 12),
        AppText(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF111827),
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.w800,
            height: 1.42,
          ),
        ),
      ],
    );
  }
}

class _ProductDetails extends StatelessWidget {
  final bool isLast;
  final GetOrderDetailsModelDataItemsItem orderItem;

  const _ProductDetails({this.isLast = false, required this.orderItem});

  @override
  Widget build(BuildContext context) {
    final productName =
        orderItem.productName ?? orderItem.product?.name ?? 'منتج غير معروف';
    final imageUrl = _safeText(orderItem.product?.imageUrl, fallback: '');
    final unitPrice = _formatMoney(
      orderItem.unitPrice ?? orderItem.product?.price,
    );
    final totalPrice = _formatMoney(orderItem.totalPrice);

    return Container(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: !isLast
            ? const Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 58,
              height: 58,
              color: const Color(0xFFF3F4F6),
              child: imageUrl.isEmpty
                  ? const Icon(
                      Icons.shopping_bag_outlined,
                      color: Color(0xFF9CA3AF),
                    )
                  : Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.shopping_bag_outlined,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  productName,
                  textAlign: TextAlign.start,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    height: 1.42,
                  ),
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _MiniBadge(label: 'x ${orderItem.quantity ?? 0}'),
                    _MiniBadge(label: '$unitPrice ل.س للقطعة'),
                  ],
                ),
                if (orderItem.modifierSnapshot?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: orderItem.modifierSnapshot!
                        .map(
                          (modifier) =>
                              _MiniBadge(label: _modifierLabel(modifier)),
                        )
                        .toList(growable: false),
                  ),
                ],
                if (orderItem.substituteProduct != null) ...[
                  const SizedBox(height: 8),
                  _InlineInfo(
                    icon: Icons.swap_horiz_rounded,
                    value:
                        'البديل المقبول: ${_safeText(orderItem.substituteProduct?.name)}',
                  ),
                ],
                if ((orderItem.note ?? '').trim().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  _InlineInfo(
                    icon: Icons.sticky_note_2_outlined,
                    value: 'ملاحظة المنتج: ${orderItem.note!.trim()}',
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),
          AppText(
            '$totalPrice ل.س',
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w800,
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderManagementActions extends StatefulWidget {
  final int orderId;
  final GetOrderDetailsModelData data;

  const _OrderManagementActions({
    required this.orderId,
    required this.data,
  });

  @override
  State<_OrderManagementActions> createState() =>
      _OrderManagementActionsState();
}

class _OrderManagementActionsState extends State<_OrderManagementActions> {
  bool _busy = false;

  StoreOwnerOperationsService get _operations =>
      StoreOwnerOperationsService(getIt<DioNetwork>());

  @override
  Widget build(BuildContext context) {
    final status =
        widget.data.orderDetails?.currentStatus ?? widget.data.status ?? '';
    final canCancel = const {
      'accepted',
      'preparing',
      'ready_for_pickup',
    }.contains(status);
    final canReturn = const {'completed', 'delivered'}.contains(status);

    if (!canCancel && !canReturn) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 13),
      child: _SectionCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionTitle(
              title: 'إجراءات الطلب',
              icon: Icons.rule_rounded,
            ),
            const SizedBox(height: 12),
            if (_busy)
              const Center(child: CircularProgressIndicator.adaptive())
            else
              Row(
                children: [
                  if (canCancel)
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: _cancelOrder,
                        icon: const Icon(Icons.cancel_outlined),
                        label: const Text('إلغاء الطلب'),
                      ),
                    ),
                  if (canCancel && canReturn) const SizedBox(width: 8),
                  if (canReturn)
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: _returnOrder,
                        icon: const Icon(Icons.assignment_return_rounded),
                        label: const Text('إرجاع منتجات'),
                      ),
                    ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _cancelOrder() async {
    final reason = await _promptReason(
      title: 'إلغاء الطلب',
      hint: 'اكتب سبب الإلغاء بوضوح',
    );
    if (reason == null || !mounted) return;

    await _run(
      () => _operations.cancelOrder(
        orderId: widget.orderId,
        reason: reason,
      ),
      successMessage: 'تم إلغاء الطلب',
    );
  }

  Future<void> _returnOrder() async {
    final payload = await _promptReturn();
    if (payload == null || !mounted) return;

    await _run(
      () => _operations.returnOrder(
        orderId: widget.orderId,
        items: List<Map<String, dynamic>>.from(payload['items'] as List),
        reason: payload['reason'] as String,
      ),
      successMessage: 'تم تسجيل الإرجاع وتحديث المخزون',
    );
  }

  Future<void> _run(
    Future<Map<String, dynamic>> Function() action, {
    required String successMessage,
  }) async {
    setState(() => _busy = true);
    try {
      await action();
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        message: successMessage,
        type: ToastificationType.success,
      );
      context.read<OrdersBloc>().add(
        GetOrderDetailsEvent(
          params: GetOrderDetailsParams(orderId: widget.orderId),
        ),
      );
    } on StoreOwnerOperationException catch (error) {
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        message: error.message,
        type: ToastificationType.error,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<String?> _promptReason({
    required String title,
    required String hint,
  }) async {
    final controller = TextEditingController();
    String? error;

    final result = await showDialog<String>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: hint,
              errorText: error,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('تراجع'),
            ),
            FilledButton(
              onPressed: () {
                final value = controller.text.trim();
                if (value.length < 5) {
                  setDialogState(
                    () => error = 'السبب يجب أن يكون 5 أحرف على الأقل',
                  );
                  return;
                }
                Navigator.pop(dialogContext, value);
              },
              child: const Text('تأكيد'),
            ),
          ],
        ),
      ),
    );

    controller.dispose();
    return result;
  }

  Future<Map<String, dynamic>?> _promptReturn() async {
    final items = widget.data.items ?? const [];
    if (items.isEmpty) return null;

    final quantityControllers = <int, TextEditingController>{};
    for (final item in items) {
      if (item.id != null) {
        quantityControllers[item.id!] = TextEditingController(text: '0');
      }
    }
    final reasonController = TextEditingController();
    String? error;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('إرجاع منتجات'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: [
                const Text(
                  'حدد الكمية المراد إرجاعها من كل منتج. اترك 0 للمنتجات غير المرجعة.',
                ),
                const SizedBox(height: 12),
                for (final item in items)
                  if (item.id != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: TextField(
                        controller: quantityControllers[item.id],
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText:
                              '${item.productName ?? item.product?.name ?? 'منتج'} (الحد: ${item.quantity ?? 0})',
                        ),
                      ),
                    ),
                TextField(
                  controller: reasonController,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'سبب الإرجاع',
                  ),
                ),
                if (error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('تراجع'),
            ),
            FilledButton(
              onPressed: () {
                final selected = <Map<String, dynamic>>[];
                var invalidQuantity = false;

                for (final item in items) {
                  final id = item.id;
                  if (id == null) continue;
                  final quantity =
                      int.tryParse(quantityControllers[id]?.text.trim() ?? '') ??
                      0;
                  if (quantity < 0 || quantity > (item.quantity ?? 0)) {
                    invalidQuantity = true;
                    break;
                  }
                  if (quantity > 0) {
                    selected.add({
                      'order_item_id': id,
                      'quantity': quantity,
                    });
                  }
                }

                final reason = reasonController.text.trim();
                if (invalidQuantity) {
                  setDialogState(
                    () => error = 'إحدى الكميات أكبر من الكمية المطلوبة',
                  );
                  return;
                }
                if (selected.isEmpty) {
                  setDialogState(
                    () => error = 'حدد منتجًا واحدًا على الأقل للإرجاع',
                  );
                  return;
                }
                if (reason.length < 5) {
                  setDialogState(
                    () => error = 'سبب الإرجاع يجب أن يكون 5 أحرف على الأقل',
                  );
                  return;
                }

                Navigator.pop(dialogContext, {
                  'items': selected,
                  'reason': reason,
                });
              },
              child: const Text('تأكيد الإرجاع'),
            ),
          ],
        ),
      ),
    );

    for (final controller in quantityControllers.values) {
      controller.dispose();
    }
    reasonController.dispose();
    return result;
  }
}

class _SectionCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: child,
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? color;
  final String? trailing;

  const _SectionTitle({
    required this.title,
    required this.icon,
    this.color,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.primary;

    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: effectiveColor.withValues(alpha: .10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 18, color: effectiveColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: AppText(
            title,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w800,
              height: 1.4,
            ),
          ),
        ),
        if (trailing != null)
          AppText(
            trailing!,
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  final GetOrderDetailsModelDataStore store;

  const _StoreCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            title: 'معلومات المتجر',
            icon: Icons.storefront_rounded,
          ),
          const SizedBox(height: 14),
          AppText(
            _safeText(store.name, fallback: 'اسم المتجر غير متوفر'),
            textAlign: TextAlign.start,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF111827),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          _InlineInfo(
            icon: Icons.location_on_outlined,
            value: _safeText(store.address, fallback: 'عنوان المتجر غير متوفر'),
          ),
          const SizedBox(height: 5),
          _InlineInfo(
            icon: Icons.phone_rounded,
            value: _safeText(store.phone, fallback: 'رقم المتجر غير متوفر'),
          ),
        ],
      ),
    );
  }
}

class _TimeOrderOverlay extends StatelessWidget {
  final String title;
  final String subtitle;

  const _TimeOrderOverlay({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0x33FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            title,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 3),
          AppText(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}
