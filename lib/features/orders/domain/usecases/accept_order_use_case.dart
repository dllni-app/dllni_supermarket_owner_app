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
  final String? note;

  AcceptOrderParams({
    required this.orderId,
    this.preparationTimeMinutes,
    this.note,
  });

  @override
  BodyMap getBody() {
    return {
      if (preparationTimeMinutes != null)
        'preparationTimeMinutes': preparationTimeMinutes,
      if (note != null && note!.trim().isNotEmpty) 'note': note,
    };
  }
}
