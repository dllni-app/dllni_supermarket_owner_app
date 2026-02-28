import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_all_products_model.dart';

@lazySingleton
class GetAllProductsUseCase implements UseCase<GetAllProductsModel, GetAllProductsParams> {

  final ProductsRepo products;

  GetAllProductsUseCase({required this.products});

  @override
  DataResponse<GetAllProductsModel> call(GetAllProductsParams params) {
    return products.getAllProducts(params);
  }
}

class GetAllProductsParams with Params{}
