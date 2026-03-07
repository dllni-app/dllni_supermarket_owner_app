import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_shadows.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إجراءات سريعة",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.333,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 12),
        Row(
          spacing: 12,
          children: [
            Expanded(
              child: QuickActionChip(
                icon: FontAwesomeIcons.plus,
                isPrimary: true,
                label: 'منتج جديد',
                onTap: () {
                  context.pushRoute("/products/new_product");
                },
              ),
            ),
            Expanded(
              child: QuickActionChip(
                icon: FontAwesomeIcons.percent,
                label: 'إنشاء عرض',
                onTap: () {
                  AppToast.showToast(
                    context: context,
                    message: "قيد التطوير",
                    type: ToastificationType.info,
                  );
                },
              ),
            ),
            Expanded(
              child: QuickActionChip(
                icon: FontAwesomeIcons.boxOpen,
                label: 'تعديل المخزون',
                onTap: () {
                  AppToast.showToast(
                    context: context,
                    message: "قيد التطوير",
                    type: ToastificationType.info,
                  );
                },
              ),
            ),
            Expanded(
              child: QuickActionChip(
                icon: FontAwesomeIcons.paperPlane,
                label: 'التقارير',
                onTap: () {
                  AppToast.showToast(
                    context: context,
                    message: "قيد التطوير",
                    type: ToastificationType.info,
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class QuickActionChip extends StatelessWidget {
  const QuickActionChip({
    super.key,
    required this.label,
    required this.icon,
    this.isPrimary = false,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final bool isPrimary;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isPrimary ? context.primaryContainer : AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFFF3F4F6)),
              boxShadow: [AppShadows.shadow],
            ),
            child: Icon(
              icon,
              color: isPrimary ? AppColors.white : const Color(0xFF064E3B),
              size: 18,
            ),
          ),
        ),
        AppText(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF4B5563),
            height: 1.5,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}
