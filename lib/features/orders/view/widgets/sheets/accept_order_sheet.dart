import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../domain/usecases/accept_order_use_case.dart';
import '../../../domain/usecases/get_orders_use_case.dart';
import '../../manager/bloc/orders_bloc.dart';
import '../preparation_time_selector.dart';

class AcceptOrderBottomSheet extends StatefulWidget {
  const AcceptOrderBottomSheet({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.status,
  });

  final int orderId;
  final String orderNumber;
  final String? status;

  @override
  State<AcceptOrderBottomSheet> createState() =>
      _AcceptOrderBottomSheetState();
}

class _AcceptOrderBottomSheetState extends State<AcceptOrderBottomSheet> {
  int? _preparationTimeMinutes;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: BlocConsumer<OrdersBloc, OrdersState>(
          listenWhen: (previous, current) =>
              previous.acceptOrderStatus != current.acceptOrderStatus,
          listener: (context, state) {
            if (state.acceptOrderStatus == BlocStatus.failed) {
              AppToast.showToast(
                context: context,
                message: state.errorMessage ?? 'تعذر قبول الطلب',
                type: ToastificationType.error,
              );
            } else if (state.acceptOrderStatus == BlocStatus.success) {
              AppToast.showToast(
                context: context,
                message: 'تم قبول الطلب وبدء البحث عن مندوب',
                type: ToastificationType.success,
              );
              context.read<OrdersBloc>().add(
                    GetOrdersEvent(
                      isReload: true,
                      params: GetOrdersParams(status: widget.status),
                    ),
                  );
              context.pop();
            }
          },
          builder: (context, state) {
            final loading = state.acceptOrderStatus == BlocStatus.loading;
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                20,
                24,
                MediaQuery.paddingOf(context).bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                'قبول الطلب #${widget.orderNumber}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'يمكن قبول الطلب بدون تقدير. يبدأ البحث عن مندوب فوراً ويمكنه التوجه قبل اكتمال التجهيز.',
                                style: TextStyle(color: Color(0xFF6B7280)),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: loading ? null : () => context.pop(),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PreparationTimeSelector(
                      onChanged: (value) =>
                          _preparationTimeMinutes = value,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.local_shipping_outlined,
                              color: Color(0xFF2563EB)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'الوقت المتوقع للمعلومة فقط. لن يتمكن المندوب من استلام الطلب حتى تحديده كجاهز للاستلام.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: loading
                            ? null
                            : () {
                                context.read<OrdersBloc>().add(
                                      AcceptOrderEvent(
                                        params: AcceptOrderParams(
                                          orderId: widget.orderId,
                                          preparationTimeMinutes:
                                              _preparationTimeMinutes,
                                        ),
                                      ),
                                    );
                              },
                        icon: loading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.check_circle_outline),
                        label: const Text('تأكيد القبول'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
