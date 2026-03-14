import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_products_model.dart';
import '../models/update_product_amount_model.dart';
import '../../domain/usecases/update_product_amount_use_case.dart';
import '../models/get_hourly_count_model.dart';
import '../../domain/usecases/get_hourly_count_use_case.dart';

@lazySingleton
class InventoryRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  InventoryRemoteDataSource({required this.dioNetwork});

  Future<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-products',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getProductsModelFromJson,
    );
  }

  Future<UpdateProductAmountModel> updateProductAmount(
    UpdateProductAmountParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/store-owner/products/${params.productId}/stock',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateProductAmountModelFromJson,
    );
  }

  Future<GetHourlyCountModel> getHourlyCount(GetHourlyCountParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-orders/hourly-count',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getHourlyCountModelFromJson,
    );
  }
}
