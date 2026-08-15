import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/fetch_notifications_model.dart';
import '../../domain/usecases/fetch_notifications_use_case.dart';
import '../manager/bloc/home_bloc.dart';

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

@AutoRoutePage(path: '/notification_screen')
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _confirmDeleteAll(BuildContext context) async {
    final bloc = context.read<HomeBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('حذف الكل'),
        content: const Text('هل أنت متأكد من حذف جميع الإشعارات؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      bloc.add(DeleteAllNotificationsEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeBloc>()
        ..add(FetchNotificationsEvent(params: FetchNotificationsParams(), isReload: true)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        body: Column(
          children: [
            const AppSimpleAppBar(title: 'الإشعارات'),
            BlocBuilder<HomeBloc, HomeState>(
              builder: (context, state) {
                if (state.notifications?.list.isEmpty != false) {
                  return const SizedBox.shrink();
                }
                return Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 16, 0),
                    child: TextButton.icon(
                      onPressed: () => _confirmDeleteAll(context),
                      icon: const Icon(Icons.delete_outline, color: Color(0xFFEF4444)),
                      label: const Text(
                        'حذف الكل',
                        style: TextStyle(color: Color(0xFFEF4444)),
                      ),
                    ),
                  ),
                );
              },
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  return state.notifications!.builder(
                    loadingWidget: Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                    emptyWidget: AppText.labelMedium(
                      'لا توجد إشعارات حاليا',
                      fontWeight: FontWeight.w400,
                    ),
                    successWidget: () {
                      return ListView.separated(
                        padding: const EdgeInsetsDirectional.symmetric(horizontal: 24, vertical: 16),
                        itemBuilder: (context, index) {
                          if (state.notifications!.length <= index) {
                            if (state.notifications!.length == index) {
                              context.read<HomeBloc>().add(
                                FetchNotificationsEvent(
                                  isReload: false,
                                  params: FetchNotificationsParams(page: state.notifications!.pageNumber),
                                ),
                              );
                            }
                            return const SizedBox(
                              width: 30,
                              height: 30,
                              child: FittedBox(
                                child: CircularProgressIndicator.adaptive(strokeWidth: 3),
                              ),
                            );
                          }

                          final notification = state.notifications!.list[index];
                          return Dismissible(
                            key: ValueKey(notification.id ?? '${notification.createdAt}-$index'),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: AlignmentDirectional.centerEnd,
                              color: const Color(0xFFEF4444),
                              padding: const EdgeInsetsDirectional.only(end: 20),
                              child: const Icon(Icons.delete_outline, color: Colors.white),
                            ),
                            onDismissed: (_) {
                              final id = notification.id;
                              if (id != null && id.isNotEmpty) {
                                context.read<HomeBloc>().add(DeleteNotificationEvent(id: id));
                              }
                            },
                            child: _NotificationCard(
                              item: _toItem(notification),
                              onTap: () {
                                final id = notification.id;
                                if (id != null && id.isNotEmpty && notification.readAt == null) {
                                  context.read<HomeBloc>().add(MakeReadNotificationEvent(id: id));
                                }
                              },
                            ),
                          );
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: state.notifications!.listLength(1),
                      );
                    },
                    failedWidget: Center(
                      child: FailureWidget(
                        message: state.errorMessage.toString(),
                        onRetry: () {
                          context.read<HomeBloc>().add(
                            FetchNotificationsEvent(params: FetchNotificationsParams(), isReload: true),
                          );
                        },
                      ),
                    ),
                    onTapRetry: () {
                      context.read<HomeBloc>().add(
                        FetchNotificationsEvent(params: FetchNotificationsParams(), isReload: true),
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

  NotificationItem _toItem(FetchNotificationsModelDataItem item) {
    final isOrder = item.type == 'order' || (item.type ?? '').contains('order');
    return NotificationItem(
      title: item.title ?? '-',
      body: item.body ?? '-',
      time: (item.createdAt ?? '').split('T').first,
      tag: isOrder ? 'طلب' : 'إشعار',
      themeColor: isOrder ? Colors.teal : Colors.orange,
      icon: item.icon ?? '',
      isNew: item.readAt == null,
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onTap;

  const _NotificationCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 16),
          decoration: const BoxDecoration(
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
                          borderRadius: const BorderRadius.all(Radius.circular(12)),
                        ),
                        child: item.icon.isEmpty
                            ? Icon(Icons.notifications_none, color: item.themeColor)
                            : AppImage.network(
                                item.icon,
                                size: 18,
                                errorWidget: Icon(Icons.notifications_none, color: item.themeColor),
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
                            color: const Color(0xFFEF4444),
                            border: Border.all(color: AppColors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: AppText(
                            item.title,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                              color: Color(0xFF111827),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.42,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        AppText(
                          item.time,
                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12, height: 1.333),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppText(
                      item.body,
                      textAlign: TextAlign.start,
                      style: const TextStyle(color: Color(0xFF4B5563), fontSize: 14, height: 1.42),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.themeColor.withValues(alpha: 0.1),
                        borderRadius: const BorderRadius.all(Radius.circular(8)),
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
        ),
      ),
    );
  }
}
