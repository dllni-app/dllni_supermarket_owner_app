import 'dart:ui';

import 'package:common_package/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  final String shopName;
  final String shopAddress;
  const HomeAppBar({
    super.key,
    required this.shopName,
    required this.shopAddress,
  });

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
          children: [
            ProfileImage(),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    shopName,
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge!.copyWith(
                      color: AppColors.accent,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    shopAddress,
                    textAlign: TextAlign.center,
                    style: textTheme.labelMedium!.copyWith(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12),
            CircleIconButton(
              icon: Icons.notifications_none_outlined,
              onTap: () {},
              showBadge: true,
            ),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(icon, color: const Color(0xFF6B7280), size: 20),
            if (showBadge)
              Positioned(
                top: 10,
                right: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileImage extends StatelessWidget {
  const ProfileImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Color(0xFFC4C4C4),
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(width: 2, color: AppColors.white),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              border: Border.all(width: 2, color: AppColors.white),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Color(0xFF28C76F),
            ),
          ),
        ),
      ],
    );
  }
}
