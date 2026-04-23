import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/operating_hours_model.dart';

@lazySingleton
class UpdateOperatingHoursUseCase
    implements UseCase<OperatingHoursModel, UpdateOperatingHoursParams> {
  final ProfileRepo profile;

  UpdateOperatingHoursUseCase({required this.profile});

  @override
  DataResponse<OperatingHoursModel> call(UpdateOperatingHoursParams params) {
    return profile.updateOperatingHours(params);
  }
}

class UpdateOperatingHoursParams with Params {
  final bool isTemporarilyClosed;
  final List<OperatingHoursDaily> dailyHours;

  UpdateOperatingHoursParams({
    required this.isTemporarilyClosed,
    required this.dailyHours,
  });

  @override
  BodyMap getBody() => {
    'isTemporarilyClosed': isTemporarilyClosed,
    'dailyHours': dailyHours.map((e) => e.toJson()).toList(),
  };
}
