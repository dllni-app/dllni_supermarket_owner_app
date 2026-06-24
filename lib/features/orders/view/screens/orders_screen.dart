import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
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

  static const _statuses = <String?>[
    null,
    'pending',
    'accepted',
    'preparing',
    'ready_for_pickup',
    'picked_up',
    'completed',
    'cancelled',
  ];

  OrderStatus _mapStatus(String? status) {
    switch (status) {
      case 'pending':
        return OrderStatus.pending;
      case 'accepted':
        return OrderStatus.accepted;
      case 'preparing':
        return OrderStatus.preparing;
      case 'ready_for_pickup':
        return OrderStatus.readyForPickup;
      case 'picked_up':
        return OrderStatus.pickedUp;
      case 'completed':
        return OrderStatus.completed;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.unknown;
    }
  }

  void _load(BuildContext context, {bool reload = true}) {
    context.read<OrdersBloc>().add(
          GetOrdersEvent(
            isReload: reload,
            params: GetOrdersParams(page: 1, status: selectedStatus),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<OrdersBloc>()
        ..add(GetOrdersEvent(params: GetOrdersParams()))
        ..add(GetOrderCountsEvent(params: GetOrderCountsParams())),
      child: BlocListener<OrdersBloc, OrdersState>(
        listenWhen: (p, c) => p.courierHandoverStatus != c.courierHandoverStatus,
        listener: (context, state) {
          if (state.courierHandoverStatus == BlocStatus.failed) {
            AppToast.showToast(context: context, message: state.errorMessage ?? 'Unknown Error', type: ToastificationType.error);
          } else if (state.courierHandoverStatus == BlocStatus.success) {
            AppToast.showToast(context: context, message: 'Courier handover done', type: ToastificationType.success);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xffF5F6FA),
          body: Column(
            children: [
              OrdersAppBar(),
              BlocBuilder<OrdersBloc, OrdersState>(
                buildWhen: (p, c) => p.orderCountsStatus != c.orderCountsStatus,
                builder: (context, state) {
                  final counts = state.orderCounts?.data;
                  return OrdersTabBar(
                    items: [
                      OrdersTabBarItem(title: 'All', count: counts?.total ?? 0),
                      OrdersTabBarItem(title: 'Pending', count: counts?.pending ?? 0, leadingColor: context.primary),
                      OrdersTabBarItem(title: 'Accepted', count: counts?.accepted ?? 0, leadingColor: AppColors.accent),
                      OrdersTabBarItem(title: 'Preparing', count: counts?.preparing ?? 0, leadingColor: AppColors.accent),
                      OrdersTabBarItem(title: 'Ready', count: counts?.readyForDelivery ?? 0, leadingColor: const Color(0xFF24B364)),
                      OrdersTabBarItem(title: 'Picked', count: counts?.courierHandover ?? 0, leadingColor: const Color(0xFF24B364)),
                      OrdersTabBarItem(title: 'Completed', count: counts?.completed ?? 0, leadingColor: const Color(0xFF24B364)),
                      OrdersTabBarItem(title: 'Cancelled', count: counts?.cancelled ?? 0, leadingColor: const Color(0xFFFF4C51)),
                    ],
                    onChanged: (index) {
                      selectedStatus = _statuses[index];
                      _load(context);
                    },
                  );
                },
              ),
              Expanded(
                child: BlocBuilder<OrdersBloc, OrdersState>(
                  builder: (context, state) {
                    return state.orders!.builder(
                      loadingWidget: const Center(child: CircularProgressIndicator()),
                      emptyWidget: const Center(child: Text('No orders')),
                      failedWidget: FailureWidget(message: state.errorMessage ?? 'Unknown Error', onRetry: () => _load(context)),
                      onTapRetry: () => _load(context),
                      successWidget: () => ListView.separated(
                        padding: const EdgeInsets.all(20),
                        itemCount: state.orders!.listLength(1),
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (state.orders!.length <= index) {
                            context.read<OrdersBloc>().add(
                                  GetOrdersEvent(
                                    params: GetOrdersParams(page: state.orders!.pageNumber, status: selectedStatus),
                                  ),
                                );
                            return const Center(child: CircularProgressIndicator());
                          }
                          final order = state.orders!.list[index];
                          return OrderCard(
                            order: order,
                            status: _mapStatus(order.status),
                            onAcceptTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => BlocProvider.value(
                                value: context.read<OrdersBloc>(),
                                child: AcceptOrderBottomSheet(status: selectedStatus, orderId: order.id!, orderNumber: order.orderNumber ?? '${order.id}'),
                              ),
                            ),
                            onRejectTap: () => showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => BlocProvider.value(
                                value: context.read<OrdersBloc>(),
                                child: RejectOrderBottomSheet(status: selectedStatus, orderId: order.id!, orderNumber: order.orderNumber ?? '${order.id}'),
                              ),
                            ),
                            onViewDetailsTap: () => context.pushRoute('/orders/order_details', arguments: order.id!),
                            onCourierHandoverTap: () => context.read<OrdersBloc>().add(
                                  CourierHandoverEvent(params: CourierHandoverParams(orderId: order.id!), ordersListStatus: selectedStatus),
                                ),
                            isCourierHandoverLoading: state.courierHandoverStatus == BlocStatus.loading && state.courierHandoverLoadingOrderId == order.id,
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
