part of 'profile_bloc.dart';

class ProfileState {
  BlocStatus? addOfferStatus;
  AddOfferModel? addOffer;
  BlocStatus? couponWeekAnalysisStatus;
  GetCouponWeekAnalysisModel? couponWeekAnalysis;
  BlocStatus? addCouponCodeStatus;
  AddCouponCodeModel? addCouponCode;
  BlocStatus? productsCountStatus;
  GetProductsCountModel? productsCount;
  PaginationStateModel<GetProductsModelDataItem>? products;
  PaginationStateModel<GetOfferCodesModelDataItem>? offerCodes;
  BlocStatus? addUpdateStoreEmployeeStatus;
  AddUpdateStoreEmployeeModel? addUpdateStoreEmployee;
  BlocStatus? storeEmployeesStatus;
  GetStoreEmployeesModel? storeEmployees;
  BlocStatus? offersWeeklySummaryStatus;
  GetOffersWeeklySummaryModel? offersWeeklySummary;
  BlocStatus? employeePermissionsStatus;
  GetEmployeePermissionsModel? employeePermissions;
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
    this.employeePermissions,
    this.employeePermissionsStatus,
    this.offersWeeklySummary,
    this.offersWeeklySummaryStatus,
    this.storeEmployees,
    this.storeEmployeesStatus,
    this.addUpdateStoreEmployee,
    this.addUpdateStoreEmployeeStatus,
    this.offerCodes = const PaginationStateModel(perPage: 10),
    this.products = const PaginationStateModel(perPage: 10),
    this.productsCount,
    this.productsCountStatus,
    this.addCouponCode,
    this.addCouponCodeStatus,
    this.couponWeekAnalysis,
    this.couponWeekAnalysisStatus,
    this.addOffer,
    this.addOfferStatus,
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
    GetEmployeePermissionsModel? employeePermissions,
    BlocStatus? employeePermissionsStatus,
    GetOffersWeeklySummaryModel? offersWeeklySummary,
    BlocStatus? offersWeeklySummaryStatus,
    GetStoreEmployeesModel? storeEmployees,
    BlocStatus? storeEmployeesStatus,
    AddUpdateStoreEmployeeModel? addUpdateStoreEmployee,
    BlocStatus? addUpdateStoreEmployeeStatus,
    PaginationStateModel<GetOfferCodesModelDataItem>? offerCodes,
    PaginationStateModel<GetProductsModelDataItem>? products,
    GetProductsCountModel? productsCount,
    BlocStatus? productsCountStatus,
    AddCouponCodeModel? addCouponCode,
    BlocStatus? addCouponCodeStatus,
    GetCouponWeekAnalysisModel? couponWeekAnalysis,
    BlocStatus? couponWeekAnalysisStatus,
    AddOfferModel? addOffer,
    BlocStatus? addOfferStatus,
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
    employeePermissions: employeePermissions ?? this.employeePermissions,
    employeePermissionsStatus:
        employeePermissionsStatus ?? this.employeePermissionsStatus,
    offersWeeklySummary: offersWeeklySummary ?? this.offersWeeklySummary,
    offersWeeklySummaryStatus:
        offersWeeklySummaryStatus ?? this.offersWeeklySummaryStatus,
    storeEmployees: storeEmployees ?? this.storeEmployees,
    storeEmployeesStatus: storeEmployeesStatus ?? this.storeEmployeesStatus,
    addUpdateStoreEmployee:
        addUpdateStoreEmployee ?? this.addUpdateStoreEmployee,
    addUpdateStoreEmployeeStatus:
        addUpdateStoreEmployeeStatus ?? this.addUpdateStoreEmployeeStatus,
    offerCodes: offerCodes ?? this.offerCodes,
    products: products ?? this.products,
    productsCount: productsCount ?? this.productsCount,
    productsCountStatus: productsCountStatus ?? this.productsCountStatus,
    addCouponCode: addCouponCode ?? this.addCouponCode,
    addCouponCodeStatus: addCouponCodeStatus ?? this.addCouponCodeStatus,
    couponWeekAnalysis: couponWeekAnalysis ?? this.couponWeekAnalysis,
    couponWeekAnalysisStatus:
        couponWeekAnalysisStatus ?? this.couponWeekAnalysisStatus,
    addOffer: addOffer ?? this.addOffer,
    addOfferStatus: addOfferStatus ?? this.addOfferStatus,
  );
}
