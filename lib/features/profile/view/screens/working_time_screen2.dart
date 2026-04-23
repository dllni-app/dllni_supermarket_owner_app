// import 'package:common_package/common_package.dart';
// import 'package:dllni_resturant_owner_app/core/di/injection.dart';
// import 'package:dllni_resturant_owner_app/features/profile/domain/usecases/fetch_working_time_use_case.dart';
// import 'package:dllni_resturant_owner_app/features/profile/domain/usecases/update_working_time_use_case.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../../data/models/fetch_working_time_model.dart';
// import '../manager/bloc/profile_bloc.dart';
// import '../widgets/working_time_app_bar.dart';
// import '../widgets/working_time_card.dart';

// @AutoRoutePage()
// class WorkingTimeScreen extends StatefulWidget {
//   const WorkingTimeScreen({super.key});

//   @override
//   State<WorkingTimeScreen> createState() => _WorkingTimeScreenState();
// }

// class _WorkingTimeScreenState extends State<WorkingTimeScreen> {
//   static const List<String> arabicDayNames = [
//     'الأحد',
//     'الاثنين',
//     'الثلاثاء',
//     'الأربعاء',
//     'الخميس',
//     'الجمعة',
//     'السبت',
//   ];

//   static const List<String> englishDayNames = [
//     'Sunday',
//     'Monday',
//     'Tuesday',
//     'Wednesday',
//     'Thursday',
//     'Friday',
//     'Saturday',
//   ];

//   Map<String, DailyHoursRequest> days = {};

//   bool tempClosed = false;

//   @override
//   Widget build(BuildContext context) {
//     final today = DateTime.now();
//     final todayWeekday = today.weekday == 7 ? 0 : today.weekday;

//     return BlocProvider<ProfileBloc>(
//       lazy: false,
//       create: (context) =>
//           getIt<ProfileBloc>()
//             ..add(FetchWorkingTimeEvent(params: FetchWorkingTimeParams())),
//       child: Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               const WorkingTimeAppBar(),
//               Expanded(
//                 child: BlocBuilder<ProfileBloc, ProfileState>(
//                   builder: (context, state) {
//                     switch (state.workingTimeStatus) {
//                       case null:
//                         return SizedBox.shrink();
//                       case BlocStatus.failed:
//                         return Center(
//                           child: AppText.labelLarge(
//                             state.errorMessage ?? 'حدث خطا ما',
//                             color: context.error,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         );
//                       case BlocStatus.success:
//                         final workingData = state.workingTime!.data!;

//                         tempClosed =
//                             state.workingTime?.data?.isTemporarilyClosed ??
//                             false;

//                         final dayDataMap = <String, FetchWorkingTimeDay>{};
//                         if (workingData.dailyHours != null) {
//                           for (final day in workingData.dailyHours!) {
//                             if (day.dayOfWeek != null) {
//                               days[day.dayOfWeek!
//                                   .toLowerCase()] = DailyHoursRequest(
//                                 timeSlots: day.timeSlots!
//                                     .map(
//                                       (e) => TimeSlotRequest(
//                                         startTime: e.startTime!,
//                                         endTime: e.endTime!,
//                                       ),
//                                     )
//                                     .toList(),
//                                 isEnabled: day.isEnabled ?? false,
//                                 dayOfWeek: day.dayOfWeek!,
//                               );
//                             }
//                           }
//                         }

//                         return Column(
//                           children: [
//                             const SizedBox(height: 16),
//                             InkWell(
//                               onTap: () {
//                                 context.read<ProfileBloc>().add(
//                                   UpdateWorkingTimeEvent(
//                                     params: UpdateWorkingTimeParams(
//                                       isTemporarilyClosed: !tempClosed,
//                                     ),
//                                   ),
//                                 );
//                               },
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(16),
//                                   color: context.onPrimary,
//                                 ),
//                                 padding: EdgeInsetsDirectional.all(16),
//                                 margin: EdgeInsetsDirectional.symmetric(
//                                   horizontal: 20,
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(16),
//                                     color: Color(0xffEF4444).withAlpha(6),
//                                     border: Border.all(
//                                       color: Color(0xffEF4444),
//                                     ),
//                                   ),
//                                   padding: EdgeInsetsDirectional.symmetric(
//                                     vertical: 14,
//                                   ),
//                                   child: Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Icon(
//                                         Icons.door_back_door,
//                                         color: Color(0xffEF4444),
//                                         size: 15,
//                                       ),
//                                       AppText.bodyMedium(
//                                         tempClosed
//                                             ? 'المتجر مغلق, انقر لفتح المتجر'
//                                             : 'إغلاق مؤقت للمتجر',
//                                         color: Color(0xffEF4444),
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(height: 16),
//                             Expanded(
//                               child: tempClosed
//                                   ? Center(
//                                       child: AppText.labelLarge(
//                                         'المتجر مغلق, افتح المتجر لادارة وقتك',
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     )
//                                   : ListView.builder(
//                                       padding: const EdgeInsets.symmetric(
//                                         horizontal: 20,
//                                       ),
//                                       itemCount: 7,
//                                       itemBuilder: (context, index) {
//                                         final isToday = index == todayWeekday;
//                                         final dayNameEn =
//                                             englishDayNames[index];
//                                         final dayData =
//                                             dayDataMap[dayNameEn.toLowerCase()];

//                                         return Padding(
//                                           padding: const EdgeInsets.only(
//                                             bottom: 16,
//                                           ),
//                                           child: WorkingTimeCard(
//                                             dayName: arabicDayNames[index],
//                                             dayNameEn: dayNameEn,
//                                             isToday: isToday,
//                                             dayIndex: index,
//                                             dayData:
//                                                 days[dayNameEn.toLowerCase()],
//                                             onChanged: (dayIndex, enabled, periods) {
//                                               if (days.containsKey(
//                                                 dayNameEn.toLowerCase(),
//                                               )) {
//                                                 days[dayNameEn.toLowerCase()] =
//                                                     DailyHoursRequest(
//                                                       dayOfWeek: dayNameEn
//                                                           .toLowerCase(),
//                                                       isEnabled: enabled,
//                                                       timeSlots: periods
//                                                           .map(
//                                                             (per) =>
//                                                                 TimeSlotRequest(
//                                                                   startTime:
//                                                                       per.from ??
//                                                                       '',
//                                                                   endTime:
//                                                                       per.to ??
//                                                                       '',
//                                                                 ),
//                                                           )
//                                                           .toList(),
//                                                     );
//                                               } else {
//                                                 days.addAll({
//                                                   dayNameEn.toLowerCase():
//                                                       DailyHoursRequest(
//                                                         dayOfWeek: dayNameEn
//                                                             .toLowerCase(),
//                                                         isEnabled: enabled,
//                                                         timeSlots: periods
//                                                             .map(
//                                                               (
//                                                                 per,
//                                                               ) => TimeSlotRequest(
//                                                                 startTime:
//                                                                     per.from!,
//                                                                 endTime:
//                                                                     per.to!,
//                                                               ),
//                                                             )
//                                                             .toList(),
//                                                       ),
//                                                 });
//                                               }
//                                             },
//                                           ),
//                                         );
//                                       },
//                                     ),
//                             ),
//                           ],
//                         );
//                       case BlocStatus.loading:
//                         return Center(
//                           child: CircularProgressIndicator.adaptive(),
//                         );
//                       case BlocStatus.init:
//                         return Center(
//                           child: CircularProgressIndicator.adaptive(),
//                         );
//                     }
//                   },
//                 ),
//               ),
//               const SizedBox(height: 10),
//               BlocConsumer<ProfileBloc, ProfileState>(
//                 listener: (context, state) {
//                   if (state.updateWorkingTimeStatus == BlocStatus.success) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: AppText.bodyMedium(
//                           'تم حفظ التغييرات بنجاح',
//                           color: Colors.white,
//                         ),
//                         backgroundColor: Colors.green,
//                       ),
//                     );
//                     context.pop();
//                   } else if (state.updateWorkingTimeStatus ==
//                       BlocStatus.failed) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       SnackBar(
//                         content: AppText.bodyMedium(
//                           state.errorMessage ?? 'حدث خطأ أثناء حفظ التغييرات',
//                           color: Colors.white,
//                         ),
//                         backgroundColor: Colors.red,
//                       ),
//                     );
//                   }
//                 },
//                 builder: (context, state) {
//                   final isLoading =
//                       state.updateWorkingTimeStatus == BlocStatus.loading;
//                   return Padding(
//                     padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
//                     child: Row(
//                       children: [
//                         Expanded(
//                           flex: 5,
//                           child: GestureDetector(
//                             onTap: isLoading
//                                 ? null
//                                 : () {
//                                     final params = UpdateWorkingTimeParams(
//                                       isTemporarilyClosed: tempClosed,
//                                       dailyHours: days.values.toList(),
//                                     );
//                                     context.read<ProfileBloc>().add(
//                                       UpdateWorkingTimeEvent(params: params),
//                                     );
//                                   },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: isLoading
//                                     ? Colors.grey
//                                     : context.primary,
//                               ),
//                               padding: EdgeInsetsDirectional.symmetric(
//                                 horizontal: 12,
//                                 vertical: 16,
//                               ),
//                               child: isLoading
//                                   ? Center(
//                                       child: SizedBox(
//                                         width: 20,
//                                         height: 20,
//                                         child:
//                                             CircularProgressIndicator.adaptive(
//                                               strokeWidth: 2,
//                                               valueColor:
//                                                   AlwaysStoppedAnimation<Color>(
//                                                     context.onPrimary,
//                                                   ),
//                                             ),
//                                       ),
//                                     )
//                                   : AppText.labelLarge(
//                                       'حفظ التغييرات',
//                                       color: context.onPrimary,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                             ),
//                           ),
//                         ),
//                         SizedBox(width: 8),
//                         Expanded(
//                           flex: 1,
//                           child: GestureDetector(
//                             onTap: isLoading ? null : () => context.pop(),
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.circular(8),
//                                 color: context.error.withAlpha(50),
//                                 border: Border.all(color: context.error),
//                               ),
//                               padding: EdgeInsetsDirectional.symmetric(
//                                 horizontal: 6,
//                                 vertical: 16,
//                               ),
//                               child: AppText.labelLarge(
//                                 'إلغاء',
//                                 color: context.error,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               ),
//               SizedBox(height: 10),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
