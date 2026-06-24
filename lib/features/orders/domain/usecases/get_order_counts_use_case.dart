import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/get_order_counts_model.dart';

@lazySingleton
class GetOrderCountsUseCase implements UseCase<GetOrderCountsModel, GetOrderCountsParams> {

  final OrdersRepo orders;

  GetOrderCountsUseCase({required this.orders});

  @override
  DataResponse<GetOrderCountsModel> call(GetOrderCountsParams params) {
    return orders.getOrderCounts(params);
  }
}

class GetOrderCountsParams with Params{}
