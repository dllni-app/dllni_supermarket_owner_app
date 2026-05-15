import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_product_from_image_model.dart';

@lazySingleton
class GetProductFromImageUseCase
    implements UseCase<GetProductFromImageModel, GetProductFromImageParams> {
  final ProductsRepo products;

  GetProductFromImageUseCase({required this.products});

  @override
  DataResponse<GetProductFromImageModel> call(
    GetProductFromImageParams params,
  ) {
    return products.getProductFromImage(params);
  }
}

class GetProductFromImageParams with Params {
  final String imagePath;

  GetProductFromImageParams({required this.imagePath});
  @override
  BodyMap getBody() => {
    "image": File(imagePath),
    "locale": "ar",
    "module": "supermarket",
  };
}
