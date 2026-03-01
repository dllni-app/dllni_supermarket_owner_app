import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class StatePointer extends StatelessWidget {
  const StatePointer({
    super.key,
    required this.title,
    required this.value,
    this.isCritical = false,
  });
  final String title;
  final num value;
  final bool isCritical;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(32)),
        border: Border.all(color: Color(0xFFF9FAFB)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 15,
            color: Color(0x07000000),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Color(0xB22F2B3D),
              fontWeight: FontWeight.w500,
              height: 1.333,
            ),
          ),
          SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value.toString(),
                style: TextStyle(
                  color: isCritical && value > 0
                      ? Color(0xFFFF4C51)
                      : AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  height: 1.333,
                ),
              ),
              if (isCritical && value > 0)
                Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Color(0x14FF4C51),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Icon(
                    Icons.warning_rounded,
                    color: Color(0xFFFF4C51),
                    size: 16,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
