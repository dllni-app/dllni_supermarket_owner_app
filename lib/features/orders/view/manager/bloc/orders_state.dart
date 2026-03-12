part of 'orders_bloc.dart';

class OrdersState {
  BlocStatus? rejectOrderStatus;
  RejectOrderModel? rejectOrder;
  BlocStatus? acceptOrderStatus;
  AcceptOrderModel? acceptOrder;
  PaginationStateModel<GetOrdersModelDataItem>? orders;
  String? errorMessage;

  OrdersState({
    this.errorMessage,
    this.orders = const PaginationStateModel(perPage: 10),
    this.acceptOrder,
    this.acceptOrderStatus,
    this.rejectOrder,
    this.rejectOrderStatus,
  });

  OrdersState copyWith({
    String? errorMessage,
    PaginationStateModel<GetOrdersModelDataItem>? orders,
    AcceptOrderModel? acceptOrder,
    BlocStatus? acceptOrderStatus,
    RejectOrderModel? rejectOrder,
    BlocStatus? rejectOrderStatus,
  }) => OrdersState(
    errorMessage: errorMessage ?? this.errorMessage,
    orders: orders ?? this.orders,
    acceptOrder: acceptOrder ?? this.acceptOrder,
    acceptOrderStatus: acceptOrderStatus ?? this.acceptOrderStatus,
    rejectOrder: rejectOrder ?? this.rejectOrder,
    rejectOrderStatus: rejectOrderStatus ?? this.rejectOrderStatus,
  );
}
