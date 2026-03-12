import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_orders_use_case.dart';
import '../../data/models/get_orders_model.dart';
import '../usecases/accept_order_use_case.dart';
import '../../data/models/accept_order_model.dart';
import '../usecases/reject_order_use_case.dart';
import '../../data/models/reject_order_model.dart';
abstract class OrdersRepo {
  DataResponse<GetOrdersModel> getOrders(GetOrdersParams params);

  DataResponse<AcceptOrderModel> acceptOrder(AcceptOrderParams params);

  DataResponse<RejectOrderModel> rejectOrder(RejectOrderParams params);
}
