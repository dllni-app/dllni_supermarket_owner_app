import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/get_new_orders_model.dart';

@lazySingleton
class GetNewOrdersUseCase
    implements UseCase<GetNewOrdersModel, GetNewOrdersParams> {
  final HomeRepo home;

  GetNewOrdersUseCase({required this.home});

  @override
  DataResponse<GetNewOrdersModel> call(GetNewOrdersParams params) {
    return home.getNewOrders(params);
  }
}

class GetNewOrdersParams with Params {
  @override
  QueryParams getParams() => {"filter[status]": "pending"};
}
