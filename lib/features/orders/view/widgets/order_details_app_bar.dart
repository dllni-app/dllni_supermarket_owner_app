import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../products/view/widgets/arrow_back_button.dart';
import '../../domain/usecases/courier_handover_use_case.dart';
import '../../domain/usecases/get_order_details_use_case.dart';
import '../manager/bloc/orders_bloc.dart';

class OrderDetailsAppBar extends StatelessWidget {
  const OrderDetailsAppBar({
    super.key,
    required this.title,
    required this.productId,
  });
  final String title;
  final String productId;

  OrderLifecycleAction _lifecycleActionForStatus(String? status) {
    return switch (status) {
      'accepted' => OrderLifecycleAction.markPreparing,
      'preparing' => OrderLifecycleAction.markReadyForPickup,
      _ => OrderLifecycleAction.courierHandover,
    };
  }

  String? _actionTitleForStatus(String? status) {
    return switch (status) {
      'accepted' => 'بدء التحضير',
      'preparing' => 'جاهز للاستلام',
      'ready_for_pickup' => 'تسليم للمندوب',
      _ => null,
    };
  }

  Color _actionColorForStatus(String? status) {
    return switch (status) {
      'ready_for_pickup' => const Color(0xFF24B364),
      'preparing' => AppColors.accent,
      _ => AppColors.white,
    };
  }

  bool _canChangeStatus(String? status) {
    return status == 'accepted' ||
        status == 'preparing' ||
        status == 'ready_for_pickup';
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final orderId = int.tryParse(productId);

    return BlocConsumer<OrdersBloc, OrdersState>(
      listenWhen: (previous, current) =>
          previous.courierHandoverStatus != current.courierHandoverStatus,
      listener: (context, state) {
        if (state.courierHandoverStatus == BlocStatus.failed) {
          AppToast.showToast(
            context: context,
            message: state.errorMessage ?? 'Unknown Error',
            type: ToastificationType.error,
          );
          return;
        }

        if (state.courierHandoverStatus == BlocStatus.success &&
            orderId != null) {
          AppToast.showToast(
            context: context,
            message: 'تم تحديث حالة الطلب',
            type: ToastificationType.success,
          );
          context.read<OrdersBloc>().add(
                GetOrderDetailsEvent(
                  params: GetOrderDetailsParams(orderId: orderId),
                ),
              );
        }
      },
      buildWhen: (previous, current) =>
          previous.orderDetailsStatus != current.orderDetailsStatus ||
          previous.orderDetails != current.orderDetails ||
          previous.courierHandoverStatus != current.courierHandoverStatus ||
          previous.courierHandoverLoadingOrderId !=
              current.courierHandoverLoadingOrderId,
      builder: (context, state) {
        final status = state.orderDetails?.data?.status;
        final actionTitle = _actionTitleForStatus(status);
        final isLoading = orderId != null &&
            state.courierHandoverStatus == BlocStatus.loading &&
            state.courierHandoverLoadingOrderId == orderId;

        return Container(
          width: width,
          padding: EdgeInsets.fromLTRB(
            16,
            16 + MediaQuery.paddingOf(context).top,
            16,
            24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 4),
                blurRadius: 7.3,
                color: Color(0x40000000),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                spacing: 4,
                children: [
                  const ArrowBackButton(),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          title,
                          style: TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 1),
                        AppText(
                          'id:$productId',
                          style: TextStyle(
                            color: Color(0x99FFFFFF),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (orderId != null &&
                  actionTitle != null &&
                  _canChangeStatus(status)) ...[
                const SizedBox(height: 16),
                _OrderDetailsStatusActionButton(
                  title: actionTitle,
                  color: _actionColorForStatus(status),
                  isLoading: isLoading,
                  onTap: isLoading
                      ? null
                      : () {
                          context.read<OrdersBloc>().add(
                                CourierHandoverEvent(
                                  params: CourierHandoverParams(
                                    orderId: orderId,
                                    action: _lifecycleActionForStatus(status),
                                  ),
                                ),
                              );
                        },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _OrderDetailsStatusActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final bool isLoading;
  final VoidCallback? onTap;

  const _OrderDetailsStatusActionButton({
    required this.title,
    required this.color,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isLightButton = color == AppColors.white;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.white.withValues(alpha: .35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading) ...[
              SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: isLightButton ? AppColors.primary : AppColors.white,
                ),
              ),
              const SizedBox(width: 8),
            ] else ...[
              Icon(
                Icons.sync_alt_rounded,
                size: 18,
                color: isLightButton ? AppColors.primary : AppColors.white,
              ),
              const SizedBox(width: 8),
            ],
            AppText(
              title,
              style: TextStyle(
                color: isLightButton ? AppColors.primary : AppColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
