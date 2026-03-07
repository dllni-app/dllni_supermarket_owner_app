part of 'home_bloc.dart';

class HomeState {
  BlocStatus? rejectOrderStatus;
  RejectOrderModel? rejectOrder;
  PaginationStateModel<GetPreparingOrdersModelDataItem>? preparingOrders;
  PaginationStateModel<GetNewOrdersModelDataItem>? newOrders;
  BlocStatus? dashboardOverviewStatus;
  GetDashboardOverviewModel? dashboardOverview;
  String? errorMessage;

  HomeState({
    this.errorMessage,
    this.dashboardOverview,
    this.dashboardOverviewStatus,
    this.newOrders = const PaginationStateModel(perPage: 10),
    this.preparingOrders = const PaginationStateModel(perPage: 10),
    this.rejectOrder,
    this.rejectOrderStatus,
  });

  HomeState copyWith({
    String? errorMessage,
    GetDashboardOverviewModel? dashboardOverview,
    BlocStatus? dashboardOverviewStatus,
    PaginationStateModel<GetNewOrdersModelDataItem>? newOrders,
    PaginationStateModel<GetPreparingOrdersModelDataItem>? preparingOrders,
    RejectOrderModel? rejectOrder,
    BlocStatus? rejectOrderStatus,
  }) => HomeState(
    errorMessage: errorMessage ?? this.errorMessage,
    dashboardOverview: dashboardOverview ?? this.dashboardOverview,
    dashboardOverviewStatus:
        dashboardOverviewStatus ?? this.dashboardOverviewStatus,
    newOrders: newOrders ?? this.newOrders,
    preparingOrders: preparingOrders ?? this.preparingOrders,
    rejectOrder: rejectOrder ?? this.rejectOrder,
    rejectOrderStatus: rejectOrderStatus ?? this.rejectOrderStatus,
  );
}
