import 'package:common_package/widgets/app_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_svgs.dart';

class ExpandedProductCard extends StatefulWidget {
  const ExpandedProductCard({
    super.key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.expandedWidget,
  });
  final Color backgroundColor;
  final Color foregroundColor;
  final String title, subtitle;
  final IconData icon;
  final Widget expandedWidget;

  @override
  State<ExpandedProductCard> createState() => _ExpandedProductCardState();
}

class _ExpandedProductCardState extends State<ExpandedProductCard> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              isOpen = !isOpen;
              setState(() {});
            },
            child: Row(
              spacing: 16,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                  child: Icon(
                    widget.icon,
                    size: 20,
                    color: widget.foregroundColor,
                  ),
                ),
                Expanded(
                  child: Column(
                    spacing: 4,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.333,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        widget.subtitle,
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
                RotatedBox(
                  quarterTurns: isOpen ? 30 : 0,
                  child: AppImage.asset(AppSvgs.arrowDownIos, size: 14),
                ),
              ],
            ),
          ),
          if (isOpen)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 16),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF4ADE80), Color(0xFF60A5FA)],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(38)),
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.all(Radius.circular(38)),
                    ),
                    child: widget.expandedWidget,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
