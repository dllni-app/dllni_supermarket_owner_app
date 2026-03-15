import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../../data/models/get_store_hours_model.dart';
import '../repository/profile_repo.dart';
import '../../data/models/update_store_hours_model.dart';

@lazySingleton
class UpdateStoreHoursUseCase
    implements UseCase<UpdateStoreHoursModel, UpdateStoreHoursParams> {
  final ProfileRepo profile;

  UpdateStoreHoursUseCase({required this.profile});

  @override
  DataResponse<UpdateStoreHoursModel> call(UpdateStoreHoursParams params) {
    return profile.updateStoreHours(params);
  }
}

class UpdateStoreHoursParams with Params {
  final int storeId;
  final GetStoreHoursModelDataItem period;

  UpdateStoreHoursParams({required this.storeId, required this.period});
  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "dayOfWeek": period.dayOfWeek,
    "opensAt": period.opensAt,
    "closesAt": period.closesAt,
    "isClosed": period.isClosed,
  };
}
