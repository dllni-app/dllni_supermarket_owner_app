import 'dart:ui';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../../features/products/view/widgets/arrow_back_button.dart';

class AppSimpleAppBar extends StatelessWidget {
  const AppSimpleAppBar({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        width: width,
        padding: EdgeInsets.fromLTRB(
          16,
          16 + MediaQuery.paddingOf(context).top,
          16,
          20,
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            ArrowBackButton(),
            Text(
              title,
              style: textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
