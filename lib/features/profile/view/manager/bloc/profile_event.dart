part of 'profile_bloc.dart';

abstract class ProfileEvent {}

class GetStoreProfileEvent extends ProfileEvent {
  final GetStoreProfileParams params;

  GetStoreProfileEvent({required this.params});
}

class UpdateStoreDataEvent extends ProfileEvent {
  final UpdateStoreDataParams params;

  UpdateStoreDataEvent({required this.params});
}

class GetOperatingHoursEvent extends ProfileEvent {}

class UpdateOperatingHoursEvent extends ProfileEvent {
  final UpdateOperatingHoursParams params;

  UpdateOperatingHoursEvent({required this.params});
}

class GetCouponCodesEvent extends ProfileEvent with EventWithReload {
  final GetCouponCodesParams params;

  @override
  final bool isReload;

  GetCouponCodesEvent({required this.params, this.isReload = false});
}

class GetEmployeePermissionsEvent extends ProfileEvent {
  final GetEmployeePermissionsParams params;

  GetEmployeePermissionsEvent({required this.params});
}

class GetOffersWeeklySummaryEvent extends ProfileEvent {
  final GetOffersWeeklySummaryParams params;

  GetOffersWeeklySummaryEvent({required this.params});
}

class GetStoreEmployeesEvent extends ProfileEvent {
  final GetStoreEmployeesParams params;

  GetStoreEmployeesEvent({required this.params});
}

class AddUpdateStoreEmployeeEvent extends ProfileEvent {
  final AddUpdateStoreEmployeeParams params;

  AddUpdateStoreEmployeeEvent({required this.params});
}

class GetOfferCodesEvent extends ProfileEvent with EventWithReload {
  final GetOfferCodesParams params;

  @override
  final bool isReload;

  GetOfferCodesEvent({required this.params, this.isReload = false});
}

class GetProductsEvent extends ProfileEvent with EventWithReload {
  final GetProductsParams params;

  @override
  final bool isReload;

  GetProductsEvent({required this.params, this.isReload = false});
}

class GetProductsCountEvent extends ProfileEvent {
  final GetProductsCountParams params;

  GetProductsCountEvent({required this.params});
}

class AddCouponCodeEvent extends ProfileEvent {
  final AddCouponCodeParams params;

  AddCouponCodeEvent({required this.params});
}

class GetCouponWeekAnalysisEvent extends ProfileEvent {
  final GetCouponWeekAnalysisParams params;

  GetCouponWeekAnalysisEvent({required this.params});
}

class AddOfferEvent extends ProfileEvent {
  final AddOfferParams params;

  AddOfferEvent({required this.params});
}

class GetActivityLogsEvent extends ProfileEvent with EventWithReload {
  final GetActivityLogsParams params;

  @override
  final bool isReload;

  GetActivityLogsEvent({required this.params, this.isReload = false});
}
