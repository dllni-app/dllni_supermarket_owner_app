import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class BigButtonWithIcon extends StatelessWidget {
  const BigButtonWithIcon({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });
  final String title;
  final Widget icon;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      label: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.333,
        ),
      ),
      icon: icon,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 8),
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
      ),
    );
  }
}
