import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/get_order_details_model.dart';

@lazySingleton
class GetOrderDetailsUseCase
    implements UseCase<GetOrderDetailsModel, GetOrderDetailsParams> {
  final OrdersRepo orders;

  GetOrderDetailsUseCase({required this.orders});

  @override
  DataResponse<GetOrderDetailsModel> call(GetOrderDetailsParams params) {
    return orders.getOrderDetails(params);
  }
}

class GetOrderDetailsParams with Params {
  final int orderId;

  GetOrderDetailsParams({required this.orderId});
}
