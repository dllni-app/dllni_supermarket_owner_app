import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../../core/utils/app_svgs.dart';

class SellingIndicator extends StatelessWidget {
  final num percent;

  const SellingIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: percent >= 0 ? const Color(0x3322C55E) : const Color(0x33EF4444),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        spacing: 4,
        children: [
          AppImage.asset(AppSvgs.up, size: 13),
          AppText(
            "${percent > 0 ? "+$percent" : percent}%",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Color(0xFF4ADE80),
              fontSize: 12,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}
