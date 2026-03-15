import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_daily_count_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_new_orders_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../domain/usecases/get_dashboard_overview_use_case.dart';
import '../manager/bloc/home_bloc.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/new_orders_section.dart';
import '../widgets/orders_chart.dart';
import '../widgets/overview_section.dart';
import '../widgets/quick_actions_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()
        ..add(GetDashboardOverviewEvent(params: GetDashboardOverviewParams()))
        ..add(GetNewOrdersEvent(params: GetNewOrdersParams()))
        ..add(GetDailyCountEvent(params: GetDailyCountParams())),
      // ..add(GetPreparingOrdersEvent(params: GetPreparingOrdersParams()))
      child: const Scaffold(
        backgroundColor: Color(0xFFF6F7FB),
        body: Column(
          children: [
            HomeAppBar(
              shopName: 'مطعم البيت الحلبي',
              shopAddress: "الفرع الرئيسي - العزيزية",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    OverviewSection(
                      showQuickPoints: false,
                    ),
                    SizedBox(height: 20),
                    OrdersChartCard(),
                    SizedBox(height: 34),
                    QuickActionsSection(),
                    SizedBox(height: 14),
                    NewOrdersSection(),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
