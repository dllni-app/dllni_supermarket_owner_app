import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/app_app_bars.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../../products/view/widgets/big_button_with_icon.dart';

@AutoRoutePage(path: "/profile/employees")
class EmployeeManagementScreen extends StatelessWidget {
  const EmployeeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Column(
        children: [
          AppSimpleAppBar(title: "إدارة الموظفين"),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: context.width,
                  child: BigButtonWithIcon(
                    icon: AppImage.asset(AppSvgs.add, size: 22),
                    title: "إضافة موظف جديد",
                    onPressed: () {
                      context.pushRoute("/profile/employees/create_employee");
                    },
                  ),
                ),
                SizedBox(height: 16),
                _FilterSection(
                  onSearchChanged: (value) {},
                  onFilterPressed: () {},
                  onSortingPressed: () {},
                ),
                SizedBox(height: 3),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.all(16),
              itemBuilder: (context, index) => _EmployeeCard(),
              itemCount: 3,
              separatorBuilder: (context, index) => SizedBox(height: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({
    required this.onSortingPressed,
    required this.onFilterPressed,
    required this.onSearchChanged,
  });

  final void Function() onSortingPressed;
  final void Function() onFilterPressed;
  final void Function(String value) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Color(0xFF111287),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            onChanged: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              filled: true,
              fillColor: Color(0xFFF9FAFB),
              hintText: "ابحث عن موظف...",
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
          SizedBox(height: 12),
          Row(
            spacing: 8,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: onFilterPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.filter,
                          color: AppColors.accent,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        AppText(
                          "حسب الحالة",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.42,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: onSortingPressed,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 11),
                    decoration: BoxDecoration(
                      color: Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.sort,
                          color: AppColors.accent,
                          size: 14,
                        ),
                        SizedBox(width: 8),
                        AppText(
                          "ترتيب",
                          style: TextStyle(
                            color: AppColors.accent,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            height: 1.42,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  const _EmployeeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage.asset(
                AppImages.burgerImage,
                size: 56,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "أحمد محمد العلي",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0x1A10B981),
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircleAvatar(
                                radius: 3,
                                backgroundColor: Color(0xFF10B981),
                              ),
                              SizedBox(width: 4),
                              AppText(
                                "نشط",
                                style: TextStyle(
                                  color: Color(0xFF10B981),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  height: 1.333,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.phone, color: Color(0xFF4B5563), size: 10),
                        SizedBox(width: 4),
                        AppText(
                          "09512345678",
                          style: TextStyle(
                            color: Color(0xFF4B5563),

                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.333,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.more_vert, color: Color(0xFF4B5563), size: 18),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFF9FAFB),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      "تاريخ الانضمام",
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        height: 1.333,
                      ),
                    ),
                    Spacer(),
                    AppText(
                      "20 مارس 2023",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                AppText(
                  "تاريخ الانضمام",
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    height: 1.333,
                  ),
                ),
                ...[
                  AppText(
                    "تاريخ الانضمام",
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.6667,
                    ),
                  ),
                  AppText(
                    "تاريخ الانضمام",
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.6667,
                    ),
                  ),
                  AppText(
                    "تاريخ الانضمام",
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.6667,
                    ),
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              width: context.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 5.3,
                    color: Color(0x40000000),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.solidEye,
                    size: 14,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 8),
                  AppText(
                    "تفاصيل",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
