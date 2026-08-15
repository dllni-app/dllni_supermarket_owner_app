import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_daily_count_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_new_orders_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/helpers/seller_permission_access.dart';
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
    final access = SellerPermissionAccess.current();
    final canManageOrders = access.can(SupermarketPermissionCodes.orders);
    final canManageProducts = access.can(SupermarketPermissionCodes.products);

    return BlocProvider(
      create: (context) {
        final bloc = getIt<HomeBloc>()
          ..add(
            GetDashboardOverviewEvent(params: GetDashboardOverviewParams()),
          );

        if (canManageOrders) {
          bloc
            ..add(GetNewOrdersEvent(params: GetNewOrdersParams()))
            ..add(GetDailyCountEvent(params: GetDailyCountParams()));
        }

        return bloc;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: Builder(
                builder: (context) => RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<HomeBloc>()
                      ..add(
                        GetDashboardOverviewEvent(
                          params: GetDashboardOverviewParams(),
                        ),
                      );

                    if (canManageOrders) {
                      bloc
                        ..add(GetNewOrdersEvent(
                          params: GetNewOrdersParams(),
                          isReload: true,
                        ))
                        ..add(GetDailyCountEvent(
                          params: GetDailyCountParams(),
                        ));
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        const OverviewSection(showQuickPoints: false),
                        if (canManageOrders) ...[
                          const SizedBox(height: 20),
                          const OrdersChartCard(),
                        ],
                        if (canManageProducts) ...[
                          const SizedBox(height: 34),
                          const QuickActionsSection(),
                        ],
                        if (canManageOrders) ...[
                          const SizedBox(height: 14),
                          const NewOrdersSection(),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
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
