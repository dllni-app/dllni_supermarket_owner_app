part of 'home_bloc.dart';

abstract class HomeEvent {}

class GetDashboardOverviewEvent extends HomeEvent {
  final GetDashboardOverviewParams params;

  GetDashboardOverviewEvent({required this.params});
}

class GetNewOrdersEvent extends HomeEvent with EventWithReload {
  final GetNewOrdersParams params;

  @override
  final bool isReload;

  GetNewOrdersEvent({required this.params, this.isReload = false});
}

class GetPreparingOrdersEvent extends HomeEvent with EventWithReload {
  final GetPreparingOrdersParams params;

  @override
  final bool isReload;

  GetPreparingOrdersEvent({required this.params, this.isReload = false});
}

class RejectOrderEvent extends HomeEvent {
  final RejectOrderParams params;

  RejectOrderEvent({required this.params});
}

class GetDailyCountEvent extends HomeEvent {
  final GetDailyCountParams params;

  GetDailyCountEvent({required this.params});
}

class AcceptOrderEvent extends HomeEvent {
  final AcceptOrderParams params;

  AcceptOrderEvent({required this.params});
}

class GetPerformanceReportEvent extends HomeEvent {
  final GetPerformanceReportParams params;

  GetPerformanceReportEvent({required this.params});
}

class FetchNotificationsEvent extends HomeEvent with EventWithReload {
  final FetchNotificationsParams params;

  @override
  final bool isReload;

  FetchNotificationsEvent({required this.params, this.isReload = false});
}

class MakeReadAllNotificationsEvent extends HomeEvent {
  final MakeReadAllNotificationsParams params;

  MakeReadAllNotificationsEvent({required this.params});
}
