import 'package:common_package/helpers/typedef.dart';
import '../usecases/get_store_profile_use_case.dart';
import '../../data/models/get_store_profile_model.dart';
import '../usecases/update_store_data_use_case.dart';
import '../../data/models/update_store_data_model.dart';
import '../usecases/get_store_hours_use_case.dart';
import '../../data/models/get_store_hours_model.dart';
import '../usecases/add_store_hours_use_case.dart';
import '../../data/models/add_store_hours_model.dart';
import '../usecases/update_store_hours_use_case.dart';
import '../../data/models/update_store_hours_model.dart';
import '../usecases/delete_store_hours_use_case.dart';
import '../../data/models/delete_store_hours_model.dart';
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
abstract class ProfileRepo {
  DataResponse<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params);


  DataResponse<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params);

  DataResponse<GetStoreHoursModel> getStoreHours(GetStoreHoursParams params);

  DataResponse<AddStoreHoursModel> addStoreHours(AddStoreHoursParams params);

  DataResponse<UpdateStoreHoursModel> updateStoreHours(UpdateStoreHoursParams params);

  DataResponse<DeleteStoreHoursModel> deleteStoreHours(DeleteStoreHoursParams params);


  DataResponse<GetCouponCodesModel> getCouponCodes(GetCouponCodesParams params);

  DataResponse<GetEmployeePermissionsModel> getEmployeePermissions(GetEmployeePermissionsParams params);

  DataResponse<GetOffersWeeklySummaryModel> getOffersWeeklySummary(GetOffersWeeklySummaryParams params);

  DataResponse<GetStoreEmployeesModel> getStoreEmployees(GetStoreEmployeesParams params);

  DataResponse<AddUpdateStoreEmployeeModel> addUpdateStoreEmployee(AddUpdateStoreEmployeeParams params);
}
