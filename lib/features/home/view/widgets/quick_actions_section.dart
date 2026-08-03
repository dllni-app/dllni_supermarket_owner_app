import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/helpers/seller_permission_access.dart';
import '../../../../../core/themes/app_colors.dart';
import '../../../products/view/screens/add_product_menu_screen.dart';

class QuickActionChip extends StatelessWidget {
  const QuickActionChip({super.key, required this.item});

  final QuickActionChipItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      borderRadius: const BorderRadius.all(Radius.circular(23)),
      child: Container(
        width: item.width,
        height: 47,
        padding: const EdgeInsets.fromLTRB(20, 3, 3, 3),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(23)),
          color: Color(0xFFFFEAD6),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 21.5,
              backgroundColor: AppColors.accent,
              child: Icon(item.icon, size: 18, color: AppColors.white),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: AppText(
                item.label,
                style: const TextStyle(
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

class QuickActionChipItem {
  const QuickActionChipItem({
    required this.width,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final double width;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final access = SellerPermissionAccess.current();

    if (!access.can(SupermarketPermissionCodes.products)) {
      return const SizedBox.shrink();
    }

    final items = <QuickActionChipItem>[
      QuickActionChipItem(
        width: 133,
        label: 'إضافة يدوية',
        icon: FontAwesomeIcons.plus.data,
        onTap: () => context.pushRoute('/products/new_product/details'),
      ),
      QuickActionChipItem(
        width: 137,
        label: 'رفع ملف إكسل',
        icon: FontAwesomeIcons.fileExcel.data,
        onTap: () {
          context.pushRoute(
            '/products/new_product/menu',
            arguments: UploadFileType.file,
          );
        },
      ),
      QuickActionChipItem(
        width: 148,
        label: 'البحث في الكتالوج المركزي',
        icon: FontAwesomeIcons.magnifyingGlass.data,
        onTap: () => context.pushRoute('/products/new_product/catalog'),
      ),
      if (access.hasFullAccess)
        QuickActionChipItem(
          width: 148,
          label: 'تقارير الأداء',
          icon: FontAwesomeIcons.newspaper.data,
          onTap: () => context.pushRoute('/performance_report'),
        ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'إدارة المنتجات',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.333,
            color: Color(0xFF111827),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 67,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(vertical: 10),
            itemBuilder: (context, index) => QuickActionChip(
              item: items[index],
            ),
            separatorBuilder: (_, _) => const SizedBox(width: 8),
            itemCount: items.length,
          ),
        ),
      ],
    );
  }
}
