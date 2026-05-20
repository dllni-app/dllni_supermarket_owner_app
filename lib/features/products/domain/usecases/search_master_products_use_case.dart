import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/search_master_products_model.dart';
import '../repository/products_repo.dart';

@lazySingleton
class SearchMasterProductsUseCase
    implements UseCase<SearchMasterProductsModel, SearchMasterProductsParams> {
  final ProductsRepo products;

  SearchMasterProductsUseCase({required this.products});

  @override
  DataResponse<SearchMasterProductsModel> call(
    SearchMasterProductsParams params,
  ) {
    return products.searchMasterProducts(params);
  }
}

class SearchMasterProductsParams with Params {
  final int page;
  final String? index;

  SearchMasterProductsParams({this.page = 1, this.index});

  @override
  QueryParams getParams() {
    final trimmed = index?.trim();
    return {
      'page': page,
      'perPage': 10,
      'index': trimmed ?? '',
    };
  }
}
