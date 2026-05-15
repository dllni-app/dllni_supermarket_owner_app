import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_store_profile_model.dart';

@lazySingleton
class GetStoreProfileUseCase
    implements UseCase<GetStoreProfileModel, GetStoreProfileParams> {
  final ProfileRepo profile;

  GetStoreProfileUseCase({required this.profile});

  @override
  DataResponse<GetStoreProfileModel> call(GetStoreProfileParams params) {
    return profile.getStoreProfile(params);
  }
}

class GetStoreProfileParams with Params {
  final int storeId;

  GetStoreProfileParams({required this.storeId});
}
