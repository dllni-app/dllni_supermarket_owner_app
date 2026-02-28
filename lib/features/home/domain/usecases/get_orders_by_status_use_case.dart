import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repository/home_repo.dart';
import '../../data/models/orders_list_model.dart';
import 'home_params.dart';

@lazySingleton
class GetOrdersByStatusUseCase implements UseCase<OrdersListModel, HomeOrdersParams> {
  final HomeRepo homeRepo;

  GetOrdersByStatusUseCase({required this.homeRepo});

  @override
  DataResponse<OrdersListModel> call(HomeOrdersParams params) {
    return homeRepo.getOrdersByStatus(params);
  }
}
