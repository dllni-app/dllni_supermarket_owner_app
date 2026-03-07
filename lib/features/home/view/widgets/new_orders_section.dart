import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_new_orders_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/get_new_orders_model.dart';
import '../manager/bloc/home_bloc.dart';
import 'loadings/new_orders_loading.dart';
import 'sheets/accept_order_bottom_sheet.dart';
import 'sheets/reject_order_bottom_sheet.dart';

class NewOrdersSection extends StatelessWidget {
  const NewOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          children: [
            AppText(
              "طلبات جديدة",
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
                  previous.newOrders != current.newOrders,
              builder: (context, state) {
                return state.newOrders!.builder(
                  loadingWidget: SizedBox(),
                  emptyWidget: SizedBox(),
                  successWidget: () => state.newOrders!.isEmpty
                      ? SizedBox()
                      : Row(
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
                                state.newOrders!.length.toString(),
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                            ),
                            Spacer(),
                            if (state.newOrders!.length > 2)
                              InkWell(
                                onTap: () {},
                                child: AppText(
                                  "عرض الكل",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xB22F2B3D),
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ),
                          ],
                        ),
                  failedWidget: SizedBox(),
                );
              },
            ),
          ],
        ),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.newOrders != current.newOrders,
          builder: (context, state) {
            return state.newOrders!.builder(
              loadingWidget: NewOrdersLoading(),
              emptyWidget: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: AppText.labelMedium('لا يوجد طلبات للعرض'),
                ),
              ),
              successWidget: () => ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) =>
                    NewOrderCard(order: state.newOrders![index]),
                separatorBuilder: (_, _) => SizedBox(height: 12),
                itemCount: state.newOrders!.length > 2
                    ? 2
                    : state.newOrders!.length,
              ),
              onTapRetry: () {
                context.read<HomeBloc>().add(
                  GetNewOrdersEvent(params: GetNewOrdersParams()),
                );
              },
              failedWidget: FailureWidget(
                message: "Error an occurred",
                onRetry: () {
                  context.read<HomeBloc>().add(
                    GetNewOrdersEvent(params: GetNewOrdersParams()),
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

class NewOrderCard extends StatelessWidget {
  const NewOrderCard({super.key, required this.order});
  final GetNewOrdersModelDataItem order;

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
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: context.primaryContainer, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 8),
            color: const Color(0x33000000),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: const Color(0xFF1F2937),
                ),
                child: Icon(
                  FontAwesomeIcons.solidUser,
                  size: 16,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    "عبدالله المحمد",
                    style: TextStyle(
                      color: Color(0xE52F2B3D),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                  AppText(
                    "#${order.orderNumber} • منذ $delay",
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      color: Color(0x992F2B3D),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                spacing: 4,
                children: [
                  AppText(
                    "${order.totalAmount} ل.س",
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.primaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: AppText(
                      "نقدي",
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        height: 1.7,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerRight,
            width: context.width,
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0x1F2F2B3D),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: AppText(
              // "1× مشاوي مشكل - 2× حمص - 4× بيبسي",
              order.specialInstructions.toString(),
              style: TextStyle(
                color: const Color(0xE52F2B3D),
                fontSize: 12,
                height: 1.333,
              ),
            ),
          ),

          Row(
            spacing: 16,
            children: [
              Expanded(
                child: AppButton(
                  title: "قبول الطلب",
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) => BlocProvider.value(
                        value: context.read<HomeBloc>(),
                        child: AcceptOrderBottomSheet(
                          orderId: order.id!,
                          orderNumber: order.orderNumber!,
                        ),
                      ),
                    );
                  },
                ),
              ),
              AppOutlinedButton(
                title: "رفض",
                color: const Color(0xFFFF4C51),
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => BlocProvider.value(
                      value: context.read<HomeBloc>(),
                      child: RejectOrderBottomSheet(
                        orderId: order.id!,
                        orderNumber: order.orderNumber!,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
