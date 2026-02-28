import 'dart:ui';

import 'package:common_package/theme/text_theme.dart';
import 'package:flutter/material.dart';

import '../../../../../core/themes/app_colors.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({super.key});

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
          mainAxisSize: MainAxisSize.min,
          children: [
            ProfileImage(),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "مطعم البيت الحلبي",
                  style: textTheme.titleLarge!.copyWith(
                    color: AppColors.accent,
                    fontSize: 18,
                  ),
                ),
                Text(
                  "الفرع الرئيسي - العزيزية",
                  style: textTheme.labelMedium!.copyWith(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            //  TextStyle(fontSize: 24, color: AppColors.primary, fontWeight: FontWeight.w700)),
            Spacer(),
            CircleIconButton(icon: Icons.notifications, onTap: () {}),
          ],
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  const CircleIconButton({super.key, required this.icon, this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

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
        child: Icon(icon, color: const Color(0xFF6B7280), size: 20),
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
