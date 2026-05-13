import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';
import '../models/get_orders_model.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../models/accept_order_model.dart';
import '../../domain/usecases/accept_order_use_case.dart';
import '../models/reject_order_model.dart';
import '../../domain/usecases/reject_order_use_case.dart';
import '../models/get_order_details_model.dart';
import '../../domain/usecases/get_order_details_use_case.dart';
import '../models/courier_handover_model.dart';
import '../../domain/usecases/courier_handover_use_case.dart';

@lazySingleton
class OrdersRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  OrdersRemoteDataSource({required this.dioNetwork});

  Future<GetOrdersModel> getOrders(GetOrdersParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getOrdersModelFromJson,
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

  Future<GetOrderDetailsModel> getOrderDetails(GetOrderDetailsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders/${params.orderId}',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getOrderDetailsModelFromJson,
    );
  }

  Future<CourierHandoverModel> courierHandover(CourierHandoverParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint:
            '/api/v1/store-owner/orders/${params.orderId}/courier-handover',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: courierHandoverModelFromJson,
    );
  }
}
