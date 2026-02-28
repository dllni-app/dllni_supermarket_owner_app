import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repository/home_repo.dart';
import '../../data/models/order_action_model.dart';
import 'home_params.dart';

@lazySingleton
class AcceptOrderUseCase implements UseCase<OrderActionModel, HomeOrderActionParams> {
  final HomeRepo homeRepo;

  AcceptOrderUseCase({required this.homeRepo});

  @override
  DataResponse<OrderActionModel> call(HomeOrderActionParams params) {
    return homeRepo.acceptOrder(params);
  }
}
