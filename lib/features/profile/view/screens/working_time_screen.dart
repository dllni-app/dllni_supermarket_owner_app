import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/get_store_hours_model.dart';
import '../../domain/usecases/add_store_hours_use_case.dart';
import '../../domain/usecases/delete_store_hours_use_case.dart';
import '../../domain/usecases/get_store_hours_use_case.dart';
import '../../domain/usecases/update_store_hours_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import '../widgets/working_time_card.dart';

@AutoRoutePage()
class WorkingTimeScreen extends StatefulWidget {
  const WorkingTimeScreen({super.key});

  @override
  State<WorkingTimeScreen> createState() => _WorkingTimeScreenState();
}

class _WorkingTimeScreenState extends State<WorkingTimeScreen> {
  late List<WorkingScreenParams> params;
  int failedAddResponses = 0;
  int failedUpdateResponses = 0;
  int failedDeleteResponses = 0;

  static const List<String> arabicDayNames = [
    'الأحد',
    'الاثنين',
    'الثلاثاء',
    'الأربعاء',
    'الخميس',
    'الجمعة',
    'السبت',
  ];

  static const List<String> englishDayNames = [
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
  ];

  @override
  void initState() {
    params = List.generate(7, (index) => WorkingScreenParams(dayIndex: index));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayWeekday = today.weekday == 7 ? 0 : today.weekday;

    return BlocProvider(
      create: (context) =>
          getIt<ProfileBloc>()
            ..add(GetStoreHoursEvent(params: GetStoreHoursParams(storeId: 1))),
      child: Scaffold(
        body: Column(
          children: [
            AppSimpleAppBar(title: "ساعات العمل السوبر ماركت"),
            BlocListener<ProfileBloc, ProfileState>(
              listener: (context, state) {
                if (state.storeHoursStatus == BlocStatus.success) {
                  for (final GetStoreHoursModelDataItem period
                      in state.storeHours?.data ?? []) {
                    params[period.dayOfWeek ?? 0].periods.add(period);
                  }
                }
              },
              child: SizedBox(),
            ),
            Expanded(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) =>
                    previous.addStoreHoursStatus !=
                        current.addStoreHoursStatus ||
                    previous.storeHours2Status != current.storeHours2Status ||
                    previous.storeHours3Status != current.storeHours3Status,
                listener: (context, state) {
                  if (state.addStoreHoursStatus == BlocStatus.failed) {
                    failedAddResponses++;
                  }
                  if (state.storeHours3Status == BlocStatus.failed) {
                    failedUpdateResponses++;
                  }
                  if (state.storeHours2Status == BlocStatus.failed) {
                    failedDeleteResponses++;
                  }
                  if (state.addStoreHoursStatus == BlocStatus.success ||
                      state.addStoreHoursStatus == BlocStatus.failed ||
                      state.storeHours2Status == BlocStatus.success ||
                      state.storeHours2Status == BlocStatus.failed ||
                      state.storeHours3Status == BlocStatus.success ||
                      state.storeHours3Status == BlocStatus.failed) {
                    if (updateNextWorkingTimes(context, state, params)) {
                      print("=====finish uploading");
                      if (failedAddResponses != 0 ||
                          failedUpdateResponses != 0 ||
                          failedDeleteResponses != 0) {
                        AppToast.showToast(
                          context: context,
                          message:
                              "${failedDeleteResponses != 0 ? "فشل حذف $failedDeleteResponses من الفترات" : ""}${failedUpdateResponses != 0 ? "\nفشل تحديث $failedUpdateResponses من الفترات\n" : ""}${failedAddResponses != 0 ? "\nفشل إضافة $failedAddResponses من الفترات\n" : ""}",
                          type: ToastificationType.error,
                        );
                        failedAddResponses = failedUpdateResponses =
                            failedDeleteResponses = 0;
                      } else {
                        AppToast.showToast(
                          context: context,
                          message: "تم حفظ التغييرات بنجاح",
                          type: ToastificationType.success,
                        );
                      }
                      context.read<ProfileBloc>().add(
                        GetStoreHoursEvent(
                          params: GetStoreHoursParams(storeId: 1),
                        ),
                      );
                    }
                  }
                },
                buildWhen: (previous, current) =>
                    previous.storeHoursStatus != current.storeHoursStatus,
                builder: (context, state) {
                  if (state.storeHoursStatus == BlocStatus.loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state.storeHoursStatus == BlocStatus.failed) {
                    return Center(
                      child: FailureWidget(
                        message: state.errorMessage.toString(),
                        onRetry: () {
                          context.read<ProfileBloc>().add(
                            GetStoreHoursEvent(
                              params: GetStoreHoursParams(storeId: 1),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state.storeHoursStatus == BlocStatus.success) {
                    return Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: context.onPrimary,
                          ),
                          padding: EdgeInsetsDirectional.all(16),
                          margin: EdgeInsetsDirectional.symmetric(
                            horizontal: 20,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: Color(0xffEF4444).withAlpha(6),
                              border: Border.all(color: Color(0xffEF4444)),
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                              vertical: 14,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              spacing: 8,
                              children: [
                                Icon(
                                  Icons.door_back_door,
                                  color: Color(0xffEF4444),
                                  size: 16,
                                ),
                                AppText.bodyMedium(
                                  'إغلاق مؤقت للمتجر',
                                  color: Color(0xffEF4444),
                                  fontWeight: FontWeight.bold,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            itemCount: 7,
                            itemBuilder: (context, index) {
                              final isToday = index == todayWeekday;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: WorkingTimeCard(
                                  dayName: arabicDayNames[index],
                                  dayNameEn: englishDayNames[index],
                                  isToday: isToday,
                                  dayIndex: index,
                                  periods: params[index].periods,
                                  addedPeriods: params[index].newPeriods,
                                  updatedPeriods: params[index].updatedPeriods,
                                  deletedPeriods: params[index].deletedPeriods,
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 16),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, state) {
                            if (state.addStoreHoursStatus ==
                                    BlocStatus.loading ||
                                state.storeHours2Status == BlocStatus.loading ||
                                state.storeHours3Status == BlocStatus.loading) {
                              return Center(child: CircularProgressIndicator());
                            }
                            return Padding(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 24,
                              ),
                              child: Row(
                                spacing: 16,
                                children: [
                                  Expanded(
                                    child: AppButton(
                                      title: "حفظ التغييرات",
                                      onTap: () {
                                        updateNextWorkingTimes(
                                          context,
                                          state,
                                          params,
                                        );
                                      },
                                    ),
                                  ),
                                  AppOutlinedButton(
                                    title: "إلغاء",
                                    color: const Color(0xFFFF4C51),
                                    onTap: () {
                                      print("Reject");
                                      context.pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 16 + context.padding.bottom),
                      ],
                    );
                  }
                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ### this function to update the whole of periods in the store
  /// - returns `true`  ->  updates have finished
  /// - returns `false` ->  updates haven't finished
  bool updateNextWorkingTimes(
    BuildContext context,
    ProfileState state,
    List<WorkingScreenParams> params,
  ) {
    int? selectedDay = selectNextDay(params);
    print("selectedDay is : $selectedDay");
    if (selectedDay == null) return true;
    if (params[selectedDay].deletedPeriods.isNotEmpty) {
      final period = params[selectedDay].deletedPeriods.removeLast();
      context.read<ProfileBloc>().add(
        DeleteStoreHoursEvent(
          params: DeleteStoreHoursParams(periodId: period.id!),
        ),
      );
    } else if (params[selectedDay].updatedPeriods.isNotEmpty) {
      final period = params[selectedDay].updatedPeriods.removeLast();
      context.read<ProfileBloc>().add(
        UpdateStoreHoursEvent(
          params: UpdateStoreHoursParams(period: period, storeId: 1),
        ),
      );
    } else {
      final period = params[selectedDay].newPeriods.removeLast();
      period.dayOfWeek = selectedDay;
      context.read<ProfileBloc>().add(
        AddStoreHoursEvent(
          params: AddStoreHoursParams(period: period, storeId: 1),
        ),
      );
    }
    return false;
  }

  int? selectNextDay(List<WorkingScreenParams> params) {
    for (int i = 0; i < params.length; i++) {
      if (params[i].newPeriods.isNotEmpty ||
          params[i].updatedPeriods.isNotEmpty ||
          params[i].deletedPeriods.isNotEmpty) {
        return i;
      }
    }
    return null;
  }
}

class WorkingScreenParams {
  final int dayIndex;
  List<GetStoreHoursModelDataItem> periods = [];
  List<GetStoreHoursModelDataItem> newPeriods = [];
  List<GetStoreHoursModelDataItem> updatedPeriods = [];
  List<GetStoreHoursModelDataItem> deletedPeriods = [];

  WorkingScreenParams({required this.dayIndex});
}
