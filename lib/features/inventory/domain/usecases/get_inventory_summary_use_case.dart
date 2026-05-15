import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_inventory_summary_model.dart';
import '../repository/inventory_repo.dart';

@lazySingleton
class GetInventorySummaryUseCase
    implements UseCase<GetInventorySummaryModel, GetInventorySummaryParams> {
  final InventoryRepo inventory;

  GetInventorySummaryUseCase({required this.inventory});

  @override
  DataResponse<GetInventorySummaryModel> call(
    GetInventorySummaryParams params,
  ) {
    return inventory.getInventorySummary(params);
  }
}

class GetInventorySummaryParams with Params {
  final int storeId;

  GetInventorySummaryParams({required this.storeId});

}
