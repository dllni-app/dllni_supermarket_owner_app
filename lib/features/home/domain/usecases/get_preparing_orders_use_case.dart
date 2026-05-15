import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/get_preparing_orders_model.dart';

@lazySingleton
class GetPreparingOrdersUseCase implements UseCase<GetPreparingOrdersModel, GetPreparingOrdersParams> {

  final HomeRepo home;

  GetPreparingOrdersUseCase({required this.home});

  @override
  DataResponse<GetPreparingOrdersModel> call(GetPreparingOrdersParams params) {
    return home.getPreparingOrders(params);
  }
}

class GetPreparingOrdersParams with Params{
  @override
  QueryParams getParams() => {
    "filter[storeId]": 1,
    "filter[status]": "preparing",
  };
}
