import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/reject_order_model.dart';

@lazySingleton
class RejectOrderUseCase
    implements UseCase<RejectOrderModel, RejectOrderParams> {
  final HomeRepo home;

  RejectOrderUseCase({required this.home});

  @override
  DataResponse<RejectOrderModel> call(RejectOrderParams params) {
    return home.rejectOrder(params);
  }
}

class RejectOrderParams with Params {
  final int orderId;
  final String rejectType, reason;

  RejectOrderParams({
    required this.rejectType,
    required this.reason,
    required this.orderId,
  });

  @override
  BodyMap getBody() => {"rejectionType": rejectType, "reason": reason};
}
