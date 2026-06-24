import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/reject_order_model.dart';

@lazySingleton
class RejectOrderUseCase
    implements UseCase<RejectOrderModel, RejectOrderParams> {
  final OrdersRepo orders;

  RejectOrderUseCase({required this.orders});

  @override
  DataResponse<RejectOrderModel> call(RejectOrderParams params) {
    return orders.rejectOrder(params);
  }
}

class RejectOrderParams with Params {
  final int orderId;
  final String reason;
  final String message;

  RejectOrderParams({
    required this.reason,
    required this.message,
    required this.orderId,
  });

  @override
  BodyMap getBody() {
    return <String, dynamic>{
      'reason': reason,
      'message': message,
    };
  }
}
