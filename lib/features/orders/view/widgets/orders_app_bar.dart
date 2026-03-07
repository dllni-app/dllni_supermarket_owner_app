import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import 'orders_tab_bar.dart';

class OrdersAppBar extends StatelessWidget {
  const OrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width,
      padding: EdgeInsets.only(
        top: 16 + MediaQuery.paddingOf(context).top,
        bottom: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        border: Border(bottom: BorderSide(width: 2, color: AppColors.accent)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 1),
            blurRadius: 2,
            color: Color(0x0D000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppText(
              "الطلبات",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff1C2B6B),
              ),
            ),
          ),
          OrdersTabBar(
            items: [
              OrdersTabBarItem(title: "الكل", count: 48),
              OrdersTabBarItem(
                title: "طلب جديد",
                count: 2,
                leadingColor: context.primary,
              ),
              OrdersTabBarItem(
                title: "قيد التحضير",
                count: 3,
                leadingColor: context.primaryContainer,
              ),
              OrdersTabBarItem(title: "جاهز للتسليم", count: 3),
              OrdersTabBarItem(title: "مكتمل", count: 3),
            ],
            onChanged: (index) {
              print(index);
            },
          ),
        ],
      ),
    );
  }
}
