import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import 'package:common_package/helpers/droppable_helper.dart';
import '../../../domain/usecases/get_orders_use_case.dart';
import '../../../data/models/get_orders_model.dart';
import '../../../domain/usecases/accept_order_use_case.dart';
import '../../../data/models/accept_order_model.dart';
import '../../../domain/usecases/reject_order_use_case.dart';
import '../../../data/models/reject_order_model.dart';
import '../../../domain/usecases/get_order_details_use_case.dart';
import '../../../data/models/get_order_details_model.dart';
import '../../../domain/usecases/courier_handover_use_case.dart';
import '../../../data/models/courier_handover_model.dart';

part 'orders_event.dart';
part 'orders_state.dart';

@injectable
class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final GetOrderDetailsUseCase getOrderDetailsUseCase;
  final RejectOrderUseCase rejectOrderUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  final GetOrdersUseCase getOrdersUseCase;
  final CourierHandoverUseCase courierHandoverUseCase;

  OrdersBloc(
    this.getOrdersUseCase,
    this.acceptOrderUseCase,
    this.rejectOrderUseCase,
    this.getOrderDetailsUseCase,
    this.courierHandoverUseCase,
  ) : super(OrdersState()) {
    
  
    on<GetOrdersEvent>(_getOrders, transformer: droppableProMax());
    on<AcceptOrderEvent>(_acceptOrder);
    on<RejectOrderEvent>(_rejectOrder);
    on<GetOrderDetailsEvent>(_getOrderDetails);
    on<CourierHandoverEvent>(_courierHandover);
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getOrders(GetOrdersEvent event, Emitter<OrdersState> emit) async {
    if (!state.orders!.isEndPage || event.isReload) {
      emit(state.copyWith(
        orders: state.orders!.setLoading(isReload: event.isReload),
      ));
      final res = await getOrdersUseCase(event.params);
      res.fold((l) {
        emit(state.copyWith(
          orders: state.orders!.setFaild(errorMessage: l.message),
          errorMessage: l.message,
        ));
      }, (r) {
        emit(state.copyWith(
          orders: state.orders!.setSuccess(data: r.data!),
        ));
      });
    }
  }

  FutureOr<void> _acceptOrder(AcceptOrderEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(acceptOrderStatus: BlocStatus.loading));
    final res = await acceptOrderUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        acceptOrderStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        acceptOrderStatus: BlocStatus.success,
        acceptOrder: r,
      ));
    });
  }

  FutureOr<void> _rejectOrder(RejectOrderEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(rejectOrderStatus: BlocStatus.loading));
    final res = await rejectOrderUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        rejectOrderStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        rejectOrderStatus: BlocStatus.success,
        rejectOrder: r,
      ));
    });
  }

  FutureOr<void> _getOrderDetails(GetOrderDetailsEvent event, Emitter<OrdersState> emit) async {
    emit(state.copyWith(orderDetailsStatus: BlocStatus.loading));
    final res = await getOrderDetailsUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        orderDetailsStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        orderDetailsStatus: BlocStatus.success,
        orderDetails: r,
      ));
    });
  }

  FutureOr<void> _courierHandover(
    CourierHandoverEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(
      state.copyWith(
        courierHandoverStatus: BlocStatus.loading,
        courierHandoverLoadingOrderId: event.params.orderId,
      ),
    );
    final res = await courierHandoverUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        courierHandoverStatus: BlocStatus.failed,
        errorMessage: l.message,
        courierHandoverLoadingOrderId: 0,
      ));
    }, (r) {
      emit(state.copyWith(
        courierHandoverStatus: BlocStatus.success,
        courierHandover: r,
        courierHandoverLoadingOrderId: 0,
      ));
      add(
        GetOrdersEvent(
          isReload: true,
          params: GetOrdersParams(
            page: 1,
            status: event.ordersListStatus,
          ),
        ),
      );
    });
  }
}

