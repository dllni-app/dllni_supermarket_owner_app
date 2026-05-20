import 'dart:io';

import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/add_product_model.dart';
import '../../view/screens/add_product_details_screen.dart';
import '../repository/products_repo.dart';

@lazySingleton
class AddProductUseCase implements UseCase<AddProductModel, AddProductParams> {
  final ProductsRepo products;

  AddProductUseCase({required this.products});

  @override
  DataResponse<AddProductModel> call(AddProductParams params) {
    return products.addProduct(params);
  }
}

class AddProductParams with Params {
  final AddProductDetailsParams params;

  AddProductParams({required this.params});

  @override
  BodyMap getBody() => {
    "storeId": 1,
    "categoryId": params.categoryId,
    "name": params.title,
    if (params.description != null) "description": params.description,
    "sourceType": "manual",
    "price": params.price,
    "discountedPrice": params.discountedPrice,
    "stockQuantity": params.quantity,
    "lowStockThreshold": params.lowStockQuantity,
    if (params.expiredAt != null) "expiresAt": params.expiredAt,
    "isAvailable": 1,
    "image": File(params.mainImagePath!),
  };
}
