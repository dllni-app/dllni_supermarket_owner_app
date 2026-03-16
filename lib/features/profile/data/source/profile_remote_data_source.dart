import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_store_hours_use_case.dart';
import '../../domain/usecases/add_update_store_employee_use_case.dart';
import '../../domain/usecases/delete_store_hours_use_case.dart';
import '../../domain/usecases/get_coupon_codes_use_case.dart';
import '../../domain/usecases/get_employee_permissions_use_case.dart';
import '../../domain/usecases/get_offers_weekly_summary_use_case.dart';
import '../../domain/usecases/get_store_employees_use_case.dart';
import '../../domain/usecases/get_store_hours_use_case.dart';
import '../../domain/usecases/get_store_profile_use_case.dart';
import '../../domain/usecases/update_store_data_use_case.dart';
import '../../domain/usecases/update_store_hours_use_case.dart';
import '../models/add_store_hours_model.dart';
import '../models/add_update_store_employee_model.dart';
import '../models/delete_store_hours_model.dart';
import '../models/get_coupon_codes_model.dart';
import '../models/get_employee_permissions_model.dart';
import '../models/get_offers_weekly_summary_model.dart';
import '../models/get_store_employees_model.dart';
import '../models/get_store_hours_model.dart';
import '../models/get_store_profile_model.dart';
import '../models/update_store_data_model.dart';
import '../models/update_store_hours_model.dart';

@lazySingleton
class ProfileRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  ProfileRemoteDataSource({required this.dioNetwork});

  Future<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/stores/${params.storeId}',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getStoreProfileModelFromJson,
    );
  }

  Future<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/store-owner/stores/1',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateStoreDataModelFromJson,
    );
  }

  Future<GetStoreHoursModel> getStoreHours(GetStoreHoursParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-store-hours',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getStoreHoursModelFromJson,
    );
  }

  Future<AddStoreHoursModel> addStoreHours(AddStoreHoursParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-store-hours',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: addStoreHoursModelFromJson,
    );
  }

  Future<UpdateStoreHoursModel> updateStoreHours(
    UpdateStoreHoursParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/sm-store-hours/${params.period.id}',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateStoreHoursModelFromJson,
    );
  }

  Future<DeleteStoreHoursModel> deleteStoreHours(
    DeleteStoreHoursParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.deleteData(
        endPoint: '/api/v1/sm-store-hours/${params.periodId}',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: (message) => DeleteStoreHoursModel(message: message),
    );
  }

  Future<GetCouponCodesModel> getCouponCodes(GetCouponCodesParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-coupons',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getCouponCodesModelFromJson,
    );
  }

  Future<GetEmployeePermissionsModel> getEmployeePermissions(
    GetEmployeePermissionsParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/permissions',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getEmployeePermissionsModelFromJson,
    );
  }

  Future<GetOffersWeeklySummaryModel> getOffersWeeklySummary(
    GetOffersWeeklySummaryParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/offers/weekly-summary',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getOffersWeeklySummaryModelFromJson,
    );
  }

  Future<GetStoreEmployeesModel> getStoreEmployees(
    GetStoreEmployeesParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/employees',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getStoreEmployeesModelFromJson,
    );
  }

  Future<AddUpdateStoreEmployeeModel> addUpdateStoreEmployee(
    AddUpdateStoreEmployeeParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => params.method == RequestMethod.post
          ? dioNetwork.postData(
              endPoint: '/api/v1/store-owner/employees',
              data: params.getBody(),
              params: params.getParams(),
            )
          : dioNetwork.patchData(
              endPoint: '/api/v1/store-owner/employees/${params.employee.id}',
              data: params.getBody(),
              params: params.getParams(),
            ),
      jsonConvert: addUpdateStoreEmployeeModelFromJson,
    );
  }
}
