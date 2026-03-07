import 'package:common_package/widgets/app_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_gradients.dart';
import '../../../../core/utils/app_images.dart';

class FilterButton extends StatelessWidget {
  const FilterButton({super.key, required this.onTap});
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(24)),
      child: Container(
        alignment: Alignment.center,
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          // color: AppColors.primary,
          gradient: AppGradients.gradient,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        child: AppImage.asset(AppImages.filter, width: 16, height: 16),
      ),
    );
  }
}
