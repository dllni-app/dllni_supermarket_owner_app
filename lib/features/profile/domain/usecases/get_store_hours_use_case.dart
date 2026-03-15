import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_store_hours_model.dart';

@lazySingleton
class GetStoreHoursUseCase
    implements UseCase<GetStoreHoursModel, GetStoreHoursParams> {
  final ProfileRepo profile;

  GetStoreHoursUseCase({required this.profile});

  @override
  DataResponse<GetStoreHoursModel> call(GetStoreHoursParams params) {
    return profile.getStoreHours(params);
  }
}

class GetStoreHoursParams with Params {
  final int storeId;

  GetStoreHoursParams({required this.storeId});

  @override
  QueryParams getParams() => {"filter[storeId]": storeId};
}
