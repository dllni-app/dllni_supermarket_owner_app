import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_orders_use_case.dart';
import '../../data/models/get_orders_model.dart';
import '../usecases/accept_order_use_case.dart';
import '../../data/models/accept_order_model.dart';
import '../usecases/reject_order_use_case.dart';
import '../../data/models/reject_order_model.dart';
import '../usecases/get_order_details_use_case.dart';
import '../../data/models/get_order_details_model.dart';
import '../usecases/courier_handover_use_case.dart';
import '../../data/models/courier_handover_model.dart';
import '../usecases/get_order_counts_use_case.dart';
import '../../data/models/get_order_counts_model.dart';

abstract class OrdersRepo {
  DataResponse<GetOrdersModel> getOrders(GetOrdersParams params);

  DataResponse<AcceptOrderModel> acceptOrder(AcceptOrderParams params);

  DataResponse<RejectOrderModel> rejectOrder(RejectOrderParams params);

  DataResponse<GetOrderDetailsModel> getOrderDetails(GetOrderDetailsParams params);

  DataResponse<CourierHandoverModel> courierHandover(CourierHandoverParams params);

  DataResponse<GetOrderCountsModel> getOrderCounts(GetOrderCountsParams params);
}
