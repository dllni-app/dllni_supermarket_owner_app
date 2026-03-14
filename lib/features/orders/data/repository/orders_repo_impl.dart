import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/orders_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/orders_remote_data_source.dart';
import '../../domain/usecases/get_orders_use_case.dart';
import '../models/get_orders_model.dart';
import '../../domain/usecases/accept_order_use_case.dart';
import '../models/accept_order_model.dart';
import '../../domain/usecases/reject_order_use_case.dart';
import '../models/reject_order_model.dart';
import '../../domain/usecases/get_order_details_use_case.dart';
import '../models/get_order_details_model.dart';

@LazySingleton(as: OrdersRepo)
class OrdersRepoImpl with HandlingException implements OrdersRepo {
  final OrdersRemoteDataSource ordersRemoteDataSource;

  OrdersRepoImpl({required this.ordersRemoteDataSource});

  @override
  DataResponse<GetOrdersModel> getOrders(GetOrdersParams params) {
    return wrapHandlingException(
      tryCall: () => ordersRemoteDataSource.getOrders(params),
    );
  }

  @override
  DataResponse<AcceptOrderModel> acceptOrder(AcceptOrderParams params) {
    return wrapHandlingException(
      tryCall: () => ordersRemoteDataSource.acceptOrder(params),
    );
  }

  @override
  DataResponse<RejectOrderModel> rejectOrder(RejectOrderParams params) {
    return wrapHandlingException(
      tryCall: () => ordersRemoteDataSource.rejectOrder(params),
    );
  }


  @override
  DataResponse<GetOrderDetailsModel> getOrderDetails(GetOrderDetailsParams params) {
    return wrapHandlingException(
      tryCall: () => ordersRemoteDataSource.getOrderDetails(params),
    );
  }}

