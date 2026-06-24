import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_products_use_case.dart';
import '../../data/models/get_products_model.dart';
import '../usecases/update_product_amount_use_case.dart';
import '../../data/models/update_product_amount_model.dart';
import '../usecases/get_hourly_count_use_case.dart';
import '../../data/models/get_hourly_count_model.dart';
import '../usecases/get_inventory_summary_use_case.dart';
import '../../data/models/get_inventory_summary_model.dart';
import '../usecases/get_invetory_counts_use_case.dart';
import '../../data/models/get_invetory_counts_model.dart';

abstract class InventoryRepo {
  DataResponse<GetProductsModel> getProducts(GetProductsParams params);

  DataResponse<UpdateProductAmountModel> updateProductAmount(
    UpdateProductAmountParams params,
  );

  DataResponse<GetHourlyCountModel> getHourlyCount(GetHourlyCountParams params);

  DataResponse<GetInventorySummaryModel> getInventorySummary(
    GetInventorySummaryParams params,
  );

  DataResponse<GetInvetoryCountsModel> getInvetoryCounts(GetInvetoryCountsParams params);
}
