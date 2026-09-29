import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';
import 'package:common_package/helpers/dio_network.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/store_owner_operations_service.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/get_coupon_codes_model.dart';
import '../../domain/usecases/get_coupon_codes_use_case.dart';
import '../../domain/usecases/get_coupon_week_analysis_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import '../widgets/coupon_card.dart';
import '../widgets/promotion_edit_dialogs.dart';
import '../widgets/coupon_statistics.dart';
import '../widgets/coupons_filter_card.dart';
import 'create_coupon_screen.dart';

@AutoRoutePage(path: "/coupons_management")
class CouponsManagementScreen extends StatefulWidget {
  const CouponsManagementScreen({super.key});

  @override
  State<CouponsManagementScreen> createState() =>
      _CouponsManagementScreenState();
}

class _CouponsManagementScreenState extends State<CouponsManagementScreen> {
  String search = "";
  String? sort;
  int selectedTab = 0;

  StoreOwnerOperationsService get _operations =>
      StoreOwnerOperationsService(getIt<DioNetwork>());

  void _reloadCoupons(BuildContext context) {
    context.read<ProfileBloc>().add(
      GetCouponCodesEvent(
        isReload: true,
        params: GetCouponCodesParams(
          storeId: 1,
          search: search,
          sort: sort,
          isActive: selectedTab == 1
              ? true
              : selectedTab == 2
              ? false
              : null,
        ),
      ),
    );
    context.read<ProfileBloc>().add(
      GetCouponWeekAnalysisEvent(
        params: GetCouponWeekAnalysisParams(storeId: 1),
      ),
    );
  }

  Future<void> _editCoupon(
    BuildContext context,
    GetCouponCodesModelDataItem coupon,
  ) async {
    final id = coupon.id;
    if (id == null) return;
    final body = await showCouponEditDialog(context, coupon);
    if (body == null || !context.mounted) return;
    await _runCouponAction(
      context,
      () => _operations.updateCoupon(couponId: id, body: body),
      'تم تحديث الكوبون',
    );
  }

  Future<void> _toggleCoupon(
    BuildContext context,
    GetCouponCodesModelDataItem coupon,
  ) async {
    final id = coupon.id;
    if (id == null) return;
    final active = !(coupon.isActive ?? false);
    await _runCouponAction(
      context,
      () => _operations.updateCoupon(
        couponId: id,
        body: {'isActive': active},
      ),
      active ? 'تم تفعيل الكوبون' : 'تم تعطيل الكوبون',
    );
  }

  Future<void> _deleteCoupon(
    BuildContext context,
    GetCouponCodesModelDataItem coupon,
  ) async {
    final id = coupon.id;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: const Text('حذف الكوبون'),
            content: Text(
              'هل تريد حذف الكوبون «${coupon.code ?? ''}» نهائيًا؟',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('حذف'),
              ),
            ],
          ),
        ) ??
        false;
    if (!confirmed || !context.mounted) return;
    await _runCouponAction(
      context,
      () => _operations.deleteCoupon(id),
      'تم حذف الكوبون',
    );
  }

  Future<void> _runCouponAction(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action,
    String successMessage,
  ) async {
    try {
      await action();
      if (!context.mounted) return;
      AppToast.showToast(
        context: context,
        message: successMessage,
        type: ToastificationType.success,
      );
      _reloadCoupons(context);
    } on StoreOwnerOperationException catch (error) {
      if (!context.mounted) return;
      AppToast.showToast(
        context: context,
        message: error.message,
        type: ToastificationType.error,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>()
          ..add(GetCouponCodesEvent(params: GetCouponCodesParams(storeId: 1)))
          ..add(
            GetCouponWeekAnalysisEvent(
              params: GetCouponWeekAnalysisParams(storeId: 1),
            ),
          ),
        child: Column(
          children: [
            AppSimpleAppBar(title: "الكوبونات"),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: Builder(
                builder: (context) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: CreateCouponScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.primaryContainer,
                      ),
                      width: context.width,
                      padding: EdgeInsetsDirectional.symmetric(vertical: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: context.onPrimaryContainer,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          AppText.labelLarge(
                            'إنشاء كوبون جديد',
                            color: context.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            CouponsStatistics(),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                return CouponsFilterCard(
                  onSortChanged: (sort) {
                    this.sort = sort;
                    context.read<ProfileBloc>().add(
                      GetCouponCodesEvent(
                        isReload: true,
                        params: GetCouponCodesParams(
                          storeId: 1,
                          search: search,
                          sort: sort,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                  onSearchChanged: (value) {
                    search = value;
                    context.read<ProfileBloc>().add(
                      GetCouponCodesEvent(
                        isReload: true,
                        params: GetCouponCodesParams(
                          storeId: 1,
                          search: search,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                  onTabChanged: (index) {
                    selectedTab = index;
                    context.read<ProfileBloc>().add(
                      GetCouponCodesEvent(
                        isReload: true,
                        params: GetCouponCodesParams(
                          storeId: 1,
                          search: search,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocConsumer<ProfileBloc, ProfileState>(
                listenWhen: (previous, current) =>
                    previous.addCouponCodeStatus != current.addCouponCodeStatus,
                listener: (context, state) {
                  if (state.addCouponCodeStatus == BlocStatus.success) {
                    context.read<ProfileBloc>().add(
                      GetCouponCodesEvent(
                        isReload: true,
                        params: GetCouponCodesParams(
                          storeId: 1,
                          search: search,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  }
                },
                buildWhen: (previous, current) =>
                    previous.couponCodes != current.couponCodes,
                builder: (context, state) {
                  return state.couponCodes!.builder(
                    loadingWidget: LoadingCouponCards(),
                    emptyWidget: Center(
                      child: AppText.labelMedium(
                        'لا يوجد كوبونات',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    successWidget: () {
                      return ListView.separated(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        itemBuilder: (context, index) {
                          print(state.couponCodes?.length);
                          if (state.couponCodes!.length <= index) {
                            if (state.couponCodes!.length == index) {
                              context.read<ProfileBloc>().add(
                                GetCouponCodesEvent(
                                  params: GetCouponCodesParams(
                                    page: state.couponCodes!.pageNumber,
                                    storeId: 1,
                                    search: search,
                                    isActive: selectedTab == 1
                                        ? true
                                        : selectedTab == 2
                                        ? false
                                        : null,
                                  ),
                                ),
                              );
                            }
                            return Shimmer.fromColors(
                              baseColor: Color(0xFFE0E0E0),
                              highlightColor: Color(0xFFCCCCCC),
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                          // a expired coupon
                          if (selectedTab == 3 &&
                              (DateTime.tryParse(
                                            state.couponCodes![index].endsAt ??
                                                "",
                                          ) ??
                                          DateTime.now())
                                      .difference(DateTime.now())
                                      .inMilliseconds >
                                  0) {
                            return SizedBox();
                          }
                          final coupon = state.couponCodes![index];
                          return CouponCard(
                            coupon: coupon,
                            onEdit: () => _editCoupon(context, coupon),
                            onToggle: () => _toggleCoupon(context, coupon),
                            onDelete: () => _deleteCoupon(context, coupon),
                          );
                        },
                        separatorBuilder: (context, index) {
                          // a expired coupon
                          if (selectedTab == 3 &&
                              (DateTime.tryParse(
                                            state.couponCodes![index].endsAt ??
                                                "",
                                          ) ??
                                          DateTime.now())
                                      .difference(DateTime.now())
                                      .inMilliseconds >
                                  0) {
                            return SizedBox();
                          }
                          return SizedBox(height: 16);
                        },
                        itemCount: state.couponCodes!.listLength(1),
                      );
                    },
                    failedWidget: FailureWidget(
                      message: state.errorMessage ?? "Unknown Error",
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          GetCouponCodesEvent(
                            isReload: true,
                            params: GetCouponCodesParams(
                              page: 1,
                              storeId: 1,
                              search: search,
                              isActive: selectedTab == 1
                                  ? true
                                  : selectedTab == 2
                                  ? false
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    onTapRetry: () {
                      context.read<ProfileBloc>().add(
                        GetCouponCodesEvent(
                          isReload: true,
                          params: GetCouponCodesParams(
                            page: 1,
                            storeId: 1,
                            search: search,
                            isActive: selectedTab == 1
                                ? true
                                : selectedTab == 2
                                ? false
                                : null,
                          ),
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

class LoadingCouponCards extends StatelessWidget {
  const LoadingCouponCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 20),
        itemBuilder: (context, index) => CouponCard(
          coupon: GetCouponCodesModelDataItem.fromJson({
            "id": 1,
            "storeId": 1,
            "code": "ترحيب10-1",
            "type": "percent",
            "value": "25",
            "percent": 10,
            "minOrderAmount": "20.00",
            "maxDiscountAmount": "15.00",
            "usageLimit": 100,
            "usedCount": 0,
            "startsAt": "2026-03-15 12:53:24",
            "endsAt": "2026-06-15 12:53:24",
            "isActive": true,
            "createdAt": "2026-03-15 12:53:24",
            "updatedAt": "2026-03-15 12:53:24",
          }),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: 3,
      ),
    );
  }
}
