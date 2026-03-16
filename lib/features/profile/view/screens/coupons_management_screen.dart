import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/profile/data/models/get_coupon_codes_model.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_coupon_codes_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../manager/bloc/profile_bloc.dart';
import '../widgets/coupon_card.dart';
import '../widgets/coupon_statistics_grid.dart';
import '../widgets/coupons_filter_card.dart';

@AutoRoutePage(path: "/coupons_management")
class CouponsManagementScreen extends StatefulWidget {
  const CouponsManagementScreen({super.key});

  @override
  State<CouponsManagementScreen> createState() =>
      _CouponsManagementScreenState();
}

class _CouponsManagementScreenState extends State<CouponsManagementScreen> {
  String search = "";
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>()
          ..add(GetCouponCodesEvent(params: GetCouponCodesParams(storeId: 1))),
        child: Column(
          children: [
            AppSimpleAppBar(title: "الكوبونات"),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
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
            ),
            SizedBox(height: 16),
            CouponsStatistics(),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                return CouponsFilterCard(
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
              child: BlocBuilder<ProfileBloc, ProfileState>(
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
                          return CouponCard(coupon: state.couponCodes![index]);
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
                                  0)
                            return SizedBox();
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
