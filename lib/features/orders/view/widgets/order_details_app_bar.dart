import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../products/view/widgets/arrow_back_button.dart';

class OrderDetailsAppBar extends StatelessWidget {
  const OrderDetailsAppBar({
    super.key,
    required this.title,
    required this.productId,
  });
  final String title;
  final String productId;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return Container(
      width: width,
      padding: EdgeInsets.fromLTRB(
        16,
        16 + MediaQuery.paddingOf(context).top,
        16,
        32,
      ),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 7.3,
            color: Color(0x40000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 4,
        children: [
          const ArrowBackButton(),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                title,
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 20,
                ),
              ),
              SizedBox(height: 1),
              AppText(
                "id:$productId",
                style: TextStyle(
                  color: Color(0x99FFFFFF),
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
