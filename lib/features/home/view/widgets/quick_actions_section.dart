import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_shadows.dart';

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  final List<String> labels = const [
    "إضافة يدوية",
    "المسح الضوئي للباركود",
    "رفع ملف إكسل",
    "البحث في الكتالوج المركزي",
    "قائمة جاهزة للإضافة",
  ];
  final List<IconData> icons = const [
    FontAwesomeIcons.plus,
    FontAwesomeIcons.expand,
    FontAwesomeIcons.fileExcel,
    FontAwesomeIcons.magnifyingGlass,
    FontAwesomeIcons.tableList,
  ];
  final List<double> widths = const [133, 152, 137, 148, 127];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "إدارة المنتجات",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.333,
            color: Color(0xFF111827),
          ),
        ),
        SizedBox(height: 10),
        SizedBox(
          height: 67,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.all(10),
            itemBuilder: (context, index) => QuickActionChip(
              label: labels[index],
              icon: icons[index],
              onTap: () {
                AppToast.showToast(
                  context: context,
                  message: "قيد التطوير",
                  type: ToastificationType.info,
                );
              },
              width: widths[index],
            ),
            separatorBuilder: (_, _) => SizedBox(width: 8),
            itemCount: labels.length,
          ),
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
    required this.onTap,
    required this.width,
  });

  final String label;
  final IconData icon;
  final void Function() onTap;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(23)),
      child: Container(
        width: width,
        height: 47,
        padding: EdgeInsets.fromLTRB(20, 3, 3, 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          color: const Color(0xFFFFEAD6),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21.5,
              backgroundColor: AppColors.accent,
              child: Icon(icon, size: 18, color: AppColors.white),
            ),
            SizedBox(width: 10),
            Flexible(
              child: AppText(
                label,
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 10,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionsSectionOld extends StatelessWidget {
  const QuickActionsSectionOld({super.key});

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
              child: QuickActionChipOld(
                icon: FontAwesomeIcons.plus,
                isPrimary: true,
                label: 'منتج جديد',
                onTap: () {
                  context.pushRoute("/products/new_product");
                },
              ),
            ),
            Expanded(
              child: QuickActionChipOld(
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
              child: QuickActionChipOld(
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
              child: QuickActionChipOld(
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

class QuickActionChipOld extends StatelessWidget {
  const QuickActionChipOld({
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
