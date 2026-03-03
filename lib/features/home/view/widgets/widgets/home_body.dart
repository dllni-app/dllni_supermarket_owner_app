import 'package:dllni_supermarket_owner_app/core/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/widgets/warning_alert.dart';
import '../../home_screen.dart';
import '../../manager/bloc/home_bloc.dart';
import '../models/home_models.dart';
import '../sheets/reject_order_sheet.dart';
import 'new_orders_section.dart';
import 'orders_hour_statistics_card.dart';
import 'overview_section.dart';
import 'preparing_orders_section.dart';
import 'quick_actions_section.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final activity = const [
      ActivityPoint(hour: "10", value: 23),
      ActivityPoint(hour: "11", value: 11),
      ActivityPoint(hour: "12", value: 43),
      ActivityPoint(hour: "13", value: 37),
      ActivityPoint(hour: "14", value: 16),
      ActivityPoint(hour: "15", value: 26),
    ];
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        spacing: 24,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(),
          WarningAlert(
            title: "تنبيه مخزون منخفض",
            description: "مادة \"أرز بسمتي\" قاربت على النفاد (أقل من 5 كجم).",
            icon: Icons.warning_rounded,
            labelButton: "تحديث",
            onTapButton: () {
              print("refresh");
            },
          ),
          OverviewSection(
            stats: const [
              OverviewStatData(
                label: "label",
                value: "value",
                icon: Icons.home,
                color: Color(0xFFFF0000),
                background: Color(0xFFA00000),
              ),
              OverviewStatData(
                label: "label",
                value: "value",
                icon: Icons.home,
                color: Color(0xFFFF0000),
                background: Color(0xFFA00000),
              ),
              OverviewStatData(
                label: "label",
                value: "value",
                icon: Icons.home,
                color: Color(0xFFFF0000),
                background: Color(0xFFA00000),
              ),
              // OverviewStatData(
              //   background:
              // )
            ],
            dateLabel: DateTime.now().format,
            totalSales: 12450,
          ),

          const QuickActionsSection(actions: quickActions),
          const NewOrdersSection(),
          const PreparingOrdersSection(
            orders: [PreparingOrderData(id: "id", minutesSince: 4)],
          ),
          const OrdersHourStatisticsCard(
            hours: [10, 11, 12, 13, 14, 15],
            values: [23, 11, 43, 37, 16, 26],
          ),
          const SizedBox(),
        ],
      ),
    );
  }
}
