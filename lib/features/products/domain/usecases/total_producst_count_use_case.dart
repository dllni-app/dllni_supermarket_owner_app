import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/total_producst_count_model.dart';
import '../repository/products_repo.dart';

@lazySingleton
class TotalProducstCountUseCase
    implements UseCase<TotalProducstCountModel, TotalProductsCountParams> {
  final ProductsRepo products;

  TotalProducstCountUseCase({required this.products});

  @override
  DataResponse<TotalProducstCountModel> call(TotalProductsCountParams params) {
    return products.totalProducstCount(params);
  }
}

class TotalProductsCountParams with Params {}
