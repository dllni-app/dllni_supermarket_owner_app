import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repository/home_repo.dart';
import '../../data/models/low_stock_model.dart';
import 'home_params.dart';

@lazySingleton
class GetLowStockUseCase implements UseCase<LowStockModel, HomeStoreParams> {
  final HomeRepo homeRepo;

  GetLowStockUseCase({required this.homeRepo});

  @override
  DataResponse<LowStockModel> call(HomeStoreParams params) {
    return homeRepo.getLowStock(params);
  }
}
