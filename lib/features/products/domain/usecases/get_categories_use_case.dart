import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/products_repo.dart';
import '../../data/models/get_categories_model.dart';

@lazySingleton
class GetCategoriesUseCase implements UseCase<GetCategoriesModel, GetCategoriesParams> {

  final ProductsRepo products;

  GetCategoriesUseCase({required this.products});

  @override
  DataResponse<GetCategoriesModel> call(GetCategoriesParams params) {
    return products.getCategories(params);
  }
}

class GetCategoriesParams with Params{}
