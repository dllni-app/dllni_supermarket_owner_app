import 'package:common_package/helpers/error_handler.dart';
import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repository/products_repo.dart';
import '../../domain/usecases/get_low_stock_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/total_producst_count_use_case.dart';
import '../models/get_low_stock_model.dart';
import '../models/get_products_model.dart';
import '../models/total_producst_count_model.dart';
import '../source/products_remote_data_source.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../models/get_categories_model.dart';
import '../../domain/usecases/get_product_from_image_use_case.dart';
import '../models/get_product_from_image_model.dart';
import '../../domain/usecases/get_product_from_text_use_case.dart';
import '../models/get_product_from_text_model.dart';
import '../../domain/usecases/add_product_use_case.dart';
import '../models/add_product_model.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../models/update_product_model.dart';
import '../../domain/usecases/import_products_file_use_case.dart';
import '../models/import_products_file_model.dart';
import '../models/search_master_products_model.dart';
import '../../domain/usecases/search_master_products_use_case.dart';
import '../../domain/usecases/import_products_from_master_use_case.dart';
import '../models/import_products_from_master_model.dart';
import '../../domain/usecases/delete_product_use_case.dart';
import '../models/delete_product_model.dart';

@LazySingleton(as: ProductsRepo)
class ProductsRepoImpl with HandlingException implements ProductsRepo {
  final ProductsRemoteDataSource productsRemoteDataSource;

  ProductsRepoImpl({required this.productsRemoteDataSource});

  @override
  DataResponse<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getProducts(params),
    );
  }

  @override
  DataResponse<GetLowStockModel> getLowStock(GetLowStockParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getLowStock(params),
    );
  }

  @override
  DataResponse<TotalProducstCountModel> totalProducstCount(
    TotalProductsCountParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.totalProducstCount(params),
    );
  }



  @override
  DataResponse<GetCategoriesModel> getCategories(GetCategoriesParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getCategories(params),
    );
  }

  @override
  DataResponse<GetProductFromImageModel> getProductFromImage(GetProductFromImageParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getProductFromImage(params),
    );
  }

  @override
  DataResponse<GetProductFromTextModel> getProductFromText(GetProductFromTextParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getProductFromText(params),
    );
  }

  @override
  DataResponse<AddProductModel> addProduct(AddProductParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.addProduct(params),
    );
  }

  @override
  DataResponse<UpdateProductModel> updateProduct(UpdateProductParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.updateProduct(params),
    );
  }

  @override
  DataResponse<DeleteProductModel> deleteProduct(DeleteProductParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.deleteProduct(params),
    );
  }

  @override
  DataResponse<ImportProductsFileModel> importProductsFile(ImportProductsFileParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.importProductsFile(params),
    );
  }

  @override
  DataResponse<SearchMasterProductsModel> searchMasterProducts(
    SearchMasterProductsParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.searchMasterProducts(params),
    );
  }

  @override
  DataResponse<ImportProductsFromMasterModel> importProductsFromMaster(
    ImportProductsFromMasterParams params,
  ) {
    return wrapHandlingException(
      tryCall: () =>
          productsRemoteDataSource.importProductsFromMaster(params),
    );
  }
}
