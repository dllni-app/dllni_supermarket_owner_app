import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/typedef.dart';

import '../repository/profile_repo.dart';
import '../../data/models/get_employee_permissions_model.dart';

@lazySingleton
class GetEmployeePermissionsUseCase implements UseCase<GetEmployeePermissionsModel, GetEmployeePermissionsParams> {

  final ProfileRepo profile;

  GetEmployeePermissionsUseCase({required this.profile});

  @override
  DataResponse<GetEmployeePermissionsModel> call(GetEmployeePermissionsParams params) {
    return profile.getEmployeePermissions(params);
  }
}

class GetEmployeePermissionsParams with Params{}
