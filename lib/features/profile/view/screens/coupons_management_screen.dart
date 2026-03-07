import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../widgets/coupon_card.dart';
import '../widgets/coupon_management_app_bar.dart';
import '../widgets/coupon_statistics_grid.dart';
import '../widgets/coupons_filter_card.dart';

@AutoRoutePage()
class CouponsManagementScreen extends StatelessWidget {
  const CouponsManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            CouponManagementAppBar(),
            SizedBox(height: 16),
            Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: context.primaryContainer),
                width: context.width,
                padding: EdgeInsetsDirectional.symmetric(vertical: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_circle, color: context.onPrimaryContainer, size: 22),
                    SizedBox(width: 8),
                    AppText.labelLarge('إنشاء كوبون جديد', color: context.onPrimaryContainer, fontWeight: FontWeight.bold),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            CouponsStatisticsGrid(),
            SizedBox(height: 16),
            CouponsFilterCard(),
            SizedBox(height: 16),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 20),
                itemBuilder: (context, index) => CouponCard(),
                separatorBuilder: (context, index) => SizedBox(height: 16),
                itemCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
