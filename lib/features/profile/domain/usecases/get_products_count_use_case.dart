import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_products_count_model.dart';

@lazySingleton
class GetProductsCountUseCase implements UseCase<GetProductsCountModel, GetProductsCountParams> {

  final ProfileRepo profile;

  GetProductsCountUseCase({required this.profile});

  @override
  DataResponse<GetProductsCountModel> call(GetProductsCountParams params) {
    return profile.getProductsCount(params);
  }
}

class GetProductsCountParams with Params{}
