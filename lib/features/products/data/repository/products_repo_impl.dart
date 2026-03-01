import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/products_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/products_remote_data_source.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_products_model.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../models/get_categories_model.dart';
import '../../domain/usecases/get_low_stock_use_case.dart';
import '../models/get_low_stock_model.dart';

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
  DataResponse<GetCategoriesModel> getCategories(GetCategoriesParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getCategories(params),
    );
  }

  @override
  DataResponse<GetLowStockModel> getLowStock(GetLowStockParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getLowStock(params),
    );
  }}

