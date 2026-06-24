part of 'orders_bloc.dart';

abstract class OrdersEvent {}

class GetOrdersEvent extends OrdersEvent with EventWithReload {
  final GetOrdersParams params;

  @override
  final bool isReload;

  GetOrdersEvent({required this.params, this.isReload = false});
}

class AcceptOrderEvent extends OrdersEvent {
  final AcceptOrderParams params;

  AcceptOrderEvent({required this.params});
}

class RejectOrderEvent extends OrdersEvent {
  final RejectOrderParams params;

  RejectOrderEvent({required this.params});
}

class GetOrderDetailsEvent extends OrdersEvent {
  final GetOrderDetailsParams params;

  GetOrderDetailsEvent({required this.params});
}

class CourierHandoverEvent extends OrdersEvent {
  final CourierHandoverParams params;
  final String? ordersListStatus;

  CourierHandoverEvent({
    required this.params,
    this.ordersListStatus,
  });
}

class GetOrderCountsEvent extends OrdersEvent {
  final GetOrderCountsParams params;

  GetOrderCountsEvent({required this.params});
}
