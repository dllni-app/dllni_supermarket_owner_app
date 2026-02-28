part of 'home_bloc.dart';

class HomeState {
  final BlocStatus dashboardStatus;
  final BlocStatus lowStockStatus;
  final BlocStatus pendingOrdersStatus;
  final BlocStatus preparingOrdersStatus;
  final BlocStatus actionStatus;

  final int? storeId;
  final DashboardModel? dashboard;
  final LowStockModel? lowStock;
  final OrdersListModel? pendingOrders;
  final OrdersListModel? preparingOrders;
  final String errorMessage;
  final String actionMessage;

  HomeState({
    this.dashboardStatus = BlocStatus.init,
    this.lowStockStatus = BlocStatus.init,
    this.pendingOrdersStatus = BlocStatus.init,
    this.preparingOrdersStatus = BlocStatus.init,
    this.actionStatus = BlocStatus.init,
    this.storeId,
    this.dashboard,
    this.lowStock,
    this.pendingOrders,
    this.preparingOrders,
    this.errorMessage = '',
    this.actionMessage = '',
  });

  HomeState copyWith({
    BlocStatus? dashboardStatus,
    BlocStatus? lowStockStatus,
    BlocStatus? pendingOrdersStatus,
    BlocStatus? preparingOrdersStatus,
    BlocStatus? actionStatus,
    int? storeId,
    DashboardModel? dashboard,
    LowStockModel? lowStock,
    OrdersListModel? pendingOrders,
    OrdersListModel? preparingOrders,
    String? errorMessage,
    String? actionMessage,
  }) {
    return HomeState(
      dashboardStatus: dashboardStatus ?? this.dashboardStatus,
      lowStockStatus: lowStockStatus ?? this.lowStockStatus,
      pendingOrdersStatus: pendingOrdersStatus ?? this.pendingOrdersStatus,
      preparingOrdersStatus: preparingOrdersStatus ?? this.preparingOrdersStatus,
      actionStatus: actionStatus ?? this.actionStatus,
      storeId: storeId ?? this.storeId,
      dashboard: dashboard ?? this.dashboard,
      lowStock: lowStock ?? this.lowStock,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      preparingOrders: preparingOrders ?? this.preparingOrders,
      errorMessage: errorMessage ?? this.errorMessage,
      actionMessage: actionMessage ?? this.actionMessage,
    );
  }
}
