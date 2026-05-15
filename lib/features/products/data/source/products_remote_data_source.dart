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
import '../models/update_product_model.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../models/import_products_file_model.dart';
import '../../domain/usecases/import_products_file_use_case.dart';
import '../models/search_master_products_model.dart';
import '../../domain/usecases/search_master_products_use_case.dart';
import '../models/import_products_from_master_model.dart';
import '../../domain/usecases/import_products_from_master_use_case.dart';
import '../models/delete_product_model.dart';
import '../../domain/usecases/delete_product_use_case.dart';

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
        endPoint: '/api/v1/products/ai/extract-from-image',
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
        endPoint: '/api/v1/products/ai/generate-image',
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

  Future<UpdateProductModel> updateProduct(UpdateProductParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/store-owner/products/${params.productId}',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateProductModelFromJson,
    );
  }

  Future<DeleteProductModel> deleteProduct(DeleteProductParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.deleteData(
        endPoint: '/api/v1/store-owner/products/${params.productId}',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: (data) => DeleteProductModel.fromJson(data),
    );
  }

  Future<ImportProductsFileModel> importProductsFile(ImportProductsFileParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(endPoint: '/api/v1/sm-products/import', data: params.getBody(), params: params.getParams()),
      jsonConvert: importProductsFileModelFromJson,
    );
  }

  Future<SearchMasterProductsModel> searchMasterProducts(
    SearchMasterProductsParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/master-products/search',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: searchMasterProductsModelFromJson,
    );
  }

  Future<ImportProductsFromMasterModel> importProductsFromMaster(
    ImportProductsFromMasterParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/store-owner/products/from-master',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: (_) => ImportProductsFromMasterModel(),
    );
  }
}
