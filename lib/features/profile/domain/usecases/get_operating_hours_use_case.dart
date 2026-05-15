import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';

import '../repository/profile_repo.dart';
import '../../data/models/operating_hours_model.dart';

@lazySingleton
class GetOperatingHoursUseCase
    implements UseCase<OperatingHoursModel, NoParams> {
  final ProfileRepo profile;

  GetOperatingHoursUseCase({required this.profile});

  @override
  DataResponse<OperatingHoursModel> call(NoParams params) {
    return profile.getOperatingHours(params);
  }
}
