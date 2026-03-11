import 'package:common_package/widgets/app_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_svgs.dart';

class AddProductWayCard extends StatelessWidget {
  const AddProductWayCard({
    super.key,
    required this.onTap,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.hint,
  });
  final void Function() onTap;
  final Color backgroundColor;
  final Color foregroundColor;
  final String title, subtitle;
  final IconData icon;
  final String? hint;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 1),
              blurRadius: 2,
              color: Color(0x0D000000),
            ),
          ],
        ),
        child: Row(
          spacing: 16,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(icon, size: 20, color: foregroundColor),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  Row(
                    spacing: 6,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: Color(0xFF111827),
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 1.333,
                          ),
                        ),
                      ),
                      if (hint != null)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: backgroundColor,
                            borderRadius: BorderRadius.all(
                              Radius.circular(1000),
                            ),
                          ),
                          child: Text(
                            hint!,
                            style: TextStyle(
                              color: foregroundColor,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                        ),
                    ],
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.625,
                    ),
                  ),
                ],
              ),
            ),
            AppImage.asset(AppSvgs.arrowBackIos, size: 16),
          ],
        ),
      ),
    );
  }
}
