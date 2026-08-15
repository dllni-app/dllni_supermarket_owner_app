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
import '../../../domain/usecases/get_performance_report_use_case.dart';
import '../../../data/models/get_performance_report_model.dart';
import '../../../domain/usecases/fetch_notifications_use_case.dart';
import '../../../data/models/fetch_notifications_model.dart';
import '../../../domain/usecases/make_read_all_notifications_use_case.dart';
import '../../../data/models/make_read_all_notifications_model.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final MakeReadAllNotificationsUseCase makeReadAllNotificationsUseCase;
  final FetchNotificationsUseCase fetchNotificationsUseCase;
  final GetPerformanceReportUseCase getPerformanceReportUseCase;
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
    this.acceptOrderUseCase,
    this.getPerformanceReportUseCase,
    this.fetchNotificationsUseCase,
    this.makeReadAllNotificationsUseCase,
  ) : super(HomeState()) {
    on<GetDashboardOverviewEvent>(_getDashboardOverview);
    on<GetNewOrdersEvent>(_getNewOrders, transformer: droppableProMax());
    on<GetPreparingOrdersEvent>(_getPreparingOrders, transformer: droppableProMax());
    on<RejectOrderEvent>(_rejectOrder);
    on<GetDailyCountEvent>(_getDailyCount);
    on<AcceptOrderEvent>(_acceptOrder);
    on<GetPerformanceReportEvent>(_getPerformanceReport);
    on<FetchNotificationsEvent>(_fetchNotifications, transformer: droppableProMax());
    on<MakeReadAllNotificationsEvent>(_makeReadAllNotifications);
    on<MakeReadNotificationEvent>(_makeReadNotification);
    on<DeleteNotificationEvent>(_deleteNotification);
    on<DeleteAllNotificationsEvent>(_deleteAllNotifications);
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) => events.transform(ExhaustMapStreamTransformer(mapper));
  }

  FutureOr<void> _getDashboardOverview(GetDashboardOverviewEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dashboardOverviewStatus: BlocStatus.loading));
    final res = await getDashboardOverviewUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(dashboardOverviewStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(dashboardOverviewStatus: BlocStatus.success, dashboardOverview: r)),
    );
  }

  FutureOr<void> _getNewOrders(GetNewOrdersEvent event, Emitter<HomeState> emit) async {
    if (!state.newOrders!.isEndPage || event.isReload) {
      emit(state.copyWith(newOrders: state.newOrders!.setLoading(isReload: event.isReload)));
      final res = await getNewOrdersUseCase(event.params);
      res.fold(
        (l) => emit(state.copyWith(newOrders: state.newOrders!.setFaild(errorMessage: l.message), errorMessage: l.message)),
        (r) => emit(state.copyWith(newOrders: state.newOrders!.setSuccess(data: r.data!))),
      );
    }
  }

  FutureOr<void> _getPreparingOrders(GetPreparingOrdersEvent event, Emitter<HomeState> emit) async {
    if (!state.preparingOrders!.isEndPage || event.isReload) {
      emit(state.copyWith(preparingOrders: state.preparingOrders!.setLoading(isReload: event.isReload)));
      final res = await getPreparingOrdersUseCase(event.params);
      res.fold(
        (l) => emit(state.copyWith(preparingOrders: state.preparingOrders!.setFaild(errorMessage: l.message), errorMessage: l.message)),
        (r) => emit(state.copyWith(preparingOrders: state.preparingOrders!.setSuccess(data: r.data!))),
      );
    }
  }

  FutureOr<void> _rejectOrder(RejectOrderEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(rejectOrderStatus: BlocStatus.loading));
    final res = await rejectOrderUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(rejectOrderStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(rejectOrderStatus: BlocStatus.success, rejectOrder: r)),
    );
  }

  FutureOr<void> _getDailyCount(GetDailyCountEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(dailyCountStatus: BlocStatus.loading));
    final res = await getDailyCountUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(dailyCountStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(dailyCountStatus: BlocStatus.success, dailyCount: r)),
    );
  }

  FutureOr<void> _acceptOrder(AcceptOrderEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(acceptOrderStatus: BlocStatus.loading));
    final res = await acceptOrderUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(acceptOrderStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(acceptOrderStatus: BlocStatus.success, acceptOrder: r)),
    );
  }

  FutureOr<void> _getPerformanceReport(GetPerformanceReportEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(performanceReportStatus: BlocStatus.loading));
    final res = await getPerformanceReportUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(performanceReportStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) => emit(state.copyWith(performanceReportStatus: BlocStatus.success, performanceReport: r)),
    );
  }

  FutureOr<void> _fetchNotifications(FetchNotificationsEvent event, Emitter<HomeState> emit) async {
    if (!state.notifications!.isEndPage || event.isReload) {
      emit(state.copyWith(notifications: state.notifications!.setLoading(isReload: event.isReload)));
      final res = await fetchNotificationsUseCase(event.params);
      res.fold(
        (l) => emit(state.copyWith(notifications: state.notifications!.setFaild(errorMessage: l.message), errorMessage: l.message)),
        (r) => emit(state.copyWith(notifications: state.notifications!.setSuccess(data: r.data!))),
      );
    }
  }

  FetchNotificationsModelDataItem _copyNotificationAsRead(FetchNotificationsModelDataItem item) {
    return FetchNotificationsModelDataItem(
      id: item.id,
      type: item.type,
      title: item.title,
      body: item.body,
      data: item.data,
      readAt: item.readAt ?? DateTime.now().toIso8601String(),
      icon: item.icon,
      createdAt: item.createdAt,
    );
  }

  FutureOr<void> _makeReadAllNotifications(MakeReadAllNotificationsEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(makeReadAllNotificationsStatus: BlocStatus.loading));
    final res = await makeReadAllNotificationsUseCase(event.params);
    res.fold(
      (l) => emit(state.copyWith(makeReadAllNotificationsStatus: BlocStatus.failed, errorMessage: l.message)),
      (r) {
        final updated = state.notifications!.list.map(_copyNotificationAsRead).toList();
        emit(
          state.copyWith(
            makeReadAllNotificationsStatus: BlocStatus.success,
            makeReadAllNotifications: r,
            notifications: state.notifications!.copyWith(list: updated),
          ),
        );
      },
    );
  }

  FutureOr<void> _makeReadNotification(MakeReadNotificationEvent event, Emitter<HomeState> emit) async {
    final id = event.id.trim();
    if (id.isEmpty) return;

    final res = await makeReadAllNotificationsUseCase.readOne(id);
    res.fold(
      (l) => emit(state.copyWith(errorMessage: l.message)),
      (_) {
        final updated = state.notifications!.list
            .map((item) => item.id == id ? _copyNotificationAsRead(item) : item)
            .toList();
        emit(state.copyWith(notifications: state.notifications!.copyWith(list: updated)));
      },
    );
  }

  FutureOr<void> _deleteNotification(DeleteNotificationEvent event, Emitter<HomeState> emit) async {
    final id = event.id.trim();
    if (id.isEmpty) return;

    final res = await makeReadAllNotificationsUseCase.deleteOne(id);
    res.fold(
      (l) {
        emit(state.copyWith(errorMessage: l.message));
        add(FetchNotificationsEvent(params: FetchNotificationsParams(), isReload: true));
      },
      (_) {
        final updated = state.notifications!.list.where((item) => item.id != id).toList();
        emit(state.copyWith(notifications: state.notifications!.copyWith(list: updated)));
      },
    );
  }

  FutureOr<void> _deleteAllNotifications(DeleteAllNotificationsEvent event, Emitter<HomeState> emit) async {
    final res = await makeReadAllNotificationsUseCase.deleteAll();
    res.fold(
      (l) => emit(state.copyWith(errorMessage: l.message)),
      (_) => emit(
        state.copyWith(
          notifications: state.notifications!.copyWith(
            list: const <FetchNotificationsModelDataItem>[],
          ),
        ),
      ),
    );
  }
}
