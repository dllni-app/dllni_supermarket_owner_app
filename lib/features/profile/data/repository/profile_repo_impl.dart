import 'package:injectable/injectable.dart';
import 'package:common_package/helpers/error_handler.dart';
import 'package:common_package/helpers/typedef.dart';

import '../../domain/repository/profile_repo.dart';
import '../source/profile_remote_data_source.dart';
import '../../domain/usecases/get_store_profile_use_case.dart';
import '../models/get_store_profile_model.dart';
import '../../domain/usecases/update_store_data_use_case.dart';
import '../models/update_store_data_model.dart';
import '../../domain/usecases/get_operating_hours_use_case.dart';
import '../models/operating_hours_model.dart';
import '../../domain/usecases/update_operating_hours_use_case.dart';
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
import '../../domain/usecases/get_offer_codes_use_case.dart';
import '../models/get_offer_codes_model.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../models/get_products_model.dart';
import '../../domain/usecases/get_products_count_use_case.dart';
import '../models/get_products_count_model.dart';
import '../../domain/usecases/add_coupon_code_use_case.dart';
import '../models/add_coupon_code_model.dart';
import '../../domain/usecases/get_coupon_week_analysis_use_case.dart';
import '../models/get_coupon_week_analysis_model.dart';
import '../../domain/usecases/add_offer_use_case.dart';
import '../models/add_offer_model.dart';
import '../../domain/usecases/get_activity_logs_use_case.dart';
import '../models/get_activity_logs_model.dart';

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
  DataResponse<OperatingHoursModel> getOperatingHours(NoParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getOperatingHours(params),
    );
  }

  @override
  DataResponse<OperatingHoursModel> updateOperatingHours(
    UpdateOperatingHoursParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.updateOperatingHours(params),
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
  }

  @override
  DataResponse<GetOfferCodesModel> getOfferCodes(GetOfferCodesParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getOfferCodes(params),
    );
  }

  @override
  DataResponse<GetProductsModel> getProducts(GetProductsParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getProducts(params),
    );
  }

  @override
  DataResponse<GetProductsCountModel> getProductsCount(GetProductsCountParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getProductsCount(params),
    );
  }

  @override
  DataResponse<AddCouponCodeModel> addCouponCode(AddCouponCodeParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.addCouponCode(params),
    );
  }

  @override
  DataResponse<GetCouponWeekAnalysisModel> getCouponWeekAnalysis(GetCouponWeekAnalysisParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getCouponWeekAnalysis(params),
    );
  }

  @override
  DataResponse<AddOfferModel> addOffer(AddOfferParams params) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.addOffer(params),
    );
  }

  @override
  DataResponse<GetActivityLogsModel> getActivityLogs(
    GetActivityLogsParams params,
  ) {
    return wrapHandlingException(
      tryCall: () => profileRemoteDataSource.getActivityLogs(params),
    );
  }
}

