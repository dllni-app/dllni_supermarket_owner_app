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
