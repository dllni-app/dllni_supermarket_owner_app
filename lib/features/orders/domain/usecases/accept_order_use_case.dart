import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/accept_order_model.dart';

@lazySingleton
class AcceptOrderUseCase
    implements UseCase<AcceptOrderModel, AcceptOrderParams> {
  final OrdersRepo orders;

  AcceptOrderUseCase({required this.orders});

  @override
  DataResponse<AcceptOrderModel> call(AcceptOrderParams params) {
    return orders.acceptOrder(params);
  }
}

class AcceptOrderParams with Params {
  final int orderId;
  final int? preparationTimeMinutes;

  const AcceptOrderParams({
    required this.orderId,
    this.preparationTimeMinutes,
  });

  @override
  BodyMap getBody() => {
        'preparationTimeMinutes': preparationTimeMinutes,
      }..removeWhere((key, value) => value == null);
}
