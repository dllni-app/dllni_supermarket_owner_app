import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import 'order_card.dart';
import 'orders_tab_bar.dart';

class OrdersBody extends StatelessWidget {
  const OrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 8),
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 20),
        //   child: WarningAlert(
        //     icon: FontAwesomeIcons.clock,
        //     title: "طلب متأخر #2475",
        //     description: "تجاوز الوقت المحدد بـ 5 دقائق.",
        //     labelButton: "عرض",
        //   ),
        // ),
        OrdersTabBar(
          items: [
            OrdersTabBarItem(title: "الكل", count: 48),
            OrdersTabBarItem(
              title: "طلب جديد",
              count: 2,
              leadingColor: AppColors.primary,
            ),
            OrdersTabBarItem(
              title: "قيد التحضير",
              count: 7,
              leadingColor: AppColors.accent,
            ),
            OrdersTabBarItem(
              title: "جاهز للتسليم",
              count: 3,
              leadingColor: Color(0xFF24B364),
            ),
            OrdersTabBarItem(
              title: "مكتمل",
              count: 5,
              leadingColor: Color(0xFF24B364),
            ),
          ],
          onChanged: (index) {
            print(index);
          },
        ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            itemBuilder: (_, index) => [
              OrderCard(status: OrderStatus.pending),
              OrderCard(status: OrderStatus.pending),
              OrderCard(status: OrderStatus.preparing),
              OrderCard(status: OrderStatus.readyForPickup),
              OrderCard(status: OrderStatus.completed),
            ][index],
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
