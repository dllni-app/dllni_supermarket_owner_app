import 'dart:io';

import 'package:common_package/helpers/typedef.dart';
import 'package:injectable/injectable.dart';

import '../../data/models/add_update_store_employee_model.dart';
import '../../data/models/get_store_employees_model.dart';
import '../repository/profile_repo.dart';

@lazySingleton
class AddUpdateStoreEmployeeUseCase implements UseCase<AddUpdateStoreEmployeeModel, AddUpdateStoreEmployeeParams> {
  final ProfileRepo profile;

  AddUpdateStoreEmployeeUseCase({required this.profile});

  @override
  DataResponse<AddUpdateStoreEmployeeModel> call(AddUpdateStoreEmployeeParams params) {
    return profile.addUpdateStoreEmployee(params);
  }
}

enum RequestMethod { post, put }

class AddUpdateStoreEmployeeParams with Params {
  final RequestMethod method;
  final int storeId;
  final int? userId;
  final String? imagePath;
  final GetStoreEmployeesModelDataEmployeesItem employee;

  AddUpdateStoreEmployeeParams({required this.method, required this.storeId, this.userId, this.imagePath, required this.employee});

  @override
  BodyMap getBody() => {
    "storeId": storeId,
    "name": employee.user!.name,
    "email": employee.user!.email,
    "phone": employee.user!.phone,
    "permissionIds[]": employee.permissionIds,
    "isActive": employee.isActive == false ? 0 : 1,
    if (imagePath != null) "profileImage": File(imagePath!),
  };
}
