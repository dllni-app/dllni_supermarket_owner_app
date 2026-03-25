import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_products_model.dart';
import '../repository/products_repo.dart';

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
  final String? search;

  GetProductsParams({this.search, this.categoryId, this.page = 1});

  @override
  QueryParams getParams() {
    return {
      "page": page,
      if (categoryId != null) "filter[categoryId]": categoryId,
      if (search != null && search != "") "filter[search]": search,
    };
  }
}
