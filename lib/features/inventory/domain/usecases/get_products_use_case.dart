import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/inventory_repo.dart';
import '../../data/models/get_products_model.dart';

@lazySingleton
class GetProductsUseCase
    implements UseCase<GetProductsModel, GetProductsParams> {
  final InventoryRepo inventory;

  GetProductsUseCase({required this.inventory});

  @override
  DataResponse<GetProductsModel> call(GetProductsParams params) {
    return inventory.getProducts(params);
  }
}

class GetProductsParams with Params {
  final int page;
  final String? search;

  GetProductsParams({this.page = 1, this.search});

  @override
  QueryParams getParams() => {
    'page': page,
    if (search != null && search!.trim().isNotEmpty)
      'filter[search]': search!.trim(),
  };
}
