import 'package:common_package/common_package.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import '../../../domain/usecases/get_store_profile_use_case.dart';
import '../../../data/models/get_store_profile_model.dart';
import '../../../domain/usecases/update_store_data_use_case.dart';
import '../../../data/models/update_store_data_model.dart';
import '../../../domain/usecases/get_operating_hours_use_case.dart';
import '../../../data/models/operating_hours_model.dart';
import '../../../domain/usecases/update_operating_hours_use_case.dart';
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
import '../../../domain/usecases/get_offer_codes_use_case.dart';
import '../../../data/models/get_offer_codes_model.dart';
import '../../../domain/usecases/get_products_use_case.dart';
import '../../../data/models/get_products_model.dart';
import '../../../domain/usecases/get_products_count_use_case.dart';
import '../../../data/models/get_products_count_model.dart';
import '../../../domain/usecases/add_coupon_code_use_case.dart';
import '../../../data/models/add_coupon_code_model.dart';
import '../../../domain/usecases/get_coupon_week_analysis_use_case.dart';
import '../../../data/models/get_coupon_week_analysis_model.dart';
import '../../../domain/usecases/add_offer_use_case.dart';
import '../../../data/models/add_offer_model.dart';
import '../../../domain/usecases/get_activity_logs_use_case.dart';
import '../../../data/models/get_activity_logs_model.dart';

part 'profile_event.dart';
part 'profile_state.dart';

@injectable
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AddOfferUseCase addOfferUseCase;
  final GetCouponWeekAnalysisUseCase getCouponWeekAnalysisUseCase;
  final AddCouponCodeUseCase addCouponCodeUseCase;
  final GetProductsCountUseCase getProductsCountUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetOfferCodesUseCase getOfferCodesUseCase;
  final AddUpdateStoreEmployeeUseCase addUpdateStoreEmployeeUseCase;
  final GetStoreEmployeesUseCase getStoreEmployeesUseCase;
  final GetOffersWeeklySummaryUseCase getOffersWeeklySummaryUseCase;
  final GetEmployeePermissionsUseCase getEmployeePermissionsUseCase;
  final GetCouponCodesUseCase getCouponCodesUseCase;
  final UpdateOperatingHoursUseCase updateOperatingHoursUseCase;
  final GetOperatingHoursUseCase getOperatingHoursUseCase;
  final UpdateStoreDataUseCase updateStoreDataUseCase;
  final GetStoreProfileUseCase getStoreProfileUseCase;
  final GetActivityLogsUseCase getActivityLogsUseCase;
  ProfileBloc(
    this.getStoreProfileUseCase,
    this.updateStoreDataUseCase,
    this.getOperatingHoursUseCase,
    this.updateOperatingHoursUseCase,
    this.getCouponCodesUseCase,
    this.getEmployeePermissionsUseCase,
    this.getOffersWeeklySummaryUseCase,
    this.getStoreEmployeesUseCase,
    this.addUpdateStoreEmployeeUseCase,
    this.getOfferCodesUseCase,
    this.getProductsUseCase,
    this.getProductsCountUseCase,
    this.addCouponCodeUseCase,
    this.getCouponWeekAnalysisUseCase,
    this.addOfferUseCase,
    this.getActivityLogsUseCase,
  ) : super(ProfileState()) {
    on<GetStoreProfileEvent>(_getStoreProfile);
    on<UpdateStoreDataEvent>(_updateStoreData);
    on<GetOperatingHoursEvent>(_getOperatingHours);
    on<UpdateOperatingHoursEvent>(_updateOperatingHours);
    on<GetCouponCodesEvent>(_getCouponCodes, transformer: droppableProMax());
    on<GetEmployeePermissionsEvent>(_getEmployeePermissions);
    on<GetOffersWeeklySummaryEvent>(_getOffersWeeklySummary);
    on<GetStoreEmployeesEvent>(_getStoreEmployees);
    on<AddUpdateStoreEmployeeEvent>(_addUpdateStoreEmployee);
    on<GetOfferCodesEvent>(_getOfferCodes, transformer: droppableProMax());
    on<GetProductsEvent>(_getProducts, transformer: droppableProMax());
    on<GetProductsCountEvent>(_getProductsCount);
    on<AddCouponCodeEvent>(_addCouponCode);
    on<GetCouponWeekAnalysisEvent>(_getCouponWeekAnalysis);
    on<AddOfferEvent>(_addOffer);
    on<GetActivityLogsEvent>(_getActivityLogs, transformer: droppableProMax());
  }

  FutureOr<void> _getStoreProfile(
    GetStoreProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(storeProfileStatus: BlocStatus.loading));
    final res = await getStoreProfileUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            storeProfileStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            storeProfileStatus: BlocStatus.success,
            storeProfile: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _updateStoreData(
    UpdateStoreDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(storeDataStatus: BlocStatus.loading));
    final res = await updateStoreDataUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            storeDataStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(state.copyWith(storeDataStatus: BlocStatus.success, storeData: r));
      },
    );
  }

  FutureOr<void> _getOperatingHours(
    GetOperatingHoursEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(operatingHoursStatus: BlocStatus.loading));
    final res = await getOperatingHoursUseCase(NoParams());
    res.fold(
      (l) {
        emit(
          state.copyWith(
            operatingHoursStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            operatingHoursStatus: BlocStatus.success,
            operatingHours: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _updateOperatingHours(
    UpdateOperatingHoursEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(updateOperatingHoursStatus: BlocStatus.loading));
    final res = await updateOperatingHoursUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            updateOperatingHoursStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            updateOperatingHoursStatus: BlocStatus.success,
            lastUpdatedOperatingHours: r,
          ),
        );
      },
    );
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getCouponCodes(
    GetCouponCodesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.couponCodes!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          couponCodes: state.couponCodes!.setLoading(isReload: event.isReload),
        ),
      );
      final res = await getCouponCodesUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              couponCodes: state.couponCodes!.setFaild(errorMessage: l.message),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              couponCodes: state.couponCodes!.setSuccess(data: r.data!),
            ),
          );
        },
      );
    }
  }

  FutureOr<void> _getActivityLogs(
    GetActivityLogsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.activityLogs!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          activityLogs: state.activityLogs!.setLoading(
            isReload: event.isReload,
          ),
        ),
      );
      final res = await getActivityLogsUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              activityLogs: state.activityLogs!.setFaild(
                errorMessage: l.message,
              ),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          final totals = Map<String, int>.from(state.activityLogTotalsByFilter);
          final key = event.params.logName ?? '';
          final metaTotal = r.meta?.total;
          if (metaTotal != null) {
            totals[key] = metaTotal;
          }
          emit(
            state.copyWith(
              activityLogs: state.activityLogs!.setSuccess(data: r.data ?? []),
              activityLogTotalsByFilter: totals,
            ),
          );
        },
      );
    }
  }

  FutureOr<void> _getEmployeePermissions(
    GetEmployeePermissionsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(employeePermissionsStatus: BlocStatus.loading));
    final res = await getEmployeePermissionsUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            employeePermissionsStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            employeePermissionsStatus: BlocStatus.success,
            employeePermissions: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _getOffersWeeklySummary(
    GetOffersWeeklySummaryEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(offersWeeklySummaryStatus: BlocStatus.loading));
    final res = await getOffersWeeklySummaryUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            offersWeeklySummaryStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            offersWeeklySummaryStatus: BlocStatus.success,
            offersWeeklySummary: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _getStoreEmployees(
    GetStoreEmployeesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(storeEmployeesStatus: BlocStatus.loading));
    final res = await getStoreEmployeesUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            storeEmployeesStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            storeEmployeesStatus: BlocStatus.success,
            storeEmployees: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _addUpdateStoreEmployee(
    AddUpdateStoreEmployeeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addUpdateStoreEmployeeStatus: BlocStatus.loading));
    final res = await addUpdateStoreEmployeeUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            addUpdateStoreEmployeeStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            addUpdateStoreEmployeeStatus: BlocStatus.success,
            addUpdateStoreEmployee: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _getOfferCodes(
    GetOfferCodesEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.offerCodes!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          offerCodes: state.offerCodes!.setLoading(isReload: event.isReload),
        ),
      );
      final res = await getOfferCodesUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              offerCodes: state.offerCodes!.setFaild(errorMessage: l.message),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              offerCodes: state.offerCodes!.setSuccess(data: r.data!),
            ),
          );
        },
      );
    }
  }

  FutureOr<void> _getProducts(
    GetProductsEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (!state.products!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          products: state.products!.setLoading(isReload: event.isReload),
        ),
      );
      final res = await getProductsUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              products: state.products!.setFaild(errorMessage: l.message),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(products: state.products!.setSuccess(data: r.data!)),
          );
        },
      );
    }
  }

  FutureOr<void> _getProductsCount(
    GetProductsCountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(productsCountStatus: BlocStatus.loading));
    final res = await getProductsCountUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            productsCountStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            productsCountStatus: BlocStatus.success,
            productsCount: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _addCouponCode(
    AddCouponCodeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addCouponCodeStatus: BlocStatus.loading));
    final res = await addCouponCodeUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            addCouponCodeStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            addCouponCodeStatus: BlocStatus.success,
            addCouponCode: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _getCouponWeekAnalysis(
    GetCouponWeekAnalysisEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(couponWeekAnalysisStatus: BlocStatus.loading));
    final res = await getCouponWeekAnalysisUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            couponWeekAnalysisStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            couponWeekAnalysisStatus: BlocStatus.success,
            couponWeekAnalysis: r,
          ),
        );
      },
    );
  }

  FutureOr<void> _addOffer(
    AddOfferEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(addOfferStatus: BlocStatus.loading));
    final res = await addOfferUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            addOfferStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(state.copyWith(addOfferStatus: BlocStatus.success, addOffer: r));
      },
    );
  }
}
