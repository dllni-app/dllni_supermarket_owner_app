import 'dart:ui';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import 'filter_button.dart';
import 'search_field.dart';

class ProductsAppBar extends StatelessWidget {
  const ProductsAppBar({super.key});

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "المنتجات",
              style: textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
                fontSize: 24,
              ),
            ),
            //  TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.w700)),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: SearchField(
                    hintText: "ابحث عن وجبة، مشروب...",
                    onChanged: (value) {},
                  ),
                ),
                SizedBox(width: 12),
                FilterButton(onTap: () {}),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
