import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import '../../../domain/usecases/get_store_profile_use_case.dart';
import '../../../data/models/get_store_profile_model.dart';
import '../../../domain/usecases/update_store_data_use_case.dart';
import '../../../data/models/update_store_data_model.dart';
import '../../../domain/usecases/get_store_hours_use_case.dart';
import '../../../data/models/get_store_hours_model.dart';
import '../../../domain/usecases/add_store_hours_use_case.dart';
import '../../../data/models/add_store_hours_model.dart';
import '../../../domain/usecases/update_store_hours_use_case.dart';
import '../../../data/models/update_store_hours_model.dart';
import '../../../domain/usecases/delete_store_hours_use_case.dart';
import '../../../data/models/delete_store_hours_model.dart';
import 'package:common_package/helpers/droppable_helper.dart';
import '../../../domain/usecases/get_coupon_codes_use_case.dart';
import '../../../data/models/get_coupon_codes_model.dart';
import '../../../domain/usecases/get_employee_permissions_use_case.dart';
import '../../../data/models/get_employee_permissions_model.dart';
import '../../../domain/usecases/get_offers_weekly_summary_use_case.dart';
import '../../../data/models/get_offers_weekly_summary_model.dart';
import '../../../domain/usecases/get_store_employees_use_case.dart';
import '../../../data/models/get_store_employees_model.dart';
import '../../../domain/usecases/add_update_store_employee_use_case.dart';
import '../../../data/models/add_update_store_employee_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AddUpdateStoreEmployeeUseCase addUpdateStoreEmployeeUseCase;
  final GetStoreEmployeesUseCase getStoreEmployeesUseCase;
  final GetOffersWeeklySummaryUseCase getOffersWeeklySummaryUseCase;
  final GetEmployeePermissionsUseCase getEmployeePermissionsUseCase;
  final GetCouponCodesUseCase getCouponCodesUseCase;
  final DeleteStoreHoursUseCase deleteStoreHoursUseCase;
  final UpdateStoreHoursUseCase updateStoreHoursUseCase;
  final AddStoreHoursUseCase addStoreHoursUseCase;
  final GetStoreHoursUseCase getStoreHoursUseCase;
  final UpdateStoreDataUseCase updateStoreDataUseCase;
  final GetStoreProfileUseCase getStoreProfileUseCase;
  ProfileBloc(
    this.getStoreProfileUseCase,
    this.updateStoreDataUseCase,
    this.getStoreHoursUseCase,
    this.addStoreHoursUseCase,
    this.updateStoreHoursUseCase,
    this.deleteStoreHoursUseCase,
    this.getCouponCodesUseCase,
    this.getEmployeePermissionsUseCase,
    this.getOffersWeeklySummaryUseCase,
    this.getStoreEmployeesUseCase,
    this.addUpdateStoreEmployeeUseCase,) : super(ProfileState()) {
    
  
    on<GetStoreProfileEvent>(_getStoreProfile);
    on<UpdateStoreDataEvent>(_updateStoreData);
    on<GetStoreHoursEvent>(_getStoreHours);
    on<AddStoreHoursEvent>(_addStoreHours);
    on<UpdateStoreHoursEvent>(_updateStoreHours);
    on<DeleteStoreHoursEvent>(_deleteStoreHours);
    on<GetCouponCodesEvent>(_getCouponCodes, transformer: droppableProMax());
    on<GetEmployeePermissionsEvent>(_getEmployeePermissions);
    on<GetOffersWeeklySummaryEvent>(_getOffersWeeklySummary);
    on<GetStoreEmployeesEvent>(_getStoreEmployees);
    on<AddUpdateStoreEmployeeEvent>(_addUpdateStoreEmployee);}


  FutureOr<void> _getStoreProfile(GetStoreProfileEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeProfileStatus: BlocStatus.loading));
    final res = await getStoreProfileUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeProfileStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeProfileStatus: BlocStatus.success,
        storeProfile: r,
      ));
    });
  }


  FutureOr<void> _updateStoreData(UpdateStoreDataEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeDataStatus: BlocStatus.loading));
    final res = await updateStoreDataUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeDataStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeDataStatus: BlocStatus.success,
        storeData: r,
      ));
    });
  }

  FutureOr<void> _getStoreHours(GetStoreHoursEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeHoursStatus: BlocStatus.loading));
    final res = await getStoreHoursUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeHoursStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeHoursStatus: BlocStatus.success,
        storeHours: r,
      ));
    });
  }

  FutureOr<void> _addStoreHours(AddStoreHoursEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(addStoreHoursStatus: BlocStatus.loading));
    final res = await addStoreHoursUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        addStoreHoursStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        addStoreHoursStatus: BlocStatus.success,
        addStoreHours: r,
      ));
    });
  }

  FutureOr<void> _updateStoreHours(UpdateStoreHoursEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeHours3Status: BlocStatus.loading));
    final res = await updateStoreHoursUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeHours3Status: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeHours3Status: BlocStatus.success,
        storeHours3: r,
      ));
    });
  }

  FutureOr<void> _deleteStoreHours(DeleteStoreHoursEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeHours2Status: BlocStatus.loading));
    final res = await deleteStoreHoursUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeHours2Status: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeHours2Status: BlocStatus.success,
        storeHours2: r,
      ));
    });
  }


  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getCouponCodes(GetCouponCodesEvent event, Emitter<ProfileState> emit) async {
    if (!state.couponCodes!.isEndPage || event.isReload) {
      emit(state.copyWith(
        couponCodes: state.couponCodes!.setLoading(isReload: event.isReload),
      ));
      final res = await getCouponCodesUseCase(event.params);
      res.fold((l) {
        emit(state.copyWith(
          couponCodes: state.couponCodes!.setFaild(errorMessage: l.message),
          errorMessage: l.message,
        ));
      }, (r) {
        emit(state.copyWith(
          couponCodes: state.couponCodes!.setSuccess(data: r.data!),
        ));
      });
    }
  }

  FutureOr<void> _getEmployeePermissions(GetEmployeePermissionsEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(employeePermissionsStatus: BlocStatus.loading));
    final res = await getEmployeePermissionsUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        employeePermissionsStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        employeePermissionsStatus: BlocStatus.success,
        employeePermissions: r,
      ));
    });
  }

  FutureOr<void> _getOffersWeeklySummary(GetOffersWeeklySummaryEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(offersWeeklySummaryStatus: BlocStatus.loading));
    final res = await getOffersWeeklySummaryUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        offersWeeklySummaryStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        offersWeeklySummaryStatus: BlocStatus.success,
        offersWeeklySummary: r,
      ));
    });
  }

  FutureOr<void> _getStoreEmployees(GetStoreEmployeesEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(storeEmployeesStatus: BlocStatus.loading));
    final res = await getStoreEmployeesUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        storeEmployeesStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        storeEmployeesStatus: BlocStatus.success,
        storeEmployees: r,
      ));
    });
  }

  FutureOr<void> _addUpdateStoreEmployee(AddUpdateStoreEmployeeEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(addUpdateStoreEmployeeStatus: BlocStatus.loading));
    final res = await addUpdateStoreEmployeeUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        addUpdateStoreEmployeeStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        addUpdateStoreEmployeeStatus: BlocStatus.success,
        addUpdateStoreEmployee: r,
      ));
    });
  }}
