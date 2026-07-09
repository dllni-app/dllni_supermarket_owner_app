import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/di/injection.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/profile/data/models/get_activity_logs_model.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_activity_logs_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/manager/bloc/profile_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_app_bars.dart';

String? _logNameForCategory(EmployeeActivityCategory c) {
  switch (c) {
    case EmployeeActivityCategory.all:
      return null;
    case EmployeeActivityCategory.orders:
      return 'orders';
    case EmployeeActivityCategory.products:
      return 'products';
    case EmployeeActivityCategory.inventory:
      return 'inventory';
    case EmployeeActivityCategory.offers:
      return 'offers';
    case EmployeeActivityCategory.system:
      return 'system';
  }
}

String _relativeTimeAr(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return '';
  final parsed = DateTime.tryParse(createdAt);
  if (parsed == null) return createdAt;
  final diff = DateTime.now().difference(parsed);
  if (diff.inDays != 0) return 'منذ ${diff.inDays} يوم';
  if (diff.inHours != 0) return 'منذ ${diff.inHours} ساعة';
  if (diff.inMinutes != 0) return 'منذ ${diff.inMinutes} دقيقة';
  return 'منذ ${diff.inSeconds} ثانية';
}

String _tagLabelForItem(GetActivityLogsModelDataItem item) {
  final ev = item.event?.trim();
  if (ev != null && ev.isNotEmpty) {
    return ev;
  }
  return _tagLabelForLogName(item.logName);
}

String _tagLabelForLogName(String? logName) {
  switch (logName) {
    case 'orders':
      return 'طلبات';
    case 'products':
      return 'منتجات';
    case 'inventory':
      return 'مخزون';
    case 'offers':
      return 'عروض';
    case 'system':
      return 'نظام';
    default:
      return logName ?? 'نشاط';
  }
}

String _totalsMapKey(EmployeeActivityCategory c) =>
    _logNameForCategory(c) ?? '';

enum EmployeeActivityCategory {
  all,
  orders,
  products,
  inventory,
  offers,
  system,
}

@AutoRoutePage(path: '/profile/employees/activity_log')
class EmployeeActivityLogScreen extends StatefulWidget {
  const EmployeeActivityLogScreen({super.key});

  @override
  State<EmployeeActivityLogScreen> createState() =>
      _EmployeeActivityLogScreenState();
}

class _ActivityApiTile extends StatelessWidget {
  final GetActivityLogsModelDataItem item;
  const _ActivityApiTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final name = item.causer?.name?.trim();

    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: const Color(0xFFF3F4F6))),
        color: AppColors.white,
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12,
        children: [
          AppImage.network(
            item.causer?.avatarUrl ?? '',
            size: 46,
            borderRadius: BorderRadius.circular(100),
            errorWidget: Icon(Icons.error_outline, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 4,
              children: [
                AppText(
                  (name != null && name.isNotEmpty) ? name : '—',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: Color(0xFF111827),
                    height: 20 / 14,
                  ),
                ),
                AppText(
                  item.description?.trim().isNotEmpty == true
                      ? item.description!.trim()
                      : (item.event ?? ''),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    height: 20 / 14,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0x1A10B981),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: AppText(
                    _tagLabelForItem(item),
                    style: const TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 16 / 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppText(
            _relativeTimeAr(item.createdAt),
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 16 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityFilterDef {
  final EmployeeActivityCategory category;

  final String label;
  final IconData? icon;
  const _ActivityFilterDef({
    required this.category,
    required this.label,
    required this.icon,
  });
}

class _EmployeeActivityLogScreenState extends State<EmployeeActivityLogScreen> {
  static final List<_ActivityFilterDef> _filterDefs = [
    _ActivityFilterDef(
      category: EmployeeActivityCategory.all,
      label: 'الكل',
      icon: null,
    ),
    _ActivityFilterDef(
      category: EmployeeActivityCategory.orders,
      label: 'طلبات',
      icon: FontAwesomeIcons.receipt.data,
    ),
    _ActivityFilterDef(
      category: EmployeeActivityCategory.products,
      label: 'منتجات',
      icon: FontAwesomeIcons.cubes.data,
    ),
    _ActivityFilterDef(
      category: EmployeeActivityCategory.inventory,
      label: 'مخزون',
      icon: FontAwesomeIcons.boxesStacked.data,
    ),
    _ActivityFilterDef(
      category: EmployeeActivityCategory.offers,
      label: 'عروض',
      icon: FontAwesomeIcons.tags.data,
    ),
    _ActivityFilterDef(
      category: EmployeeActivityCategory.system,
      label: 'نظام',
      icon: FontAwesomeIcons.gear.data,
    ),
  ];

  EmployeeActivityCategory _selected = EmployeeActivityCategory.all;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileBloc>()
        ..add(
          GetActivityLogsEvent(
            params: GetActivityLogsParams(
              logName: _logNameForCategory(_selected),
            ),
          ),
        ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F5F5),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const AppSimpleAppBar(title: 'سجل نشاط الموظفين'),
            const SizedBox(height: 16),
            BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (p, c) =>
                  p.activityLogTotalsByFilter != c.activityLogTotalsByFilter ||
                  p.activityLogs != c.activityLogs,
              builder: (context, state) {
                return SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _filterDefs.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final def = _filterDefs[index];
                      final selected = def.category == _selected;
                      final count =
                          state.activityLogTotalsByFilter[_totalsMapKey(
                            def.category,
                          )];
                      final countStr = count != null ? ' $count' : '';
                      return _FilterChip(
                        label: def.label,
                        countSuffix: countStr,
                        icon: def.icon,
                        selected: selected,
                        onTap: () => _reloadForFilter(context, def.category),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (p, c) => p.activityLogs != c.activityLogs,
                builder: (context, state) {
                  return state.activityLogs!.builder(
                    loadingWidget: const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    emptyWidget: Center(
                      child: AppText(
                        'لا يوجد نشاط في هذا التصنيف',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    onTapRetry: () {
                      context.read<ProfileBloc>().add(
                        GetActivityLogsEvent(
                          isReload: true,
                          params: GetActivityLogsParams(
                            logName: _logNameForCategory(_selected),
                          ),
                        ),
                      );
                    },
                    successWidget: () {
                      return ListView.separated(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 24),
                        itemCount: state.activityLogs!.listLength(1),
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.grey.shade200,
                        ),
                        itemBuilder: (context, index) {
                          if (state.activityLogs!.length <= index) {
                            if (state.activityLogs!.length == index) {
                              context.read<ProfileBloc>().add(
                                GetActivityLogsEvent(
                                  params: GetActivityLogsParams(
                                    page: state.activityLogs!.pageNumber,
                                    logName: _logNameForCategory(_selected),
                                  ),
                                ),
                              );
                            }
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Shimmer.fromColors(
                                baseColor: const Color(0xFFE0E0E0),
                                highlightColor: const Color(0xFFCCCCCC),
                                child: Container(
                                  height: 72,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            );
                          }
                          return _ActivityApiTile(
                            item: state.activityLogs![index],
                          );
                        },
                      );
                    },
                    failedWidget: FailureWidget(
                      message:
                          state.activityLogs?.errorMessage ??
                          state.errorMessage ??
                          'Unknown Error',
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          GetActivityLogsEvent(
                            isReload: true,
                            params: GetActivityLogsParams(
                              logName: _logNameForCategory(_selected),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reloadForFilter(BuildContext context, EmployeeActivityCategory c) {
    setState(() => _selected = c);
    context.read<ProfileBloc>().add(
      GetActivityLogsEvent(
        isReload: true,
        params: GetActivityLogsParams(logName: _logNameForCategory(c)),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final String countSuffix;
  final IconData? icon;
  final bool selected;

  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.countSuffix,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? Color(0xFF064E3B) : Color(0xFFF3F4F6),
      borderRadius: BorderRadius.circular(100),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 40,
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            spacing: 8,
            children: [
              if (icon != null)
                Icon(
                  icon,
                  size: 14,
                  color: selected ? Colors.white : const Color(0xFF6B7280),
                ),
              AppText(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF374151),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  height: 20 / 14,
                ),
              ),
              if (countSuffix.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0x80FFFFFF),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: AppText(
                    countSuffix,
                    style: TextStyle(
                      color: selected ? Colors.white : const Color(0xFF374151),
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      height: 20 / 14,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
