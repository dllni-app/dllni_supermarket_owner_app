import 'package:common_package/helpers/typedef.dart';

import '../../data/models/dashboard_model.dart';
import '../../data/models/low_stock_model.dart';
import '../../data/models/order_action_model.dart';
import '../../data/models/orders_list_model.dart';
import '../usecases/home_params.dart';

abstract class HomeRepo {
  DataResponse<DashboardModel> getDashboard(HomeStoreParams params);
  DataResponse<LowStockModel> getLowStock(HomeStoreParams params);
  DataResponse<OrdersListModel> getOrdersByStatus(HomeOrdersParams params);
  DataResponse<OrderActionModel> acceptOrder(HomeOrderActionParams params);
  DataResponse<OrderActionModel> rejectOrder(HomeRejectOrderParams params);
}
