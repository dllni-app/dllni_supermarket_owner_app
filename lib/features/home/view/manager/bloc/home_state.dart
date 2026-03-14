part of 'home_bloc.dart';

class HomeState {
  BlocStatus? performanceReportStatus;
  GetPerformanceReportModel? performanceReport;
  BlocStatus? acceptOrderStatus;
  AcceptOrderModel? acceptOrder;
  BlocStatus? dailyCountStatus;
  GetDailyCountModel? dailyCount;
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
    this.dailyCount,
    this.dailyCountStatus,
    this.acceptOrder,
    this.acceptOrderStatus,

    this.performanceReport,
    this.performanceReportStatus,
  });

  HomeState copyWith({
    String? errorMessage,
    GetDashboardOverviewModel? dashboardOverview,
    BlocStatus? dashboardOverviewStatus,
    PaginationStateModel<GetNewOrdersModelDataItem>? newOrders,
    PaginationStateModel<GetPreparingOrdersModelDataItem>? preparingOrders,
    RejectOrderModel? rejectOrder,
    BlocStatus? rejectOrderStatus,
    GetDailyCountModel? dailyCount,
    BlocStatus? dailyCountStatus,
    AcceptOrderModel? acceptOrder,
    BlocStatus? acceptOrderStatus,
    GetPerformanceReportModel? performanceReport,
    BlocStatus? performanceReportStatus,
  }) => HomeState(
    errorMessage: errorMessage ?? this.errorMessage,
    dashboardOverview: dashboardOverview ?? this.dashboardOverview,
    dashboardOverviewStatus:
        dashboardOverviewStatus ?? this.dashboardOverviewStatus,
    newOrders: newOrders ?? this.newOrders,
    preparingOrders: preparingOrders ?? this.preparingOrders,
    rejectOrder: rejectOrder ?? this.rejectOrder,
    rejectOrderStatus: rejectOrderStatus ?? this.rejectOrderStatus,
    dailyCount: dailyCount ?? this.dailyCount,
    dailyCountStatus: dailyCountStatus ?? this.dailyCountStatus,
    acceptOrder: acceptOrder ?? this.acceptOrder,
    acceptOrderStatus: acceptOrderStatus ?? this.acceptOrderStatus,
    performanceReport: performanceReport ?? this.performanceReport,
    performanceReportStatus:
        performanceReportStatus ?? this.performanceReportStatus,
  );
}
