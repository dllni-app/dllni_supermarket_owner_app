import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/get_orders_model.dart';

@lazySingleton
class GetOrdersUseCase implements UseCase<GetOrdersModel, GetOrdersParams> {
  final OrdersRepo orders;

  GetOrdersUseCase({required this.orders});

  @override
  DataResponse<GetOrdersModel> call(GetOrdersParams params) {
    return orders.getOrders(params);
  }
}

class GetOrdersParams with Params {
  final String? status;
  final int page;

  GetOrdersParams({this.status, this.page = 1});

  @override
  getParams() {
    return {"page": page, if (status != null) "filter[status]": status};
  }
}
