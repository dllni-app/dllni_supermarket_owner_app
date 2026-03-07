import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import '../../../domain/usecases/get_dashboard_overview_use_case.dart';
import '../../../data/models/get_dashboard_overview_model.dart';
import 'package:common_package/helpers/droppable_helper.dart';
import '../../../domain/usecases/get_new_orders_use_case.dart';
import '../../../data/models/get_new_orders_model.dart';
import '../../../domain/usecases/get_preparing_orders_use_case.dart';
import '../../../data/models/get_preparing_orders_model.dart';
import '../../../domain/usecases/reject_order_use_case.dart';
import '../../../data/models/reject_order_model.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final RejectOrderUseCase rejectOrderUseCase;
  final GetPreparingOrdersUseCase getPreparingOrdersUseCase;
  final GetNewOrdersUseCase getNewOrdersUseCase;
  final GetDashboardOverviewUseCase getDashboardOverviewUseCase;
  HomeBloc(
    this.getDashboardOverviewUseCase,
    this.getNewOrdersUseCase,
    this.getPreparingOrdersUseCase,
    this.rejectOrderUseCase,) : super(HomeState()) {
    
  
    on<GetDashboardOverviewEvent>(_getDashboardOverview);
    on<GetNewOrdersEvent>(_getNewOrders, transformer: droppableProMax());
    on<GetPreparingOrdersEvent>(_getPreparingOrders, transformer: droppableProMax());
    on<RejectOrderEvent>(_rejectOrder);}


  FutureOr<void> _getDashboardOverview(GetDashboardOverviewEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dashboardOverviewStatus: BlocStatus.loading));
    final res = await getDashboardOverviewUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        dashboardOverviewStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        dashboardOverviewStatus: BlocStatus.success,
        dashboardOverview: r,
      ));
    });
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getNewOrders(GetNewOrdersEvent event, Emitter<HomeState> emit) async {
    if (!state.newOrders!.isEndPage || event.isReload) {
      emit(state.copyWith(
        newOrders: state.newOrders!.setLoading(isReload: event.isReload),
      ));
      final res = await getNewOrdersUseCase(event.params);
      res.fold((l) {
        emit(state.copyWith(
          newOrders: state.newOrders!.setFaild(errorMessage: l.message),
          errorMessage: l.message,
        ));
      }, (r) {
        emit(state.copyWith(
          newOrders: state.newOrders!.setSuccess(data: r.data!),
        ));
      });
    }
  }

  FutureOr<void> _getPreparingOrders(GetPreparingOrdersEvent event, Emitter<HomeState> emit) async {
    if (!state.preparingOrders!.isEndPage || event.isReload) {
      emit(state.copyWith(
        preparingOrders: state.preparingOrders!.setLoading(isReload: event.isReload),
      ));
      final res = await getPreparingOrdersUseCase(event.params);
      res.fold((l) {
        emit(state.copyWith(
          preparingOrders: state.preparingOrders!.setFaild(errorMessage: l.message),
          errorMessage: l.message,
        ));
      }, (r) {
        emit(state.copyWith(
          preparingOrders: state.preparingOrders!.setSuccess(data: r.data!),
        ));
      });
    }
  }

  FutureOr<void> _rejectOrder(RejectOrderEvent event, Emitter<HomeState> emit) async {
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
  }}
