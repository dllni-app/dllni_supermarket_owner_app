import 'package:common_package/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';

class OverviewStatCard extends StatelessWidget {
  const OverviewStatCard({
    super.key,
    required this.foregroundColor,
    required this.backgroundColor,
    required this.icon,
    required this.value,
    required this.label,
  });
  final Color foregroundColor;
  final Color backgroundColor;
  final IconData icon;
  final int value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 8),
            color: const Color(0x33000000),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border(
              bottom: BorderSide(
                width: 2,
                color: backgroundColor.withValues(alpha: 1),
              ),
              top: BorderSide(color: const Color(0x33EAB308)),
              left: BorderSide(color: const Color(0x33EAB308)),
              right: BorderSide(color: const Color(0x33EAB308)),
            ),
          ),
          child: Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: foregroundColor, size: 16),
              ),
              SizedBox(height: 8),
              AppText(
                value.toString(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D2339),
                  height: 1.333,
                ),
              ),
              SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF9CA3AF),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
