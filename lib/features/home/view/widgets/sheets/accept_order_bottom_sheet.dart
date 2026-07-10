import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../orders/domain/usecases/accept_order_use_case.dart';
import '../../../../orders/view/widgets/preparation_time_selector.dart';
import '../../../domain/usecases/get_new_orders_use_case.dart';
import '../../manager/bloc/home_bloc.dart';

class AcceptOrderBottomSheet extends StatefulWidget {
  const AcceptOrderBottomSheet({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  final int orderId;
  final String orderNumber;

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
        child: BlocConsumer<HomeBloc, HomeState>(
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
              context.read<HomeBloc>().add(
                    GetNewOrdersEvent(
                      isReload: true,
                      params: GetNewOrdersParams(),
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
                                'وقت التجهيز اختياري، وسيبدأ البحث عن مندوب عند القبول.',
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
                          Icon(Icons.info_outline, color: Color(0xFF2563EB)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'يمكن للمندوب قبول الطلب والتوجه للمتجر، لكن الاستلام يبقى مقفلاً حتى يصبح الطلب جاهزاً.',
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
                                context.read<HomeBloc>().add(
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
