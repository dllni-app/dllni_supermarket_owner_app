import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../themes/app_colors.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    this.onTap,
    required this.title,
    this.withShadow = true,
    this.color = AppColors.primary
  });
  final void Function()? onTap;
  final String title;
  final bool withShadow;
  final Color color ;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: onTap != null ? color : const Color(0x662F2B3D),
          boxShadow: onTap == null || (onTap != null && !withShadow)
              ? null
              : [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 16,
                    color: const Color(0x661E2A78),
                  ),
                ],
        ),
        child: AppText(
          title,
          style: TextStyle(
            color: const Color(0xFFFFEEFF),
            fontSize: 14,
            height: 1.42,
          ),
        ),
      ),
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  const AppOutlinedButton({
    super.key,
    this.onTap,
    required this.title,
    required this.color,
    this.icon,
    this.withBackground = true,
  });
  final void Function()? onTap;
  final String title;
  final bool withBackground;
  final Color color;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: withBackground ? color.withValues(alpha: .08) : null,
          border: Border.all(color: color),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppText(
              title,
              style: TextStyle(color: color, fontSize: 14, height: 1.42),
            ),
            if (icon != null) ...[
              SizedBox(width: 6),
              Icon(icon, size: 12, color: color),
            ],
          ],
        ),
      ),
    );
  }
}
