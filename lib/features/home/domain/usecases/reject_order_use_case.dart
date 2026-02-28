import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repository/home_repo.dart';
import '../../data/models/order_action_model.dart';
import 'home_params.dart';

@lazySingleton
class RejectOrderUseCase implements UseCase<OrderActionModel, HomeRejectOrderParams> {
  final HomeRepo homeRepo;

  RejectOrderUseCase({required this.homeRepo});

  @override
  DataResponse<OrderActionModel> call(HomeRejectOrderParams params) {
    return homeRepo.rejectOrder(params);
  }
}
