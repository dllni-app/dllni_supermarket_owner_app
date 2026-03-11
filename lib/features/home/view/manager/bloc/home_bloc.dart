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
import '../../../domain/usecases/get_daily_count_use_case.dart';
import '../../../data/models/get_daily_count_model.dart';
import '../../../domain/usecases/accept_order_use_case.dart';
import '../../../data/models/accept_order_model.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final AcceptOrderUseCase acceptOrderUseCase;
  final GetDailyCountUseCase getDailyCountUseCase;
  final RejectOrderUseCase rejectOrderUseCase;
  final GetPreparingOrdersUseCase getPreparingOrdersUseCase;
  final GetNewOrdersUseCase getNewOrdersUseCase;
  final GetDashboardOverviewUseCase getDashboardOverviewUseCase;
  HomeBloc(
    this.getDashboardOverviewUseCase,
    this.getNewOrdersUseCase,
    this.getPreparingOrdersUseCase,
    this.rejectOrderUseCase,
    this.getDailyCountUseCase,
    this.acceptOrderUseCase,) : super(HomeState()) {
    
  
    on<GetDashboardOverviewEvent>(_getDashboardOverview);
    on<GetNewOrdersEvent>(_getNewOrders, transformer: droppableProMax());
    on<GetPreparingOrdersEvent>(_getPreparingOrders, transformer: droppableProMax());
    on<RejectOrderEvent>(_rejectOrder);
    on<GetDailyCountEvent>(_getDailyCount);
    on<AcceptOrderEvent>(_acceptOrder);}


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
  }

  FutureOr<void> _getDailyCount(GetDailyCountEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dailyCountStatus: BlocStatus.loading));
    final res = await getDailyCountUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        dailyCountStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        dailyCountStatus: BlocStatus.success,
        dailyCount: r,
      ));
    });
  }

  FutureOr<void> _acceptOrder(AcceptOrderEvent event, Emitter<HomeState> emit) async {
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
  }}
