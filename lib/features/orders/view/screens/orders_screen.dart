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

  OrderStatus _mapOrderStatus(String? status) {
    return switch (status) {
      'pending' => OrderStatus.pending,
      'accepted' => OrderStatus.accepted,
      'preparing' => OrderStatus.preparing,
      'ready_for_pickup' => OrderStatus.readyForPickup,
      'picked_up' || 'out_for_delivery' => OrderStatus.pickedUp,
      'completed' || 'delivered' => OrderStatus.completed,
      'rejected' => OrderStatus.rejected,
      'cancelled' || 'canceled' => OrderStatus.cancelled,
      _ => OrderStatus.pending,
    };
  }

  OrderLifecycleAction _lifecycleActionForStatus(String? status) {
    return switch (status) {
      'accepted' => OrderLifecycleAction.markPreparing,
      'preparing' => OrderLifecycleAction.markReadyForPickup,
      _ => OrderLifecycleAction.courierHandover,
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<OrdersBloc>(
      create: (context) => getIt<OrdersBloc>()
        ..add(GetOrdersEvent(params: GetOrdersParams()))
        ..add(GetOrderCountsEvent(params: GetOrderCountsParams())),
      child: BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (previous, current) =>
            (previous.acceptOrderStatus != current.acceptOrderStatus &&
                current.acceptOrderStatus == BlocStatus.success) ||
            (previous.rejectOrderStatus != current.rejectOrderStatus &&
                current.rejectOrderStatus == BlocStatus.success) ||
            (previous.courierHandoverStatus != current.courierHandoverStatus &&
                current.courierHandoverStatus == BlocStatus.success) ||
            (previous.courierHandoverStatus != current.courierHandoverStatus &&
                current.courierHandoverStatus == BlocStatus.failed),
        listener: (context, state) {
          if (state.courierHandoverStatus == BlocStatus.failed) {
            AppToast.showToast(
              context: context,
              message: state.errorMessage ?? 'Unknown Error',
              type: ToastificationType.error,
            );
            return;
          }

          if (state.courierHandoverStatus == BlocStatus.success) {
            AppToast.showToast(
              context: context,
              message: 'تم تحديث حالة الطلب',
              type: ToastificationType.success,
            );
          }

          context.read<OrdersBloc>().add(
            GetOrderCountsEvent(params: GetOrderCountsParams()),
          );
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF5F6FA),
          body: Column(
            children: [
              OrdersAppBar(),
              Expanded(
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    BlocBuilder<OrdersBloc, OrdersState>(
                      buildWhen: (previous, current) =>
                          previous.orderCountsStatus !=
                              current.orderCountsStatus ||
                          previous.orderCounts != current.orderCounts,
                      builder: (context, state) {
                        if (state.orderCountsStatus == BlocStatus.loading &&
                            state.orderCounts == null) {
                          return ProductsTabBarLoading();
                        } else if (state.orderCountsStatus == BlocStatus.failed &&
                            state.orderCounts == null) {
                          return FailureWidget(
                            message: state.errorMessage ?? 'Unknown Error',
                            onRetry: () => context.read<OrdersBloc>().add(
                              GetOrderCountsEvent(params: GetOrderCountsParams()),
                            ),
                          );
                        } else if (state.orderCounts != null) {
                          return OrdersTabBar(
                            items: [
                              OrdersTabBarItem(
                                title: 'الكل',
                                count: state.orderCounts?.data?.total ?? 0,
                              ),
                              OrdersTabBarItem(
                                title: 'طلب جديد',
                                count: state.orderCounts?.data?.pending ?? 0,
                                leadingColor: context.primary,
                              ),
                              OrdersTabBarItem(
                                title: 'مقبول',
                                count: state.orderCounts?.data?.accepted ?? 0,
                                leadingColor: const Color(0xFF2563EB),
                              ),
                              OrdersTabBarItem(
                                title: 'قيد التحضير',
                                count: state.orderCounts?.data?.preparing ?? 0,
                                leadingColor: AppColors.accent,
                              ),
                              OrdersTabBarItem(
                                title: 'جاهز للتسليم',
                                count:
                                    state.orderCounts?.data?.readyForDelivery ?? 0,
                                leadingColor: const Color(0xFF24B364),
                              ),
                              OrdersTabBarItem(
                                title: 'مكتمل',
                                count: state.orderCounts?.data?.completed ?? 0,
                                leadingColor: const Color(0xFF24B364),
                              ),
                            ],
                            onChanged: (index) {
                              if (index == 0) selectedStatus = null;
                              if (index == 1) selectedStatus = 'pending';
                              if (index == 2) selectedStatus = 'accepted';
                              if (index == 3) selectedStatus = 'preparing';
                              if (index == 4) selectedStatus = 'ready_for_pickup';
                              if (index == 5) selectedStatus = 'completed';
                              context.read<OrdersBloc>().add(
                                GetOrdersEvent(
                                  params: GetOrdersParams(
                                    page: 1,
                                    status: selectedStatus,
                                  ),
                                  isReload: true,
                                ),
                              );
                              context.read<OrdersBloc>().add(
                                GetOrderCountsEvent(
                                  params: GetOrderCountsParams(),
                                ),
                              );
                            },
                          );
                        }
                        return const SizedBox();
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
                              baseColor: const Color(0xFFE0E0E0),
                              highlightColor: const Color(0xFFCCCCCC),
                              child: ListView.separated(
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 16,
                                ),
                                itemBuilder: (_, index) => Container(
                                  width: double.infinity,
                                  height: index == 3 ? 80 : 220,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                                separatorBuilder: (_, _) =>
                                    const SizedBox(height: 12),
                                itemCount: 4,
                              ),
                            ),
                            emptyWidget: AppText.labelMedium(
                              'لا يوجد طلبات',
                              fontWeight: FontWeight.w400,
                            ),
                            successWidget: () {
                              return ListView.separated(
                                padding: const EdgeInsetsDirectional.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
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
                                      baseColor: const Color(0xFFE0E0E0),
                                      highlightColor: const Color(0xFFCCCCCC),
                                      child: Container(
                                        width: double.infinity,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                    );
                                  }

                                  final order = state.orders!.list[index];

                                  return OrderCard(
                                    order: order,
                                    status: _mapOrderStatus(order.status),
                                    onAcceptTap: () {
                                      showModalBottomSheet(
                                        context: context,
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        builder: (_) => BlocProvider.value(
                                          value: context.read<OrdersBloc>(),
                                          child: AcceptOrderBottomSheet(
                                            status: selectedStatus,
                                            orderId: order.id!,
                                            orderNumber: order.orderNumber!,
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
                                            orderId: order.id!,
                                            orderNumber: order.orderNumber!,
                                          ),
                                        ),
                                      );
                                    },
                                    onViewDetailsTap: () {},
                                    onCourierHandoverTap: () {
                                      context.read<OrdersBloc>().add(
                                            CourierHandoverEvent(
                                              params: CourierHandoverParams(
                                                orderId: order.id!,
                                                action: _lifecycleActionForStatus(
                                                  order.status,
                                                ),
                                              ),
                                              ordersListStatus: selectedStatus,
                                            ),
                                          );
                                    },
                                    isCourierHandoverLoading:
                                        state.courierHandoverStatus ==
                                                BlocStatus.loading &&
                                            state.courierHandoverLoadingOrderId ==
                                                order.id,
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    const SizedBox(height: 14),
                                itemCount: state.orders!.listLength(1),
                              );
                            },
                            failedWidget: FailureWidget(
                              message: state.errorMessage ?? 'Unknown Error',
                              onRetry: () => context.read<OrdersBloc>().add(
                                    GetOrdersEvent(
                                      params: GetOrdersParams(
                                        page: 1,
                                        status: selectedStatus,
                                      ),
                                      isReload: true,
                                    ),
                                  ),
                            ),
                            onTapRetry: () => context.read<OrdersBloc>().add(
                                  GetOrdersEvent(
                                    params: GetOrdersParams(
                                      page: 1,
                                      status: selectedStatus,
                                    ),
                                    isReload: true,
                                  ),
                                ),
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
