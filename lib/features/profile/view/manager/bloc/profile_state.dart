part of 'profile_bloc.dart';

class ProfileState {
  PaginationStateModel<GetCouponCodesModelDataItem>? couponCodes;
  BlocStatus? storeHours2Status;
  DeleteStoreHoursModel? storeHours2;
  BlocStatus? addStoreHoursStatus;
  AddStoreHoursModel? addStoreHours;
  BlocStatus? storeHoursStatus;
  GetStoreHoursModel? storeHours;
  BlocStatus? storeDataStatus;
  UpdateStoreHoursModel? storeHours3;
  BlocStatus? storeHours3Status;
  UpdateStoreDataModel? storeData;
  BlocStatus? storeProfileStatus;
  GetStoreProfileModel? storeProfile;
  String? errorMessage;

  ProfileState({
    this.errorMessage,
    this.storeProfile,
    this.storeProfileStatus,
    this.storeData,
    this.storeDataStatus,
    this.storeHours,
    this.storeHoursStatus,
    this.addStoreHours,
    this.addStoreHoursStatus,
    this.storeHours3,
    this.storeHours3Status,
    this.storeHours2,
    this.storeHours2Status,
    this.couponCodes = const PaginationStateModel(perPage: 10),
  });

  ProfileState copyWith({
    String? errorMessage,
    GetStoreProfileModel? storeProfile,
    BlocStatus? storeProfileStatus,
    UpdateStoreDataModel? storeData,
    BlocStatus? storeDataStatus,
    GetStoreHoursModel? storeHours,
    BlocStatus? storeHoursStatus,
    AddStoreHoursModel? addStoreHours,
    BlocStatus? addStoreHoursStatus,
    DeleteStoreHoursModel? storeHours2,
    BlocStatus? storeHours2Status,
    UpdateStoreHoursModel? storeHours3,
    BlocStatus? storeHours3Status,
    PaginationStateModel<GetCouponCodesModelDataItem>? couponCodes,
  }) => ProfileState(
    errorMessage: errorMessage ?? this.errorMessage,
    storeProfile: storeProfile ?? this.storeProfile,
    storeProfileStatus: storeProfileStatus ?? this.storeProfileStatus,
    storeData: storeData ?? this.storeData,
    storeDataStatus: storeDataStatus ?? this.storeDataStatus,
    storeHours: storeHours ?? this.storeHours,
    storeHoursStatus: storeHoursStatus ?? this.storeHoursStatus,
    addStoreHours: addStoreHours ?? this.addStoreHours,
    addStoreHoursStatus: addStoreHoursStatus ?? this.addStoreHoursStatus,
    storeHours2: storeHours2 ?? this.storeHours2,
    storeHours2Status: storeHours2Status ?? this.storeHours2Status,
    storeHours3: storeHours3 ?? this.storeHours3,
    storeHours3Status: storeHours3Status ?? this.storeHours3Status,
    couponCodes: couponCodes ?? this.couponCodes,
  );

}
