import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/get_low_stock_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/total_producst_count_use_case.dart';
import '../models/get_low_stock_model.dart';
import '../models/get_products_model.dart';
import '../models/total_producst_count_model.dart';
import '../models/get_categories_model.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../models/get_product_from_image_model.dart';
import '../../domain/usecases/get_product_from_image_use_case.dart';
import '../models/get_product_from_text_model.dart';
import '../../domain/usecases/get_product_from_text_use_case.dart';
import '../models/add_product_model.dart';
import '../../domain/usecases/add_product_use_case.dart';

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

  Future<TotalProducstCountModel> totalProducstCount(
    TotalProductsCountParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-products/available-count',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: totalProducstCountModelFromJson,
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

  Future<GetProductFromImageModel> getProductFromImage(
    GetProductFromImageParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-products/ai/extract-from-image',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: getProductFromImageModelFromJson,
    );
  }

  Future<GetProductFromTextModel> getProductFromText(
    GetProductFromTextParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-products/ai/generate-image',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: getProductFromTextModelFromJson,
    );
  }

  Future<AddProductModel> addProduct(AddProductParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-products',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: addProductModelFromJson,
    );
  }
}
