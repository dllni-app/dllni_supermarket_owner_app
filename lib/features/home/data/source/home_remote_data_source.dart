import 'package:common_package/helpers/dio_network.dart';
import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/api_handler.dart';
import '../models/get_dashboard_overview_model.dart';
import '../../domain/usecases/get_dashboard_overview_use_case.dart';
import '../models/get_new_orders_model.dart';
import '../../domain/usecases/get_new_orders_use_case.dart';
import '../models/get_preparing_orders_model.dart';
import '../../domain/usecases/get_preparing_orders_use_case.dart';
import '../models/reject_order_model.dart';
import '../../domain/usecases/reject_order_use_case.dart';
import '../models/get_daily_count_model.dart';
import '../../domain/usecases/get_daily_count_use_case.dart';
import '../models/accept_order_model.dart';
import '../../domain/usecases/accept_order_use_case.dart';

@lazySingleton
class HomeRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  HomeRemoteDataSource({required this.dioNetwork});

  Future<GetDashboardOverviewModel> getDashboardOverview(
    GetDashboardOverviewParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/dashboard',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getDashboardOverviewModelFromJson,
    );
  }

  Future<GetNewOrdersModel> getNewOrders(GetNewOrdersParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getNewOrdersModelFromJson,
    );
  }

  Future<GetPreparingOrdersModel> getPreparingOrders(
    GetPreparingOrdersParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getPreparingOrdersModelFromJson,
    );
  }

  Future<RejectOrderModel> rejectOrder(RejectOrderParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/store-owner/orders/${params.orderId}/reject',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: rejectOrderModelFromJson,
    );
  }

  Future<GetDailyCountModel> getDailyCount(GetDailyCountParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders/hourly-count',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getDailyCountModelFromJson,
    );
  }

  Future<AcceptOrderModel> acceptOrder(AcceptOrderParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/store-owner/orders/${params.orderId}/accept',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: acceptOrderModelFromJson,
    );
  }
}
