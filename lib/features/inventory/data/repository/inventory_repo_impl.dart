import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/inventory_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/inventory_remote_data_source.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_products_model.dart';
import '../../domain/usecases/update_product_amount_use_case.dart';
import '../models/update_product_amount_model.dart';
import '../../domain/usecases/get_hourly_count_use_case.dart';
import '../models/get_hourly_count_model.dart';
import '../../domain/usecases/get_inventory_summary_use_case.dart';
import '../models/get_inventory_summary_model.dart';

@LazySingleton(as: InventoryRepo)
class InventoryRepoImpl with HandlingException implements InventoryRepo {
  final InventoryRemoteDataSource inventoryRemoteDataSource;

  InventoryRepoImpl({required this.inventoryRemoteDataSource});

  @override
  DataResponse<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingException(
      tryCall: () => inventoryRemoteDataSource.getProducts(params),
    );
  }

  @override
  DataResponse<UpdateProductAmountModel> updateProductAmount(
    UpdateProductAmountParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => inventoryRemoteDataSource.updateProductAmount(params),
    );
  }

  @override
  DataResponse<GetHourlyCountModel> getHourlyCount(
    GetHourlyCountParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => inventoryRemoteDataSource.getHourlyCount(params),
    );
  }

  @override
  DataResponse<GetInventorySummaryModel> getInventorySummary(
    GetInventorySummaryParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => inventoryRemoteDataSource.getInventorySummary(params),
    );
  }
}
