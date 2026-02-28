import 'dart:async';

import 'package:common_package/helpers/pagination_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/dashboard_model.dart';
import '../../../data/models/low_stock_model.dart';
import '../../../data/models/orders_list_model.dart';
import '../../../domain/usecases/accept_order_use_case.dart';
import '../../../domain/usecases/get_dashboard_use_case.dart';
import '../../../domain/usecases/get_low_stock_use_case.dart';
import '../../../domain/usecases/get_orders_by_status_use_case.dart';
import '../../../domain/usecases/home_params.dart';
import '../../../domain/usecases/reject_order_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final GetDashboardUseCase getDashboardUseCase;
  final GetLowStockUseCase getLowStockUseCase;
  final GetOrdersByStatusUseCase getOrdersByStatusUseCase;
  final AcceptOrderUseCase acceptOrderUseCase;
  final RejectOrderUseCase rejectOrderUseCase;

  HomeBloc(
    this.getDashboardUseCase,
    this.getLowStockUseCase,
    this.getOrdersByStatusUseCase,
    this.acceptOrderUseCase,
    this.rejectOrderUseCase,
  ) : super(HomeState()) {
    on<HomeLoadEvent>(_onLoad);
    on<HomeRefreshEvent>(_onRefresh);
    on<HomeAcceptOrderEvent>(_onAcceptOrder);
    on<HomeRejectOrderEvent>(_onRejectOrder);
  }

  Future<void> _onLoad(HomeLoadEvent event, Emitter<HomeState> emit) async {
    await _loadAll(event.storeId, emit);
  }

  Future<void> _onRefresh(HomeRefreshEvent event, Emitter<HomeState> emit) async {
    await _loadAll(event.storeId, emit);
  }

  Future<void> _loadAll(int storeId, Emitter<HomeState> emit) async {
    emit(state.copyWith(
      dashboardStatus: BlocStatus.loading,
      lowStockStatus: BlocStatus.loading,
      pendingOrdersStatus: BlocStatus.loading,
      preparingOrdersStatus: BlocStatus.loading,
      errorMessage: '',
      storeId: storeId,
    ));

    final dashboardRes = await getDashboardUseCase(HomeStoreParams(storeId: storeId));
    dashboardRes.fold(
      (l) => emit(state.copyWith(dashboardStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(dashboardStatus: BlocStatus.success, dashboard: r)),
    );

    final lowStockRes = await getLowStockUseCase(HomeStoreParams(storeId: storeId));
    lowStockRes.fold(
      (l) => emit(state.copyWith(lowStockStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(lowStockStatus: BlocStatus.success, lowStock: r)),
    );

    final pendingRes = await getOrdersByStatusUseCase(HomeOrdersParams(storeId: storeId, status: 'pending'));
    pendingRes.fold(
      (l) => emit(state.copyWith(pendingOrdersStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(pendingOrdersStatus: BlocStatus.success, pendingOrders: r)),
    );

    final preparingRes = await getOrdersByStatusUseCase(HomeOrdersParams(storeId: storeId, status: 'preparing'));
    preparingRes.fold(
      (l) => emit(state.copyWith(preparingOrdersStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(preparingOrdersStatus: BlocStatus.success, preparingOrders: r)),
    );
  }

  Future<void> _onAcceptOrder(HomeAcceptOrderEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(actionStatus: BlocStatus.loading, actionMessage: ''));
    final res = await acceptOrderUseCase(HomeOrderActionParams(orderId: event.orderId));
    res.fold(
      (l) => emit(state.copyWith(actionStatus: BlocStatus.failed, actionMessage: l.message)),
      (r) => emit(state.copyWith(actionStatus: BlocStatus.success, actionMessage: r.message ?? 'تم قبول الطلب')),
    );
    if (state.storeId != null) {
      await _loadAll(state.storeId!, emit);
    }
  }

  Future<void> _onRejectOrder(HomeRejectOrderEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(actionStatus: BlocStatus.loading, actionMessage: ''));
    final res = await rejectOrderUseCase(
      HomeRejectOrderParams(
        orderId: event.orderId,
        reason: event.reason,
        rejectionType: event.rejectionType,
      ),
    );
    res.fold(
      (l) => emit(state.copyWith(actionStatus: BlocStatus.failed, actionMessage: l.message)),
      (r) => emit(state.copyWith(actionStatus: BlocStatus.success, actionMessage: r.message ?? 'تم رفض الطلب')),
    );
    if (state.storeId != null) {
      await _loadAll(state.storeId!, emit);
    }
  }
}
