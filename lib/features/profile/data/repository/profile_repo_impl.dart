import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';

import '../../domain/repository/profile_repo.dart';
import 'package:common_package/helpers/typedef.dart';
import '../source/profile_remote_data_source.dart';
import '../../domain/usecases/get_store_profile_use_case.dart';
import '../models/get_store_profile_model.dart';
import '../../domain/usecases/update_store_data_use_case.dart';
import '../models/update_store_data_model.dart';
import '../../domain/usecases/get_store_hours_use_case.dart';
import '../models/get_store_hours_model.dart';
import '../../domain/usecases/add_store_hours_use_case.dart';
import '../models/add_store_hours_model.dart';
import '../../domain/usecases/update_store_hours_use_case.dart';
import '../models/update_store_hours_model.dart';
import '../../domain/usecases/delete_store_hours_use_case.dart';
import '../models/delete_store_hours_model.dart';
import '../../domain/usecases/get_coupon_codes_use_case.dart';
import '../models/get_coupon_codes_model.dart';
import '../../domain/usecases/get_employee_permissions_use_case.dart';
import '../models/get_employee_permissions_model.dart';
import '../../domain/usecases/get_offers_weekly_summary_use_case.dart';
import '../models/get_offers_weekly_summary_model.dart';
import '../../domain/usecases/get_store_employees_use_case.dart';
import '../models/get_store_employees_model.dart';
import '../../domain/usecases/add_update_store_employee_use_case.dart';
import '../models/add_update_store_employee_model.dart';

@LazySingleton(as: ProfileRepo)
class ProfileRepoImpl with HandlingException implements ProfileRepo {
  final ProfileRemoteDataSource profileRemoteDataSource;

  ProfileRepoImpl({required this.profileRemoteDataSource});

  @override
  DataResponse<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getStoreProfile(params),
    );
  }


  @override
  DataResponse<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.updateStoreData(params),
    );
  }

  @override
  DataResponse<GetStoreHoursModel> getStoreHours(GetStoreHoursParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getStoreHours(params),
    );
  }

  @override
  DataResponse<AddStoreHoursModel> addStoreHours(AddStoreHoursParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.addStoreHours(params),
    );
  }

  @override
  DataResponse<UpdateStoreHoursModel> updateStoreHours(UpdateStoreHoursParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.updateStoreHours(params),
    );
  }

  @override
  DataResponse<DeleteStoreHoursModel> deleteStoreHours(DeleteStoreHoursParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.deleteStoreHours(params),
    );
  }

  @override
  DataResponse<GetCouponCodesModel> getCouponCodes(GetCouponCodesParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getCouponCodes(params),
    );
  }

  @override
  DataResponse<GetEmployeePermissionsModel> getEmployeePermissions(GetEmployeePermissionsParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getEmployeePermissions(params),
    );
  }

  @override
  DataResponse<GetOffersWeeklySummaryModel> getOffersWeeklySummary(GetOffersWeeklySummaryParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getOffersWeeklySummary(params),
    );
  }

  @override
  DataResponse<GetStoreEmployeesModel> getStoreEmployees(GetStoreEmployeesParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getStoreEmployees(params),
    );
  }

  @override
  DataResponse<AddUpdateStoreEmployeeModel> addUpdateStoreEmployee(AddUpdateStoreEmployeeParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.addUpdateStoreEmployee(params),
    );
  }}

