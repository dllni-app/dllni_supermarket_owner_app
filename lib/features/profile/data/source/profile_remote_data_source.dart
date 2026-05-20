import 'package:common_package/common_package.dart';
import 'package:injectable/injectable.dart';

import '../../domain/usecases/add_update_store_employee_use_case.dart';
import '../../domain/usecases/get_coupon_codes_use_case.dart';
import '../../domain/usecases/get_employee_permissions_use_case.dart';
import '../../domain/usecases/get_offers_weekly_summary_use_case.dart';
import '../../domain/usecases/get_store_employees_use_case.dart';
import '../../domain/usecases/update_operating_hours_use_case.dart';
import '../../domain/usecases/get_store_profile_use_case.dart';
import '../../domain/usecases/update_store_data_use_case.dart';
import '../models/add_update_store_employee_model.dart';
import '../models/get_coupon_codes_model.dart';
import '../models/get_employee_permissions_model.dart';
import '../models/get_offers_weekly_summary_model.dart';
import '../models/get_store_employees_model.dart';
import '../models/operating_hours_model.dart';
import '../models/get_store_profile_model.dart';
import '../models/update_store_data_model.dart';
import '../models/get_offer_codes_model.dart';
import '../../domain/usecases/get_offer_codes_use_case.dart';
import '../models/get_products_model.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_products_count_model.dart';
import '../../domain/usecases/get_products_count_use_case.dart';
import '../models/add_coupon_code_model.dart';
import '../../domain/usecases/add_coupon_code_use_case.dart';
import '../models/get_coupon_week_analysis_model.dart';
import '../../domain/usecases/get_coupon_week_analysis_use_case.dart';
import '../models/add_offer_model.dart';
import '../../domain/usecases/add_offer_use_case.dart';
import '../../domain/usecases/get_activity_logs_use_case.dart';
import '../models/get_activity_logs_model.dart';
import '../../domain/usecases/update_store_employee_password_use_case.dart';
import '../models/update_store_employee_password_model.dart';

@lazySingleton
class ProfileRemoteDataSource with HandlingApiManager {
  final DioNetwork dioNetwork;

  ProfileRemoteDataSource({required this.dioNetwork});

  Future<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/store',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getStoreProfileModelFromJson,
    );
  }

  Future<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/store-owner/store',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateStoreDataModelFromJson,
    );
  }

  Future<OperatingHoursModel> getOperatingHours(NoParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/store/operating-hours',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: operatingHoursModelFromJson,
    );
  }

  Future<OperatingHoursModel> updateOperatingHours(
    UpdateOperatingHoursParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.putData(
        endPoint: '/api/v1/store-owner/store/operating-hours',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: operatingHoursModelFromJson,
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

  Future<UpdateStoreEmployeePasswordModel> updateStoreEmployeePassword(
    UpdateStoreEmployeePasswordParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.patchData(
        endPoint: '/api/v1/store-owner/employees/${params.staffId}/password',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: updateStoreEmployeePasswordModelFromJson,
    );
  }

  Future<GetOfferCodesModel> getOfferCodes(GetOfferCodesParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-offers',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getOfferCodesModelFromJson,
    );
  }

  Future<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-products',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getProductsModelFromJson,
    );
  }

  Future<GetProductsCountModel> getProductsCount(
    GetProductsCountParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-products/available-count',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getProductsCountModelFromJson,
    );
  }

  Future<AddCouponCodeModel> addCouponCode(AddCouponCodeParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-coupons',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: addCouponCodeModelFromJson,
    );
  }

  Future<GetCouponWeekAnalysisModel> getCouponWeekAnalysis(
    GetCouponWeekAnalysisParams params,
  ) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/sm-coupons/weekly-analysis',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getCouponWeekAnalysisModelFromJson,
    );
  }

  Future<AddOfferModel> addOffer(AddOfferParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.postData(
        endPoint: '/api/v1/sm-offers',
        data: params.getBody(),
        params: params.getParams(),
      ),
      jsonConvert: addOfferModelFromJson,
    );
  }

  Future<GetActivityLogsModel> getActivityLogs(GetActivityLogsParams params) {
    return wrapHandlingApi(
      tryCall: () => dioNetwork.getData(
        endPoint: '/api/v1/store-owner/activity-logs',
        params: params.getParams(),
        data: params.getBody().isEmpty ? null : params.getBody(),
      ),
      jsonConvert: getActivityLogsModelFromJson,
    );
  }
}
