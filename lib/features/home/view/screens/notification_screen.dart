// --- 1. The Data Model (Pro Tip: Always separate data from UI) ---
import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/fetch_notifications_use_case.dart';
import '../../domain/usecases/make_read_all_notifications_use_case.dart';
import '../manager/bloc/home_bloc.dart';
import '../widgets/notification_tab_bar.dart';

class NotificationItem {
  final String title;
  final String body;
  final String time;
  final String tag;
  final Color themeColor;
  final String icon;
  final bool isNew;

  NotificationItem({
    required this.title,
    required this.body,
    required this.time,
    required this.tag,
    required this.themeColor,
    required this.icon,
    this.isNew = false,
  });
}

@AutoRoutePage(path: "/notification_screen")
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<NotificationItem> notifications = [
      NotificationItem(
        title: "طلب جديد #4521",
        body: "تم استلام طلب جديد بقيمة 285 ليرة سورية - يحتاج للتأكيد",
        time: "منذ دقيقتين",
        tag: "طلب جديد",
        themeColor: Colors.teal,
        icon: "Icons.receipt_long",
        isNew: true,
      ),
      NotificationItem(
        title: "عرض \"خصم 25%\" قارب على الانتهاء",
        body: "عرضك ينتهي بعد 3 أيام - تم استخدامه 142 مرة",
        time: "منذ ساعة",
        tag: "تنبيه عرض",
        themeColor: Colors.orange,
        icon: "Icons.local_offer",
      ),
      NotificationItem(
        title: "تم تسليم الطلب #4518",
        body: "تم تسليم الطلب بنجاح للعميل محمد السالم",
        time: "منذ ساعتين",
        tag: "طلب مكتمل",
        themeColor: Colors.green,
        icon: "Icons.check_circle",
      ),
    ];

    return BlocProvider(
      create: (context) => getIt<HomeBloc>()
        ..add(FetchNotificationsEvent(params: FetchNotificationsParams()))
        ..add(
          MakeReadAllNotificationsEvent(
            params: MakeReadAllNotificationsParams(),
          ),
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        body: Column(
          children: [
            AppSimpleAppBar(title: "الإشعارات"),
            // NotificationsTabBar(
            //   items: [
            //     NotificationsTabBarItem(title: "الكل", icon: null, count: 24),
            //     NotificationsTabBarItem(
            //       title: "الطلبات",
            //       icon: Icons.receipt_long,
            //       count: 8,
            //     ),
            //     NotificationsTabBarItem(
            //       title: "العروض",
            //       icon: Icons.local_offer,
            //       count: 5,
            //     ),
            //     NotificationsTabBarItem(
            //       title: "التحديثات",
            //       icon: Icons.update,
            //       count: 11,
            //     ),
            //   ],
            //   onChanged: (index) {},
            // ),
            // SizedBox(height: 16),
            // BlocBuilder<HomeBloc, HomeState>(
            //   buildWhen: (previous, current) =>
            //       previous.notifications?.status !=
            //       current.notifications?.status,
            //   builder: (context, state) {
            //     return Expanded(
            //       child: ListView.builder(
            //         padding: const EdgeInsets.symmetric(
            //           horizontal: 9,
            //           vertical: 14,
            //         ),
            //         itemCount: notifications.length,
            //         itemBuilder: (context, index) {
            //           return _NotificationCard(item: notifications[index]);
            //         },
            //       ),
            //     );
            //   },
            // ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) =>
                    previous.notifications?.status !=
                    current.notifications?.status,
                builder: (context, state) {
                  return state.notifications!.builder(
                    loadingWidget: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                    emptyWidget: AppText.labelMedium(
                      'لا يوجد منتجات',
                      fontWeight: FontWeight.w400,
                    ),
                    successWidget: () {
                      return ListView.separated(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        itemBuilder: (context, index) {
                          if (state.notifications!.length <= index) {
                            if (state.notifications!.length == index) {
                              context.read<HomeBloc>().add(
                                FetchNotificationsEvent(
                                  isReload: false,
                                  params: FetchNotificationsParams(
                                    page: state.notifications!.pageNumber,
                                  ),
                                ),
                              );
                            }
                            return SizedBox(
                              width: 30,
                              height: 30,
                              child: FittedBox(
                                child: CircularProgressIndicator.adaptive(
                                  strokeWidth: 3,
                                ),
                              ),
                            );
                          }
                          return _NotificationCard(
                            item: NotificationItem(
                              title: state.notifications!.list[index].title
                                  .toString(),
                              body: state.notifications!.list[index].body
                                  .toString(),
                              time: state.notifications!.list[index].createdAt
                                  .toString()
                                  .split("T")
                                  .firstOrNull
                                  .toString(),
                              tag:
                                  state.notifications!.list[index].type ==
                                      "order"
                                  ? "طلب"
                                  : "عرض",
                              themeColor:
                                  state.notifications!.list[index].type ==
                                      "order"
                                  ? Colors.teal
                                  : Colors.orange,
                              icon: state.notifications!.list[index].icon
                                  .toString(),
                              isNew:
                                  state.notifications!.list[index].readAt ==
                                  null,
                            ),
                          );
                        },
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 16),
                        itemCount: state.notifications!.listLength(1),
                      );
                    },
                    failedWidget: Center(
                      child: FailureWidget(
                        message: state.errorMessage.toString(),
                        onRetry: () {
                          context.read<HomeBloc>().add(
                            FetchNotificationsEvent(
                              params: FetchNotificationsParams(),
                              isReload: true,
                            ),
                          );
                        },
                      ),
                    ),
                    onTapRetry: () {
                      context.read<HomeBloc>().add(
                        FetchNotificationsEvent(
                          params: FetchNotificationsParams(),
                          isReload: true,
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;

  const _NotificationCard({required this.item});
  @override
  Widget build(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 12, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            height: 52,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: item.themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: AppImage.network(
                      item.icon,
                      size: 18,
                      errorWidget: Icon(Icons.error, color: item.themeColor),
                    ),
                  ),
                ),
                if (item.isNew)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEF4444),
                        border: Border.all(color: AppColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppText(
                        item.title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    AppText(
                      item.time,
                      style: TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 12,
                        height: 1.333,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4),
                AppText(
                  item.body,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 14,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: item.themeColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: AppText(
                    item.tag,
                    style: TextStyle(
                      color: item.themeColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.333,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
