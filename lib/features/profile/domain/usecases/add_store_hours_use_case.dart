import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/add_store_hours_model.dart';
import '../../data/models/get_store_hours_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class AddStoreHoursUseCase
    implements UseCase<AddStoreHoursModel, AddStoreHoursParams> {
  final ProfileRepo profile;

  AddStoreHoursUseCase({required this.profile});

  @override
  DataResponse<AddStoreHoursModel> call(AddStoreHoursParams params) {
    return profile.addStoreHours(params);
  }
}

class AddStoreHoursParams with Params {
  final int storeId;

  final GetStoreHoursModelDataItem period;

  AddStoreHoursParams({required this.storeId, required this.period});
  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "dayOfWeek": period.dayOfWeek,
    "opensAt": period.opensAt,
    "closesAt": period.closesAt,
    "isClosed": period.isClosed ?? false,
  };
}
