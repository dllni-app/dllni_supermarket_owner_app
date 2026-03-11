import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_dashboard_overview_use_case.dart';
import '../../data/models/get_dashboard_overview_model.dart';
import '../usecases/get_new_orders_use_case.dart';
import '../../data/models/get_new_orders_model.dart';
import '../usecases/get_preparing_orders_use_case.dart';
import '../../data/models/get_preparing_orders_model.dart';
import '../usecases/reject_order_use_case.dart';
import '../../data/models/reject_order_model.dart';
import '../usecases/get_daily_count_use_case.dart';
import '../../data/models/get_daily_count_model.dart';
import '../usecases/accept_order_use_case.dart';
import '../../data/models/accept_order_model.dart';
abstract class HomeRepo {
  DataResponse<GetDashboardOverviewModel> getDashboardOverview(GetDashboardOverviewParams params);

  DataResponse<GetNewOrdersModel> getNewOrders(GetNewOrdersParams params);

  DataResponse<GetPreparingOrdersModel> getPreparingOrders(GetPreparingOrdersParams params);

  DataResponse<RejectOrderModel> rejectOrder(RejectOrderParams params);

  DataResponse<GetDailyCountModel> getDailyCount(GetDailyCountParams params);

  DataResponse<AcceptOrderModel> acceptOrder(AcceptOrderParams params);
}
