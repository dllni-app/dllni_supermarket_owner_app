import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/operating_hours_model.dart';
import '../../domain/usecases/update_operating_hours_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import '../working_day_draft.dart';
import '../widgets/working_time_card.dart';

@AutoRoutePage()
class WorkingTimeScreen extends StatefulWidget {
  const WorkingTimeScreen({super.key});

  @override
  State<WorkingTimeScreen> createState() => _WorkingTimeScreenState();
}

/// PUT body order (matches API sample: Monday → Sunday).
const List<String> _kApiPutDayOrder = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

int _apiDayToUiIndex(String? day) {
  switch ((day ?? '').toLowerCase()) {
    case 'sunday':
      return 0;
    case 'monday':
      return 1;
    case 'tuesday':
      return 2;
    case 'wednesday':
      return 3;
    case 'thursday':
      return 4;
    case 'friday':
      return 5;
    case 'saturday':
      return 6;
    default:
      return -1;
  }
}

class _WorkingTimeScreenState extends State<WorkingTimeScreen> {
  late final List<WorkingDayDraft> dayDrafts;
  bool isTemporarilyClosed = false;

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
    super.initState();
    dayDrafts = List.generate(
      7,
      (_) => WorkingDayDraft(isEnabled: true),
    );
  }

  void _applyOperatingHours(OperatingHoursModel? model) {
    final data = model?.data;
    if (data == null) return;
    setState(() {
      isTemporarilyClosed = data.isTemporarilyClosed ?? false;
      for (final d in dayDrafts) {
        d.isEnabled = true;
        d.slots.clear();
      }
      for (final daily in data.dailyHours ?? []) {
        final idx = _apiDayToUiIndex(daily.dayOfWeek);
        if (idx < 0 || idx > 6) continue;
        dayDrafts[idx].isEnabled = daily.isEnabled ?? false;
        dayDrafts[idx].slots.clear();
        if (!dayDrafts[idx].isEnabled) continue;
        for (final ts in daily.timeSlots ?? []) {
          dayDrafts[idx].slots.add(
            OperatingHoursTimeSlot(
              startTime: apiTimeToHHmm(ts.startTime) ?? ts.startTime,
              endTime: apiTimeToHHmm(ts.endTime) ?? ts.endTime,
            ),
          );
        }
      }
    });
  }

  List<OperatingHoursDaily> _buildDailyHoursForPut() {
    final out = <OperatingHoursDaily>[];
    for (final apiDay in _kApiPutDayOrder) {
      final idx = _apiDayToUiIndex(apiDay);
      final draft = dayDrafts[idx];
      var enabled = draft.isEnabled;
      final slots = <OperatingHoursTimeSlot>[];
      if (enabled) {
        for (final slot in draft.slots) {
          final st = slot.startTime?.trim() ?? '';
          final en = slot.endTime?.trim() ?? '';
          if (st.isEmpty || en.isEmpty) continue;
          slots.add(
            OperatingHoursTimeSlot(
              startTime: hhmmToApiTime(st),
              endTime: hhmmToApiTime(en),
            ),
          );
        }
        if (slots.isEmpty) {
          enabled = false;
        }
      }
      out.add(
        OperatingHoursDaily(
          dayOfWeek: apiDay,
          isEnabled: enabled,
          timeSlots: enabled ? slots : [],
        ),
      );
    }
    return out;
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final todayWeekday = today.weekday == 7 ? 0 : today.weekday;

    return BlocProvider(
      create: (context) =>
          getIt<ProfileBloc>()..add(GetOperatingHoursEvent()),
      child: Scaffold(
        body: Column(
          children: [
            AppSimpleAppBar(title: "ساعات العمل السوبر ماركت"),
            Expanded(
              child: BlocListener<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) =>
                    previous.operatingHours != current.operatingHours &&
                    current.operatingHoursStatus == BlocStatus.success,
                listener: (context, state) {
                  _applyOperatingHours(state.operatingHours);
                },
                child: BlocListener<ProfileBloc, ProfileState>(
                  listenWhen: (previous, current) =>
                      previous.updateOperatingHoursStatus !=
                      current.updateOperatingHoursStatus,
                  listener: (context, state) {
                    if (state.updateOperatingHoursStatus ==
                        BlocStatus.failed) {
                      AppToast.showToast(
                        context: context,
                        message: state.errorMessage ?? 'Unknown Error',
                        type: ToastificationType.error,
                      );
                    }
                    if (state.updateOperatingHoursStatus ==
                        BlocStatus.success) {
                      AppToast.showToast(
                        context: context,
                        message: 'تم حفظ التغييرات بنجاح',
                        type: ToastificationType.success,
                      );
                      context.read<ProfileBloc>().add(
                        GetOperatingHoursEvent(),
                      );
                    }
                  },
                  child: BlocBuilder<ProfileBloc, ProfileState>(
                    buildWhen: (previous, current) =>
                        previous.operatingHoursStatus !=
                            current.operatingHoursStatus ||
                        previous.updateOperatingHoursStatus !=
                            current.updateOperatingHoursStatus,
                    builder: (context, state) {
                      if (state.operatingHoursStatus == BlocStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      if (state.operatingHoursStatus == BlocStatus.failed) {
                        return Center(
                          child: FailureWidget(
                            message: state.errorMessage.toString(),
                            onRetry: () {
                              context.read<ProfileBloc>().add(
                                GetOperatingHoursEvent(),
                              );
                            },
                          ),
                        );
                      }
                      if (state.operatingHoursStatus == BlocStatus.success) {
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
                                  vertical: 8,
                                  horizontal: 12,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.door_back_door,
                                      color: Color(0xffEF4444),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: AppText.bodyMedium(
                                        'إغلاق مؤقت للمتجر',
                                        color: Color(0xffEF4444),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Switch(
                                      value: isTemporarilyClosed,
                                      onChanged: (v) {
                                        setState(() => isTemporarilyClosed = v);
                                      },
                                      activeTrackColor: Color(0xffEF4444),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                itemCount: 7,
                                itemBuilder: (context, index) {
                                  final isToday = index == todayWeekday;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 16),
                                    child: WorkingTimeCard(
                                      dayName: arabicDayNames[index],
                                      dayNameEn: englishDayNames[index],
                                      isToday: isToday,
                                      day: dayDrafts[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 16),
                            if (state.updateOperatingHoursStatus ==
                                BlocStatus.loading)
                              Center(child: CircularProgressIndicator())
                            else
                              Padding(
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
                                          context.read<ProfileBloc>().add(
                                            UpdateOperatingHoursEvent(
                                              params:
                                                  UpdateOperatingHoursParams(
                                                isTemporarilyClosed:
                                                    isTemporarilyClosed,
                                                dailyHours:
                                                    _buildDailyHoursForPut(),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    AppOutlinedButton(
                                      title: "إلغاء",
                                      color: const Color(0xFFFF4C51),
                                      onTap: () => context.pop(),
                                    ),
                                  ],
                                ),
                              ),
                            SizedBox(height: 16 + context.padding.bottom),
                          ],
                        );
                      }
                      return SizedBox();
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
