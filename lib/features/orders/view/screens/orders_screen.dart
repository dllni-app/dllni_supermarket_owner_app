import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../products/view/widgets/loadings/products_tab_bar_loading.dart';
import '../../domain/usecases/courier_handover_use_case.dart';
import '../../domain/usecases/get_order_counts_use_case.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../manager/bloc/orders_bloc.dart';
import '../widgets/order_card.dart';
import '../widgets/orders_app_bar.dart';
import '../widgets/orders_tab_bar.dart';
import '../widgets/sheets/accept_order_sheet.dart';
import '../widgets/sheets/reject_order_sheet.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  String? selectedStatus;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => getIt<OrdersBloc>()
        ..add(GetOrdersEvent(params: GetOrdersParams()))
        ..add(GetOrderCountsEvent(params: GetOrderCountsParams())),
      child: BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (previous, current) =>
            previous.courierHandoverStatus != current.courierHandoverStatus,
        listener: (context, state) {
          if (state.courierHandoverStatus == BlocStatus.failed) {
            AppToast.showToast(
              context: context,
              message: state.errorMessage ?? "Unknown Error",
              type: ToastificationType.error,
            );
          } else if (state.courierHandoverStatus == BlocStatus.success) {
            AppToast.showToast(
              context: context,
              message: "تم تسليم الطلب للمندوب",
              type: ToastificationType.success,
            );
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF5F6FA),
          body: Column(
            children: [
              OrdersAppBar(),
              Expanded(
                child: Column(
                  children: [
                    SizedBox(height: 8),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: WarningAlert(
                    //     icon: FontAwesomeIcons.clock.data,
                    //     title: "طلب متأخر #2475",
                    //     description: "تجاوز الوقت المحدد بـ 5 دقائق.",
                    //     labelButton: "عرض",
                    //   ),
                    // ),
                    //* this just for get number of orders for each status
                    BlocBuilder<OrdersBloc, OrdersState>(
                      buildWhen: (previous, current) =>
                          previous.orderCountsStatus !=
                          current.orderCountsStatus,
                      builder: (context, state) {
                        if (state.orderCountsStatus == BlocStatus.loading) {
                          return ProductsTabBarLoading();
                        } else if (state.orderCountsStatus ==
                            BlocStatus.failed) {
                          return FailureWidget(
                            message: state.errorMessage ?? "Unknown Error",
                            onRetry: () {
                              context.read<OrdersBloc>().add(
                                GetOrderCountsEvent(
                                  params: GetOrderCountsParams(),
                                ),
                              );
                            },
                          );
                        } else if (state.orderCountsStatus ==
                            BlocStatus.success) {
                          return OrdersTabBar(
                            items: [
                              OrdersTabBarItem(
                                title: "الكل",
                                count: state.orderCounts?.data?.total ?? 0,
                              ),
                              OrdersTabBarItem(
                                title: "طلب جديد",
                                count: state.orderCounts?.data?.pending ?? 0,
                                leadingColor: context.primary,
                              ),
                              OrdersTabBarItem(
                                title: "قيد التحضير",
                                count: state.orderCounts?.data?.preparing ?? 0,
                                leadingColor: AppColors.accent,
                              ),
                              OrdersTabBarItem(
                                title: "جاهز للتسليم",
                                count:
                                    state.orderCounts?.data?.readyForDelivery ??
                                    0,
                                leadingColor: Color(0xFF24B364),
                              ),
                              OrdersTabBarItem(
                                title: "مكتمل",
                                count: state.orderCounts?.data?.completed ?? 0,
                                leadingColor: Color(0xFF24B364),
                              ),
                            ],
                            onChanged: (index) {
                              print(index);
                              if (index == 0) {
                                selectedStatus = null;
                              } else if (index == 1) {
                                selectedStatus = 'pending';
                              } else if (index == 2) {
                                selectedStatus = 'preparing';
                              } else if (index == 3) {
                                selectedStatus = 'ready_for_pickup';
                              } else if (index == 4) {
                                selectedStatus = 'completed';
                              }
                              context.read<OrdersBloc>().add(
                                GetOrdersEvent(
                                  params: GetOrdersParams(
                                    page: 1,
                                    status: selectedStatus,
                                  ),
                                  isReload: true,
                                ),
                              );
                            },
                          );
                        }
                        return SizedBox();
                      },
                    ),
                    Expanded(
                      child: BlocBuilder<OrdersBloc, OrdersState>(
                        buildWhen: (previous, current) =>
                            previous.orders != current.orders ||
                            previous.courierHandoverStatus !=
                                current.courierHandoverStatus ||
                            previous.courierHandoverLoadingOrderId !=
                                current.courierHandoverLoadingOrderId,
                        builder: (context, state) {
                          return state.orders!.builder(
                            loadingWidget: Shimmer.fromColors(
                              baseColor: Color(0xFFE0E0E0),
                              highlightColor: Color(0xFFCCCCCC),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                itemBuilder: (_, index) => [
                                  Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  Container(
                                    width: double.infinity,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ][index],
                                separatorBuilder: (_, _) =>
                                    SizedBox(height: 12),
                                itemCount: 4,
                              ),
                            ),
                            emptyWidget: AppText.labelMedium(
                              'لا يوجد طلبات',
                              fontWeight: FontWeight.w400,
                            ),
                            successWidget: () {
                              return ListView.separated(
                                padding: EdgeInsetsDirectional.symmetric(
                                  horizontal: 24,
                                  vertical: 8,
                                ),
                                itemBuilder: (context, index) {
                                  if (state.orders!.length <= index) {
                                    if (state.orders!.length == index) {
                                      context.read<OrdersBloc>().add(
                                        GetOrdersEvent(
                                          isReload: false,
                                          params: GetOrdersParams(
                                            page: state.orders!.pageNumber,
                                            status: selectedStatus,
                                          ),
                                        ),
                                      );
                                    }
                                    return Shimmer.fromColors(
                                      baseColor: Color(0xFFE0E0E0),
                                      highlightColor: Color(0xFFCCCCCC),
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  return OrderCard(
                                    order: state.orders!.list[index],
                                    status:
                                        state.orders!.list[index].status ==
                                            "pending"
                                        ? OrderStatus.pending
                                        : state.orders!.list[index].status ==
                                              "preparing"
                                        ? OrderStatus.preparing
                                        : state.orders!.list[index].status ==
                                              "ready_for_pickup"
                                        ? OrderStatus.readyForPickup
                                        : OrderStatus.completed,
                                    onAcceptTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<OrdersBloc>(),
                                          child: AcceptOrderBottomSheet(
                                            status: selectedStatus,
                                            orderId:
                                                state.orders!.list[index].id!,
                                            orderNumber: state
                                                .orders!
                                                .list[index]
                                                .orderNumber!,
                                          ),
                                        ),
                                      );
                                    },
                                    onRejectTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<OrdersBloc>(),
                                          child: RejectOrderBottomSheet(
                                            status: selectedStatus,
                                            orderId:
                                                state.orders!.list[index].id!,
                                            orderNumber: state
                                                .orders!
                                                .list[index]
                                                .orderNumber!,
                                          ),
                                        ),
                                      );
                                    },
                                    onViewDetailsTap: () {},
                                    onCourierHandoverTap: () {
                                      context.read<OrdersBloc>().add(
                                        CourierHandoverEvent(
                                          params: CourierHandoverParams(
                                            orderId:
                                                state.orders!.list[index].id!,
                                          ),
                                          ordersListStatus: selectedStatus,
                                        ),
                                      );
                                    },
                                    isCourierHandoverLoading:
                                        state.courierHandoverStatus ==
                                            BlocStatus.loading &&
                                        state.courierHandoverLoadingOrderId ==
                                            state.orders!.list[index].id,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    SizedBox(height: 16),
                                itemCount: state.orders!.listLength(1),
                              );
                            },
                            failedWidget: FailureWidget(
                              message: state.errorMessage ?? "Unknown Error",
                              onRetry: () {
                                context.read<OrdersBloc>().add(
                                  GetOrdersEvent(
                                    params: GetOrdersParams(
                                      page: 1,
                                      status: selectedStatus,
                                    ),
                                    isReload: true,
                                  ),
                                );
                              },
                            ),
                            onTapRetry: () {
                              context.read<OrdersBloc>().add(
                                GetOrdersEvent(
                                  params: GetOrdersParams(
                                    page: 1,
                                    status: selectedStatus,
                                  ),
                                  isReload: true,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ,
