import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/delete_product_model.dart';

@lazySingleton
class DeleteProductUseCase
    implements UseCase<DeleteProductModel, DeleteProductParams> {
  final ProductsRepo products;

  DeleteProductUseCase({required this.products});

  @override
  DataResponse<DeleteProductModel> call(DeleteProductParams params) {
    return products.deleteProduct(params);
  }
}

class DeleteProductParams with Params {
  final int productId;

  DeleteProductParams({required this.productId});
}
