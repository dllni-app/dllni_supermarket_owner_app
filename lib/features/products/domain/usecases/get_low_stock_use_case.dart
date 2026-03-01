import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_low_stock_model.dart';

@lazySingleton
class GetLowStockUseCase
    implements UseCase<GetLowStockModel, GetLowStockParams> {
  final ProductsRepo products;

  GetLowStockUseCase({required this.products});

  @override
  DataResponse<GetLowStockModel> call(GetLowStockParams params) {
    return products.getLowStock(params);
  }
}

class GetLowStockParams with Params {
  final int storeId;

  GetLowStockParams({required this.storeId});
  @override
  QueryParams getParams() {
    return {"store_id": 1};
  }
}
