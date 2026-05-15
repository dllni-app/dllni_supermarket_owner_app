import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_product_from_text_model.dart';

@lazySingleton
class GetProductFromTextUseCase
    implements UseCase<GetProductFromTextModel, GetProductFromTextParams> {
  final ProductsRepo products;

  GetProductFromTextUseCase({required this.products});

  @override
  DataResponse<GetProductFromTextModel> call(GetProductFromTextParams params) {
    return products.getProductFromText(params);
  }
}

class GetProductFromTextParams with Params {
  final String title;
  final String? description;

  GetProductFromTextParams({required this.title, required this.description});

  @override
  BodyMap getBody() => {
    "title": title, // "Classic Burger",
    "description": description, // "Tasty burger description.",
    "module": "supermarket"
  };
}
