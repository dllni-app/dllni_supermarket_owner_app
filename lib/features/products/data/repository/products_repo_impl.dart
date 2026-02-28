import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/products_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/products_remote_data_source.dart';
import '../../domain/usecases/get_all_products_use_case.dart';
import '../models/get_all_products_model.dart';

@LazySingleton(as: ProductsRepo)
class ProductsRepoImpl with HandlingException implements ProductsRepo {
  final ProductsRemoteDataSource productsRemoteDataSource;

  ProductsRepoImpl({required this.productsRemoteDataSource});

  @override
  DataResponse<GetAllProductsModel> getAllProducts(GetAllProductsParams params) {
    return wrapHandlingException(
      tryCall: () => productsRemoteDataSource.getAllProducts(params),
    );
  }}

