import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/update_store_employee_password_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class UpdateStoreEmployeePasswordUseCase
    implements
        UseCase<
          UpdateStoreEmployeePasswordModel,
          UpdateStoreEmployeePasswordParams
        > {
  final ProfileRepo profile;

  UpdateStoreEmployeePasswordUseCase({required this.profile});

  @override
  DataResponse<UpdateStoreEmployeePasswordModel> call(
    UpdateStoreEmployeePasswordParams params,
  ) {
    return profile.updateStoreEmployeePassword(params);
  }
}

class UpdateStoreEmployeePasswordParams with Params {
  final int staffId;
  final String newPassword;
  final String newPasswordConfirmation;

  UpdateStoreEmployeePasswordParams({
    required this.staffId,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  BodyMap getBody() => {
    "newPassword": newPassword,
    "newPasswordConfirmation": newPasswordConfirmation,
  };
}
