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
  }}

