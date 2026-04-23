part of 'orders_bloc.dart';

class OrdersState {
  /// 0 when idle; otherwise the [order] id for the in-flight courier handover.
  int courierHandoverLoadingOrderId;
  BlocStatus? courierHandoverStatus;
  CourierHandoverModel? courierHandover;
  BlocStatus? orderDetailsStatus;
  GetOrderDetailsModel? orderDetails;
  BlocStatus? rejectOrderStatus;
  RejectOrderModel? rejectOrder;
  BlocStatus? acceptOrderStatus;
  AcceptOrderModel? acceptOrder;
  PaginationStateModel<GetOrdersModelDataItem>? orders;
  String? errorMessage;

  OrdersState({
    this.courierHandoverLoadingOrderId = 0,
    this.courierHandover,
    this.courierHandoverStatus,
    this.errorMessage,
    this.orders = const PaginationStateModel(perPage: 10),
    this.acceptOrder,
    this.acceptOrderStatus,
    this.rejectOrder,
    this.rejectOrderStatus,
    this.orderDetails,
    this.orderDetailsStatus,
  });

  OrdersState copyWith({
    int? courierHandoverLoadingOrderId,
    CourierHandoverModel? courierHandover,
    BlocStatus? courierHandoverStatus,
    String? errorMessage,
    PaginationStateModel<GetOrdersModelDataItem>? orders,
    AcceptOrderModel? acceptOrder,
    BlocStatus? acceptOrderStatus,
    RejectOrderModel? rejectOrder,
    BlocStatus? rejectOrderStatus,
    GetOrderDetailsModel? orderDetails,
    BlocStatus? orderDetailsStatus,
  }) => OrdersState(
    courierHandoverLoadingOrderId:
        courierHandoverLoadingOrderId ?? this.courierHandoverLoadingOrderId,
    courierHandover: courierHandover ?? this.courierHandover,
    courierHandoverStatus:
        courierHandoverStatus ?? this.courierHandoverStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    orders: orders ?? this.orders,
    acceptOrder: acceptOrder ?? this.acceptOrder,
    acceptOrderStatus: acceptOrderStatus ?? this.acceptOrderStatus,
    rejectOrder: rejectOrder ?? this.rejectOrder,
    rejectOrderStatus: rejectOrderStatus ?? this.rejectOrderStatus,
    orderDetails: orderDetails ?? this.orderDetails,
    orderDetailsStatus: orderDetailsStatus ?? this.orderDetailsStatus,
  );
}
