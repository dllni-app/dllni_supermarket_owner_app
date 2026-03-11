import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/total_producst_count_model.dart';

@lazySingleton
class TotalProducstCountUseCase implements UseCase<TotalProducstCountModel, TotalProducstCountParams> {

  final ProductsRepo products;

  TotalProducstCountUseCase({required this.products});

  @override
  DataResponse<TotalProducstCountModel> call(TotalProducstCountParams params) {
    return products.totalProducstCount(params);
  }
}

class TotalProducstCountParams with Params{}
