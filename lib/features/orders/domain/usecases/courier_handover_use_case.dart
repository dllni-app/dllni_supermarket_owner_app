import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/orders_repo.dart';
import '../../data/models/courier_handover_model.dart';

@lazySingleton
class CourierHandoverUseCase
    implements UseCase<CourierHandoverModel, CourierHandoverParams> {
  final OrdersRepo orders;

  CourierHandoverUseCase({required this.orders});

  @override
  DataResponse<CourierHandoverModel> call(CourierHandoverParams params) {
    return orders.courierHandover(params);
  }
}

class CourierHandoverParams with Params {
  final int orderId;
  final String? note;

  CourierHandoverParams({required this.orderId, this.note});

  @override
  BodyMap getBody() {
    return {
      if (note != null && note!.trim().isNotEmpty) 'note': note,
    };
  }
}
