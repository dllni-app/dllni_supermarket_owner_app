import 'package:common_package/helpers/dio_network.dart';
import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/api_handler.dart';
import '../models/get_all_products_model.dart';
import '../../domain/usecases/get_all_products_use_case.dart';

@lazySingleton
class ProductsRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  ProductsRemoteDataSource({required this.dioNetwork});

  Future<GetAllProductsModel> getAllProducts(GetAllProductsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(endPoint: '/store-owner/products', params: params.getParams(), data: params.getBody().isEmpty ? null : params.getBody()),
      jsonConvert: getAllProductsModelFromJson,
    );
  }}