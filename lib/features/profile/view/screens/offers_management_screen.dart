import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/widgets/app_app_bars.dart';
import '../widgets/offer_card.dart';
import '../widgets/offers_filter_card.dart';
import '../widgets/offers_statistics_grid.dart';

@AutoRoutePage(path: "/offers_management")
class OffersManagementScreen extends StatelessWidget {
  const OffersManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إدارة العروض"),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
            child: InkWell(
              onTap: () {
                context.pushRoute("/create_offer");
              },
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
                      'إنشاء عرض جديد',
                      color: context.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          OffersStatisticsGrid(),
          SizedBox(height: 16),
          OffersFilterCard(),
          SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsetsDirectional.only(
                start: 24,
                end: 24,
                bottom: 20,
              ),
              itemBuilder: (context, index) => OfferCard(),
              separatorBuilder: (context, index) => SizedBox(height: 16),
              itemCount: 5,
            ),
          ),
        ],
      ),
    );
  }
}
