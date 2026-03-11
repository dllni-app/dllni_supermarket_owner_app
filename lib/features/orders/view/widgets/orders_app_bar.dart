import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class OrdersAppBar extends StatelessWidget {
  const OrdersAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      width: context.width,
      padding: EdgeInsets.only(
        top: 16 + MediaQuery.paddingOf(context).top,
        bottom: 26,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 7.3,
            color: Color(0x40000000),
          ),
        ],
      ),
      child: AppText(
        "الطلبات",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.white,
        ),
      ),
    );
  }
}
