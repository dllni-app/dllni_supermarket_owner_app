import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home_screen.dart';
import '../../home_screen_helpers.dart';
import '../../manager/bloc/home_bloc.dart';
import '../models/home_models.dart';
import '../sheets/reject_order_sheet.dart';
import 'low_stock_alert_card.dart';
import 'new_orders_section.dart';
import 'orders_activity_section.dart';
import 'overview_section.dart';
import 'preparing_orders_section.dart';
import 'quick_actions_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final dateLabel = todayLabel();
    final activity = const [
      ActivityPoint(hour: "10", value: 23),
      ActivityPoint(hour: "11", value: 11),
      ActivityPoint(hour: "12", value: 43),
      ActivityPoint(hour: "13", value: 37),
      ActivityPoint(hour: "14", value: 16),
      ActivityPoint(hour: "15", value: 26),
    ];
    return BlocConsumer<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state.actionStatus == BlocStatus.success &&
            state.actionMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionMessage)));
        } else if (state.actionStatus == BlocStatus.failed &&
            state.actionMessage.isNotEmpty) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.actionMessage)));
        }
      },
      builder: (context, state) {
        final vm = HomeViewModel.fromState(state);
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 16),
              // vm.lowStockProduct != null
              //     ? LowStockAlertCard(
              //         refreshAlert: () {},
              //         productName: vm.lowStockProduct!.productName ?? "",
              //         remaining: vm.lowStockProduct!.currentStock ?? 0,
              //       )
              //     :
              const NoLowStockCard(),
              SizedBox(height: 20),
              OverviewSection(
                stats: vm.stats,
                dateLabel: dateLabel,
                totalSales: vm.totalSales,
              ),
              SizedBox(height: 20),
              const QuickActionsSection(actions: quickActions),
              SizedBox(height: 20),
              NewOrdersSection(
                orders: vm.newOrders,
                onAccept: (orderId) {
                  if (orderId == null) return;
                  context.read<HomeBloc>().add(
                    HomeAcceptOrderEvent(orderId: orderId),
                  );
                },
                onReject: (orderId) {
                  if (orderId == null) return;
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (_) {
                      return RejectOrderSheet(orderId: orderId);
                    },
                  );
                },
              ),
              SizedBox(height: 20),
              PreparingOrdersSection(orders: vm.preparingOrders),
              SizedBox(height: 20),
              OrdersActivitySection(activity: activity),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
