import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';
import '../models/get_products_model.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_categories_model.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../models/get_low_stock_model.dart';
import '../../domain/usecases/get_low_stock_use_case.dart';

@lazySingleton
class ProductsRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  ProductsRemoteDataSource({required this.dioNetwork});

  Future<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/products',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getProductsModelFromJson,
    );
  }

  Future<GetCategoriesModel> getCategories(GetCategoriesParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-categories',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getCategoriesModelFromJson,
    );
  }

  Future<GetLowStockModel> getLowStock(GetLowStockParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/products/low-stock',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getLowStockModelFromJson,
    );
  }
}
