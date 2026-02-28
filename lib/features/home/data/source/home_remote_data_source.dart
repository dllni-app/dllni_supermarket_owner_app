import 'package:common_package/helpers/api_handler.dart';
import 'package:common_package/helpers/dio_network.dart';
import 'package:injectable/injectable.dart';

import '../models/dashboard_model.dart';
import '../models/low_stock_model.dart';
import '../models/order_action_model.dart';
import '../models/orders_list_model.dart';
import '../../domain/usecases/home_params.dart';

@lazySingleton
class HomeRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  HomeRemoteDataSource({required this.dioNetwork});

  Future<DashboardModel> getDashboard(HomeStoreParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/store-owner/dashboard',
        params: params.getParams(),
      ),
      jsonConvert: dashboardModelFromJson,
    );
  }

  Future<LowStockModel> getLowStock(HomeStoreParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/store-owner/products/low-stock',
        params: params.getParamsLowStock(),
      ),
      jsonConvert: lowStockModelFromJson,
    );
  }

  Future<OrdersListModel> getOrdersByStatus(HomeOrdersParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/sm-orders',
        params: params.getParams(),
      ),
      jsonConvert: ordersListModelFromJson,
    );
  }

  Future<OrderActionModel> acceptOrder(HomeOrderActionParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/store-owner/orders/${params.orderId}/accept',
        data: const {},
      ),
      jsonConvert: orderActionModelFromJson,
    );
  }

  Future<OrderActionModel> rejectOrder(HomeRejectOrderParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/store-owner/orders/${params.orderId}/reject',
        data: params.getBody(),
      ),
      jsonConvert: orderActionModelFromJson,
    );
  }
}
