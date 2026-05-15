import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/inventory_repo.dart';
import '../../data/models/get_hourly_count_model.dart';

@lazySingleton
class GetHourlyCountUseCase implements UseCase<GetHourlyCountModel, GetHourlyCountParams> {

  final InventoryRepo inventory;

  GetHourlyCountUseCase({required this.inventory});

  @override
  DataResponse<GetHourlyCountModel> call(GetHourlyCountParams params) {
    return inventory.getHourlyCount(params);
  }
}

class GetHourlyCountParams with Params{}
