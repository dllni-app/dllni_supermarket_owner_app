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

class GetPerformanceReportParams with Params {
  GetPerformanceReportParams({this.periodTabIndex = 0});

  /// Period tab: 0 today, 1 week, 2 month, 3 last 3 months, 4 last 6 months, 5 year.
  final int periodTabIndex;

  static String _ymd(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  @override
  QueryParams getParams() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (periodTabIndex) {
      case 0:
        return {'range': 'today'};
      case 1:
        return {'range': 'week'};
      case 2:
        return {'range': 'month'};
      case 3:
        final from = DateTime(now.year, now.month - 3, now.day);
        return {
          'range': 'custom',
          'from': _ymd(from),
          'to': _ymd(today),
        };
      case 4:
        final from = DateTime(now.year, now.month - 6, now.day);
        return {
          'range': 'custom',
          'from': _ymd(from),
          'to': _ymd(today),
        };
      case 5:
        return {'range': 'year'};
      default:
        return {'range': 'today'};
    }
  }
}
