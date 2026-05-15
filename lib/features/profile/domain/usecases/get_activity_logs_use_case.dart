import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/get_activity_logs_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class GetActivityLogsUseCase
    implements UseCase<GetActivityLogsModel, GetActivityLogsParams> {
  final ProfileRepo profile;

  GetActivityLogsUseCase({required this.profile});

  @override
  DataResponse<GetActivityLogsModel> call(GetActivityLogsParams params) {
    return profile.getActivityLogs(params);
  }
}

class GetActivityLogsParams with Params {
  final int page;
  /// When null, request all logs (omit `logName` query).
  final String? logName;

  GetActivityLogsParams({
    this.page = 1,
    this.logName,
  });

  @override
  QueryParams getParams() => {
        'storeId': 1,
        'page': page,
        'perPage': 10,
        if (logName != null && logName!.isNotEmpty) 'logName': logName,
      };
}
