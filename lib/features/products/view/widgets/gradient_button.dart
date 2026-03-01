
import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.title,
    this.icon,
    this.spacing = 8,
    required this.onTap,
  });
  final String title;
  final Widget? icon;
  final double spacing;
  
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: MediaQuery.sizeOf(context).width,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          gradient: LinearGradient(
            colors: [Color(0xFF4ADE80), Color(0xFF60A5FA)],
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[icon!, SizedBox(width: spacing)],
            AppText(
              title,
              style: TextStyle(
                color: Color(0xFFFFEEFF),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.42,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
