import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_products_model.dart';

@lazySingleton
class GetProductsUseCase
    implements UseCase<GetProductsModel, GetProductsParams> {
  final ProductsRepo products;

  GetProductsUseCase({required this.products});

  @override
  DataResponse<GetProductsModel> call(GetProductsParams params) {
    return products.getProducts(params);
  }
}

class GetProductsParams with Params {
  final int page;
  final int? categoryId;

  GetProductsParams({this.categoryId, required this.page});

  @override
  QueryParams getParams() {
    return {
      "page": page,
      if (categoryId != null) "filter[categoryId]": categoryId,
    };
  }
}
