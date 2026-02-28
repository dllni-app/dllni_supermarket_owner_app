import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../repository/home_repo.dart';
import '../../data/models/dashboard_model.dart';
import 'home_params.dart';

@lazySingleton
class GetDashboardUseCase implements UseCase<DashboardModel, HomeStoreParams> {
  final HomeRepo homeRepo;

  GetDashboardUseCase({required this.homeRepo});

  @override
  DataResponse<DashboardModel> call(HomeStoreParams params) {
    return homeRepo.getDashboard(params);
  }
}
