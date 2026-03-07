import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/date_time_extensions.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_dashboard_overview_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_gradients.dart';
import '../../../../../core/themes/app_shadows.dart';
import '../../../../../core/utils/app_images.dart';
import '../../../../../core/widgets/failure_widget.dart';
import '../manager/bloc/home_bloc.dart';
import 'loadings/overview_section_loading.dart';
import 'overview_state_card.dart';
import 'selling_indicator.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 12,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(
              "نظرة عامة اليوم",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
                height: 1.5,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: Color(0xFFF3F4F6)),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                boxShadow: [AppShadows.shadow],
              ),
              child: Text(
                DateTime.now().format,
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF9CA3AF),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        BlocBuilder<HomeBloc, HomeState>(
          buildWhen: (previous, current) =>
              previous.dashboardOverviewStatus !=
              current.dashboardOverviewStatus,
          builder: (context, state) {
            return switch (state.dashboardOverviewStatus) {
              BlocStatus.loading => OverviewSectionLoading(),
              BlocStatus.failed => FailureWidget(
                message: state.errorMessage ?? "Unknown Error",
                onRetry: () {
                  context.read<HomeBloc>().add(
                    GetDashboardOverviewEvent(
                      params: GetDashboardOverviewParams(),
                    ),
                  );
                },
              ),
              BlocStatus.success => Column(
                spacing: 12,
                children: [
                  Container(
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppGradients.gradient,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0x33EAB308)),
                      boxShadow: [
                        BoxShadow(
                          offset: const Offset(0, 8),
                          blurRadius: 32,
                          color: const Color(0x33000000),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            spacing: 4,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                "إجمالي المبيعات",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFFFFEEFF),
                                  height: 1.333,
                                ),
                              ),
                              Row(
                                children: [
                                  AppText(
                                    state.dashboardOverview?.data?.totalSales
                                            ?.formatWithComma() ??
                                        "-1",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.75,
                                      height: 1.2,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  AppText(
                                    "ل.س",
                                    style: TextStyle(
                                      color: Color(0xFFFACC15),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      height: 1.33,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                spacing: 8,
                                children: [
                                  SellingIndicator(percent: 15),
                                  AppText(
                                    "مقارنة بالأمس",
                                    style: TextStyle(
                                      color: const Color(0x7FFFEEFF),
                                      fontSize: 12,
                                      height: 1.333,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AppImage.asset(AppImages.databases, size: 60),
                      ],
                    ),
                  ),
                  Row(
                    spacing: 12,
                    children: [
                      Expanded(
                        child: OverviewStatCard(
                          backgroundColor: const Color(0x333B82F6),
                          foregroundColor: const Color(0xFF60A5FA),
                          icon: FontAwesomeIcons.receipt,
                          label: "طلبات جديدة",
                          value: state.dashboardOverview?.data?.newOrders ?? -1,
                        ),
                      ),
                      Expanded(
                        child: OverviewStatCard(
                          backgroundColor: const Color(0x33F97316),
                          foregroundColor: const Color(0xFFFB923C),
                          icon: FontAwesomeIcons.fireBurner,
                          label: "قيد التحضير",
                          value:
                              state.dashboardOverview?.data?.pendingOrders ?? -1,
                        ),
                      ),
                      Expanded(
                        child: OverviewStatCard(
                          backgroundColor: const Color(0x3322C55E),
                          foregroundColor: const Color(0xFF4ADE80),
                          icon: FontAwesomeIcons.checkDouble,
                          label: "مكتمل",
                          value:
                              state.dashboardOverview?.data?.completedOrders ??
                              -1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              _ => SizedBox(),
            };
          },
        ),
      ],
    );
  }
}
