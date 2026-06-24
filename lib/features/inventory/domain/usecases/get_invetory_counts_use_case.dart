import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/inventory_repo.dart';
import '../../data/models/get_invetory_counts_model.dart';

@lazySingleton
class GetInvetoryCountsUseCase implements UseCase<GetInvetoryCountsModel, GetInvetoryCountsParams> {

  final InventoryRepo inventory;

  GetInvetoryCountsUseCase({required this.inventory});

  @override
  DataResponse<GetInvetoryCountsModel> call(GetInvetoryCountsParams params) {
    return inventory.getInvetoryCounts(params);
  }
}

class GetInvetoryCountsParams with Params{}
