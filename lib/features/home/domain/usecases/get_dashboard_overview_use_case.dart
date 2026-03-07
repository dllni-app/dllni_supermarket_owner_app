import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/get_dashboard_overview_model.dart';

@lazySingleton
class GetDashboardOverviewUseCase
    implements UseCase<GetDashboardOverviewModel, GetDashboardOverviewParams> {
  final HomeRepo home;

  GetDashboardOverviewUseCase({required this.home});

  @override
  DataResponse<GetDashboardOverviewModel> call(
    GetDashboardOverviewParams params,
  ) {
    return home.getDashboardOverview(params);
  }
}

class GetDashboardOverviewParams with Params {
  @override
  QueryParams getParams() => {"storeId": 1};
}
