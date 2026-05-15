import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/home/data/models/get_preparing_orders_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_preparing_orders_use_case.dart';
import '../manager/bloc/home_bloc.dart';
import 'loadings/preparing_orders_loading.dart';

class PreparingOrdersSection extends StatelessWidget {
  const PreparingOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              "قيد التحضير",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                height: 1.5,
              ),
            ),
            SizedBox(width: 8),
            BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.preparingOrders != current.preparingOrders,
              builder: (context, state) {
                return state.preparingOrders!.builder(
                  loadingWidget: SizedBox(),
                  emptyWidget: SizedBox(),
                  successWidget: () => state.preparingOrders!.isEmpty
                      ? SizedBox()
                      : Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(20),
                                  ),
                                ),
                                child: AppText(
                                  state.preparingOrders!.length.toString(),
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              Spacer(),
                              InkWell(
                                onTap: () {},
                                child: AppText(
                                  "عرض الجدول",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF9CA3AF),
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                  failedWidget: SizedBox(),
                );
              },
            ),
          ],
        ),
        SizedBox(height: 12),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.preparingOrders != current.preparingOrders,
          builder: (context, state) {
            return state.preparingOrders!.builder(
              loadingWidget: PreparingOrdersLoading(),
              emptyWidget: AppText.labelMedium('لا يوجد طلبات للعرض'),
              successWidget: () => Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: const Color(0xFFF3F4F6)),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                      color: const Color(0x08000000),
                    ),
                  ],
                ),
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) => Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: index > 0
                          ? const Border(
                              top: BorderSide(color: Color(0xFFF9FAFB)),
                            )
                          : null,
                    ),
                    child: PreparingOrderCard(
                      order: state.preparingOrders![index],
                    ),
                  ),
                  itemCount: state.preparingOrders!.length > 2
                      ? 2
                      : state.preparingOrders!.length,
                ),
              ),
              onTapRetry: () {
                context.read<HomeBloc>().add(
                  GetPreparingOrdersEvent(params: GetPreparingOrdersParams()),
                );
              },
              failedWidget: FailureWidget(
                message: state.errorMessage ?? "Error an occurred",
                onRetry: () {
                  context.read<HomeBloc>().add(
                    GetPreparingOrdersEvent(params: GetPreparingOrdersParams()),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
// Container(
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       border: index > 0
//                           ? const Border(
//                               top: BorderSide(color: Color(0xFFF9FAFB)),
//                             )
//                           : null,
//                     ),
//                     child: PreparingOrderCard(
//                       order: GetPreparingOrdersModelDataItem.fromJson({
//                         "id": 3,
//                         "customerId": 20,
//                         "storeId": 1,
//                         "couponId": null,
//                         "cancellationPolicyId": 5,
//                         "orderNumber": "SM-8DKBUF-1-2",
//                         "status": "preparing",
//                         "pickupMode": "immediate_pickup",
//                         "pickupScheduledFor": null,
//                         "readyForPickupAt": null,
//                         "pickedUpAt": null,
//                         "customerPickupConfirmedAt": null,
//                         "subtotal": "0.00",
//                         "discountAmount": "0.00",
//                         "serviceFee": "0.00",
//                         "totalAmount": "0.00",
//                         "cancellationFeeAmount": null,
//                         "cancellationPolicySnapshot": null,
//                         "specialInstructions": null,
//                         "cancelledAt": null,
//                         "cancellationReason": null,
//                         "createdAt": "2026-03-03 12:59:58",
//                         "updatedAt": "2026-03-03 12:59:58",
//                       }),
//                     ),
//                   )

class PreparingOrderCard extends StatelessWidget {
  const PreparingOrderCard({super.key, required this.order});
  final GetPreparingOrdersModelDataItem order;

  String get delay {
    final Duration diffDate = DateTime.now().difference(
      DateTime.parse(order.updatedAt!),
    );
    if (diffDate.inDays != 0) return "${diffDate.inDays} يوم";
    if (diffDate.inHours != 0) return "${diffDate.inHours} ساعة";
    if (diffDate.inMinutes != 0) return "${diffDate.inMinutes} دقيقة";
    return "${diffDate.inSeconds} ثانية";
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 4, backgroundColor: const Color(0xFF3B82F6)),
        SizedBox(width: 12),
        AppText(
          "#${order.orderNumber} طلب",
          textDirection: TextDirection.ltr,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
            height: 1.42,
          ),
        ),
        SizedBox(width: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
          child: AppText(
            "داخلي",
            style: TextStyle(
              color: const Color(0xFF9CA3AF),
              fontSize: 10,
              height: 1.5,
            ),
          ),
        ),
        Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: const Color(0xFFEFF6FF),
          ),
          child: Row(
            spacing: 4,
            children: [
              Icon(
                FontAwesomeIcons.clock,
                size: 12,
                color: const Color(0xFF2563EB),
              ),
              AppText(
                delay,
                style: TextStyle(
                  color: const Color(0xFF2563EB),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  height: 1.333,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
