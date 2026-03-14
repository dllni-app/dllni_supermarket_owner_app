import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/widgets/product_image_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../products/view/widgets/product_text_field.dart';

@AutoRoutePage(path: "/profile/employees/create_employee")
class CreateNewEmployeeScreen extends StatelessWidget {
  const CreateNewEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إضافة موظف جديد"),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  _ProfileForm(
                    title: "البيانات الأساسية",
                    icon: FontAwesomeIcons.user,
                    iconColor: Color(0xFF064E3B),
                    child: Column(
                      children: [
                        AppImageField(
                          onPickImage: (imagePath) {},
                          title: "صورة الموظف",
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          title: "الاسم الكامل",
                          hintText: "أدخل الاسم الكامل للموظف",
                          isRequired: true,
                        ),
                        SizedBox(height: 16),
                        AppTextField(
                          title: "رقم الهاتف",
                          hintText: "9xxxxxxxx",
                          isRequired: true,
                          suffixIcon: Padding(
                            padding: EdgeInsets.only(top: 15),
                            child: Text(
                              "   +963",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color(0xFF4B5563),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.42,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _ProfileForm(
                    title: "تحديد صلاحيات الموظف",
                    subtitle: "اختر الصلاحيات المناسبة لدور الموظف",
                    icon: FontAwesomeIcons.shieldHalved,
                    iconColor: Color(0xFFD97706),
                    child: Column(
                      spacing: 10,
                      children: [
                        _PermissionChooser(
                          title: "إدارة المنتجات",
                          subtitle: "إضافة وتعديل وحذف المنتجات",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "إدارة الطلبات",
                          subtitle: "عرض ومعالجة وتحديث حالة الطلبات",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "متابعة الإحصائيات",
                          subtitle: "عرض التقارير والمبيعات والأداء",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "إدارة المخزون",
                          subtitle: "تحديث الكميات وإدارة المواد",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "إضافة موظف",
                          subtitle: "إضافة موظفين جدد وتعديل بياناتهم",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "إدارة معلومات وأوقات عمل السوبر ماركت",
                          subtitle: "تعديل بيانات السوبر ماركت وأوقات العمل",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        _PermissionChooser(
                          title: "إدارة العروض والكوبونات",
                          subtitle: "إنشاء وتعديل العروض الترويجية",
                          icon: FontAwesomeIcons.box,
                          color: Color(0xFF064E3B),
                        ),
                        AlertMessage(
                          message:
                              "يمكنك تعديل صلاحيات الموظف في أي وقت من صفحة إدارة الموظفين",
                          color: Color(0xFF064E3B),
                          icon: FontAwesomeIcons.solidLightbulb,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  _ProfileForm(
                    title: "حالة الحساب",
                    icon: FontAwesomeIcons.toggleOn,
                    iconColor: Color(0xFF10B981),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFF9FAFB),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 4,
                                  children: [
                                    AppText(
                                      "تفعيل الحساب",
                                      style: TextStyle(
                                        color: Color(0xFF111827),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 1.42,
                                      ),
                                    ),
                                    AppText(
                                      "السماح للموظف بالدخول للنظام",
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 12,
                                        height: 1.333,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              AppSwitch(
                                onChanged: (value) {},
                                value: true,
                                activeColor: Color(0xFF10B981),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        AlertMessage(
                          message:
                              "الحساب نشط - سيتمكن الموظف من تسجيل الدخول فور الحفظ",
                          icon: FontAwesomeIcons.solidCircleCheck,
                          color: Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 28),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(title: "حفظ وتفعيل", onTap: () {}),
                      ),
                      SizedBox(width: 16),
                      AppOutlinedButton(
                        title: "إلغاء",
                        color: const Color(0xFFFF4C51),
                      ),
                    ],
                  ),
                  // SizedBox(height: 45),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PermissionChooser extends StatelessWidget {
  const _PermissionChooser({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: true,
            onChanged: (value) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(icon, color: color, size: 14),
                    Expanded(
                      child: AppText(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                        ),
                      ),
                    ),
                  ],
                ),
                AppText(
                  subtitle,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.333,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.title,
    this.subtitle,
    required this.child,
    required this.icon,
    required this.iconColor,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              spacing: 8,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: iconColor.withValues(alpha: .1),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    AppText(
                      title,
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    if (subtitle != null)
                      AppText(
                        subtitle!,
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class AlertMessage extends StatelessWidget {
  const AlertMessage({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
  });
  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 14, color: color),
          ),
          SizedBox(width: 11),
          Expanded(
            child: AppText(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.667,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
