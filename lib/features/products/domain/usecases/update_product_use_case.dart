import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/update_product_model.dart';

@lazySingleton
class UpdateProductUseCase
    implements UseCase<UpdateProductModel, UpdateProductParams> {
  final ProductsRepo products;

  UpdateProductUseCase({required this.products});

  @override
  DataResponse<UpdateProductModel> call(UpdateProductParams params) {
    return products.updateProduct(params);
  }
}

class UpdateProductParams with Params {
  final bool isActive;
  final int productId;

  UpdateProductParams({required this.isActive, required this.productId});
  @override
  BodyMap getBody() => {"isActive": isActive};
}
