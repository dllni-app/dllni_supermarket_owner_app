import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_products_model.dart';

@lazySingleton
class GetProductsUseCase
    implements UseCase<GetProductsModel, GetProductsParams> {
  final ProfileRepo profile;

  GetProductsUseCase({required this.profile});

  @override
  DataResponse<GetProductsModel> call(GetProductsParams params) {
    return profile.getProducts(params);
  }
}

class GetProductsParams with Params {
  final int page;

  GetProductsParams({this.page = 1});

  @override
  QueryParams getParams() => {"page": page};
}
