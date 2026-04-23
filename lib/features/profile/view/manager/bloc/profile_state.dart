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
  BlocStatus? operatingHoursStatus;
  OperatingHoursModel? operatingHours;
  BlocStatus? updateOperatingHoursStatus;
  OperatingHoursModel? lastUpdatedOperatingHours;
  BlocStatus? storeDataStatus;
  UpdateStoreDataModel? storeData;
  BlocStatus? storeProfileStatus;
  GetStoreProfileModel? storeProfile;
  String? errorMessage;
  PaginationStateModel<GetActivityLogsModelDataItem>? activityLogs;
  /// Keys: `''` for all logs, otherwise API `logName` (e.g. `orders`).
  Map<String, int> activityLogTotalsByFilter;

  ProfileState({
    this.errorMessage,
    this.storeProfile,
    this.storeProfileStatus,
    this.storeData,
    this.storeDataStatus,
    this.operatingHours,
    this.operatingHoursStatus,
    this.lastUpdatedOperatingHours,
    this.updateOperatingHoursStatus,
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
    this.activityLogs = const PaginationStateModel(perPage: 10),
    this.activityLogTotalsByFilter = const {},
  });

  ProfileState copyWith({
    String? errorMessage,
    GetStoreProfileModel? storeProfile,
    BlocStatus? storeProfileStatus,
    UpdateStoreDataModel? storeData,
    BlocStatus? storeDataStatus,
    OperatingHoursModel? operatingHours,
    BlocStatus? operatingHoursStatus,
    OperatingHoursModel? lastUpdatedOperatingHours,
    BlocStatus? updateOperatingHoursStatus,
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
    PaginationStateModel<GetActivityLogsModelDataItem>? activityLogs,
    Map<String, int>? activityLogTotalsByFilter,
  }) => ProfileState(
    errorMessage: errorMessage ?? this.errorMessage,
    storeProfile: storeProfile ?? this.storeProfile,
    storeProfileStatus: storeProfileStatus ?? this.storeProfileStatus,
    storeData: storeData ?? this.storeData,
    storeDataStatus: storeDataStatus ?? this.storeDataStatus,
    operatingHours: operatingHours ?? this.operatingHours,
    operatingHoursStatus: operatingHoursStatus ?? this.operatingHoursStatus,
    lastUpdatedOperatingHours:
        lastUpdatedOperatingHours ?? this.lastUpdatedOperatingHours,
    updateOperatingHoursStatus:
        updateOperatingHoursStatus ?? this.updateOperatingHoursStatus,
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
    activityLogs: activityLogs ?? this.activityLogs,
    activityLogTotalsByFilter:
        activityLogTotalsByFilter ?? this.activityLogTotalsByFilter,
  );
}
