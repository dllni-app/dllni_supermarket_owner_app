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
abstract class ProfileRepo {
  DataResponse<GetStoreProfileModel> getStoreProfile(GetStoreProfileParams params);


  DataResponse<UpdateStoreDataModel> updateStoreData(UpdateStoreDataParams params);

  DataResponse<GetStoreHoursModel> getStoreHours(GetStoreHoursParams params);

  DataResponse<AddStoreHoursModel> addStoreHours(AddStoreHoursParams params);

  DataResponse<UpdateStoreHoursModel> updateStoreHours(UpdateStoreHoursParams params);

  DataResponse<DeleteStoreHoursModel> deleteStoreHours(DeleteStoreHoursParams params);


  DataResponse<GetCouponCodesModel> getCouponCodes(GetCouponCodesParams params);
}
