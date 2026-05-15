import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/home_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/home_remote_data_source.dart';
import '../../domain/usecases/get_dashboard_overview_use_case.dart';
import '../models/get_dashboard_overview_model.dart';
import '../../domain/usecases/get_new_orders_use_case.dart';
import '../models/get_new_orders_model.dart';
import '../../domain/usecases/get_preparing_orders_use_case.dart';
import '../models/get_preparing_orders_model.dart';
import '../../domain/usecases/reject_order_use_case.dart';
import '../models/reject_order_model.dart';
import '../../domain/usecases/get_daily_count_use_case.dart';
import '../models/get_daily_count_model.dart';
import '../../domain/usecases/accept_order_use_case.dart';
import '../models/accept_order_model.dart';
import '../../domain/usecases/get_performance_report_use_case.dart';
import '../models/get_performance_report_model.dart';
import '../../domain/usecases/fetch_notifications_use_case.dart';
import '../models/fetch_notifications_model.dart';
import '../../domain/usecases/make_read_all_notifications_use_case.dart';
import '../models/make_read_all_notifications_model.dart';

@LazySingleton(as: HomeRepo)
class HomeRepoImpl with HandlingException implements HomeRepo {
  final HomeRemoteDataSource homeRemoteDataSource;

  HomeRepoImpl({required this.homeRemoteDataSource});

  @override
  DataResponse<GetDashboardOverviewModel> getDashboardOverview(GetDashboardOverviewParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.getDashboardOverview(params),
    );
  }

  @override
  DataResponse<GetNewOrdersModel> getNewOrders(GetNewOrdersParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.getNewOrders(params),
    );
  }

  @override
  DataResponse<GetPreparingOrdersModel> getPreparingOrders(GetPreparingOrdersParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.getPreparingOrders(params),
    );
  }

  @override
  DataResponse<RejectOrderModel> rejectOrder(RejectOrderParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.rejectOrder(params),
    );
  }

  @override
  DataResponse<GetDailyCountModel> getDailyCount(GetDailyCountParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.getDailyCount(params),
    );
  }

  @override
  DataResponse<AcceptOrderModel> acceptOrder(AcceptOrderParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.acceptOrder(params),
    );
  }

  @override
  DataResponse<GetPerformanceReportModel> getPerformanceReport(GetPerformanceReportParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.getPerformanceReport(params),
    );
  }


  @override
  DataResponse<FetchNotificationsModel> fetchNotifications(FetchNotificationsParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.fetchNotifications(params),
    );
  }

  @override
  DataResponse<MakeReadAllNotificationsModel> makeReadAllNotifications(MakeReadAllNotificationsParams params) {
    return wrapHandlingException(
      tryCall: () => homeRemoteDataSource.makeReadAllNotifications(params),
    );
  }}

