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

class GetStoreHoursEvent extends ProfileEvent {
  final GetStoreHoursParams params;

  GetStoreHoursEvent({required this.params});
}

class AddStoreHoursEvent extends ProfileEvent {
  final AddStoreHoursParams params;

  AddStoreHoursEvent({required this.params});
}

class UpdateStoreHoursEvent extends ProfileEvent {
  final UpdateStoreHoursParams params;

  UpdateStoreHoursEvent({required this.params});
}

class DeleteStoreHoursEvent extends ProfileEvent {
  final DeleteStoreHoursParams params;

  DeleteStoreHoursEvent({required this.params});
}

class GetCouponCodesEvent extends ProfileEvent with EventWithReload {
  final GetCouponCodesParams params;

  @override
  final bool isReload;

  GetCouponCodesEvent({required this.params, this.isReload = false});
}
