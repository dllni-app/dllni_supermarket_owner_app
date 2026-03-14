import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/home_repo.dart';
import '../../data/models/get_performance_report_model.dart';

@lazySingleton
class GetPerformanceReportUseCase implements UseCase<GetPerformanceReportModel, GetPerformanceReportParams> {

  final HomeRepo home;

  GetPerformanceReportUseCase({required this.home});

  @override
  DataResponse<GetPerformanceReportModel> call(GetPerformanceReportParams params) {
    return home.getPerformanceReport(params);
  }
}

class GetPerformanceReportParams with Params{}
