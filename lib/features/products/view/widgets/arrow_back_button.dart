import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class ArrowBackButton extends StatelessWidget {
  const ArrowBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.pop(),
      borderRadius: BorderRadius.all(Radius.circular(12)),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(12),
        // decoration: BoxDecoration(
        //   color: Color(0xFFF9FAFB),
        //   borderRadius: BorderRadius.all(Radius.circular(12)),
        //   border: Border.all(color: Color(0x291E2A78)),
        // ),
        child: Icon(Icons.arrow_back_ios, size: 16, color: AppColors.white),
        //AppImage.asset(AppSvgs.arrow, size: 16, color: AppColors.white),
      ),
    );
  }
}
