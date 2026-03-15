import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/delete_store_hours_model.dart';

@lazySingleton
class DeleteStoreHoursUseCase implements UseCase<DeleteStoreHoursModel, DeleteStoreHoursParams> {

  final ProfileRepo profile;

  DeleteStoreHoursUseCase({required this.profile});

  @override
  DataResponse<DeleteStoreHoursModel> call(DeleteStoreHoursParams params) {
    return profile.deleteStoreHours(params);
  }
}

class DeleteStoreHoursParams with Params{
  final int periodId;

  DeleteStoreHoursParams({required this.periodId});
}
