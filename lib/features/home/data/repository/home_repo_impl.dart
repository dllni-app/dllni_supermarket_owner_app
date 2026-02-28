import 'package:common_package/helpers/error_handler.dart';
import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/home_repo.dart';
import '../../domain/usecases/home_params.dart';
import '../models/dashboard_model.dart';
import '../models/low_stock_model.dart';
import '../models/order_action_model.dart';
import '../models/orders_list_model.dart';
import '../source/home_remote_data_source.dart';

@LazySingleton(as: HomeRepo)
class HomeRepoImpl with HandlingException implements HomeRepo {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepoImpl({required this.remoteDataSource});

  @override
  DataResponse<DashboardModel> getDashboard(HomeStoreParams params) {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.getDashboard(params),
    );
  }

  @override
  DataResponse<LowStockModel> getLowStock(HomeStoreParams params) {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.getLowStock(params),
    );
  }

  @override
  DataResponse<OrdersListModel> getOrdersByStatus(HomeOrdersParams params) {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.getOrdersByStatus(params),
    );
  }

  @override
  DataResponse<OrderActionModel> acceptOrder(HomeOrderActionParams params) {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.acceptOrder(params),
    );
  }

  @override
  DataResponse<OrderActionModel> rejectOrder(HomeRejectOrderParams params) {
    return wrapHandlingException(
      tryCall: () => remoteDataSource.rejectOrder(params),
    );
  }
}
