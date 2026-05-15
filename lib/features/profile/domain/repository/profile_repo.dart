import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_store_profile_use_case.dart';
import '../../data/models/get_store_profile_model.dart';
import '../usecases/update_store_data_use_case.dart';
import '../../data/models/update_store_data_model.dart';
import '../usecases/get_operating_hours_use_case.dart';
import '../../data/models/operating_hours_model.dart';
import '../usecases/update_operating_hours_use_case.dart';
import '../usecases/get_coupon_codes_use_case.dart';
import '../../data/models/get_coupon_codes_model.dart';
import '../usecases/get_employee_permissions_use_case.dart';
import '../../data/models/get_employee_permissions_model.dart';
import '../usecases/get_offers_weekly_summary_use_case.dart';
import '../../data/models/get_offers_weekly_summary_model.dart';
import '../usecases/get_store_employees_use_case.dart';
import '../../data/models/get_store_employees_model.dart';
import '../usecases/add_update_store_employee_use_case.dart';
import '../../data/models/add_update_store_employee_model.dart';
import '../usecases/get_offer_codes_use_case.dart';
import '../../data/models/get_offer_codes_model.dart';
import '../usecases/get_products_use_case.dart';
import '../../data/models/get_products_model.dart';
import '../usecases/get_products_count_use_case.dart';
import '../../data/models/get_products_count_model.dart';
import '../usecases/add_coupon_code_use_case.dart';
import '../../data/models/add_coupon_code_model.dart';
import '../usecases/get_coupon_week_analysis_use_case.dart';
import '../../data/models/get_coupon_week_analysis_model.dart';
import '../usecases/add_offer_use_case.dart';
import '../../data/models/add_offer_model.dart';
import '../usecases/get_activity_logs_use_case.dart';
import '../../data/models/get_activity_logs_model.dart';
abstract class ProfileRepo {
  DataResponse<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params);


  DataResponse<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params);

  DataResponse<OperatingHoursModel> getOperatingHours(NoParams params);

  DataResponse<OperatingHoursModel> updateOperatingHours(
    UpdateOperatingHoursParams params,
  );


  DataResponse<GetCouponCodesModel> getCouponCodes(GetCouponCodesParams params);

  DataResponse<GetEmployeePermissionsModel> getEmployeePermissions(GetEmployeePermissionsParams params);

  DataResponse<GetOffersWeeklySummaryModel> getOffersWeeklySummary(GetOffersWeeklySummaryParams params);

  DataResponse<GetStoreEmployeesModel> getStoreEmployees(GetStoreEmployeesParams params);

  DataResponse<AddUpdateStoreEmployeeModel> addUpdateStoreEmployee(AddUpdateStoreEmployeeParams params);

  DataResponse<GetOfferCodesModel> getOfferCodes(GetOfferCodesParams params);

  DataResponse<GetProductsModel> getProducts(GetProductsParams params);

  DataResponse<GetProductsCountModel> getProductsCount(GetProductsCountParams params);

  DataResponse<AddCouponCodeModel> addCouponCode(AddCouponCodeParams params);

  DataResponse<GetCouponWeekAnalysisModel> getCouponWeekAnalysis(GetCouponWeekAnalysisParams params);

  DataResponse<AddOfferModel> addOffer(AddOfferParams params);

  DataResponse<GetActivityLogsModel> getActivityLogs(GetActivityLogsParams params);
}
