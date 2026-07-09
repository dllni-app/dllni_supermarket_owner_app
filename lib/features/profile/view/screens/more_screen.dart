import 'dart:convert';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../widgets/more_app_bar.dart';
import '../widgets/section_card.dart';
import '../widgets/section_title.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: AppText('تأكيد تسجيل الخروج', color: Color(0xFF111827)),
            content: AppText(
              'هل أنت متأكد أنك تريد تسجيل الخروج؟',
              color: Color(0xFF111827),
            ),
            actions: [
              TextButton(
                onPressed: () => context.pop(),
                child: AppText('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  context.pop();
                  await SharedPreferencesHelper.clearData();
                  if (!context.mounted) return;
                  context.pushRouteAndRemoveUntil('/login');
                },
                child: AppText('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: context.width,
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0x0DEF4444),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Color(0x33EF4444)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Color(0x1AEF4444),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(
                FontAwesomeIcons.arrowRightFromBracket.data,
                size: 18,
                color: Color(0xFFEF4444),
              ),
            ),
            SizedBox(width: 12),
            AppText(
              "تسجيل الخروج",
              style: TextStyle(
                color: Color(0xFFEF4444),
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.42,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MoreScreenState extends State<MoreScreen> {
  Map<String, dynamic> storeProfile = {};
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MoreAppBar(
            title: storeProfile["user"]['name'],
            // storeId: storeProfile["user"]['id'].toString(),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  SectionTitle(title: 'إعدادات السوبر ماركت'),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.onPrimaryContainer,
                      border: Border.all(color: Color(0xffF3F4F6), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          offset: Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsetsDirectional.all(16),
                    child: Column(
                      children: [
                        SectionCard(
                          containerColor: Color(0xffD1FAE5),
                          iconColor: Color(0xff059669),
                          icon: FontAwesomeIcons.store.data,
                          title: "معلومات السوبر ماركت",
                          subtitle: 'الاسم والعنوان والتفاصيل',
                          onTap: () {
                            context.pushRoute('/profile');
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 16,
                          ),
                          child: Divider(color: context.surface, thickness: .5),
                        ),
                        SectionCard(
                          containerColor: Color(0xffE0F2FE),
                          iconColor: Color(0xff0284C7),
                          icon: FontAwesomeIcons.solidClock.data,
                          title: 'ساعات العمل',
                          subtitle: 'تحديد اوقات الفتح والاغلاق',
                          onTap: () {
                            context.pushRoute('/workingtime');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SectionTitle(title: 'العروض والتسويق'),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.onPrimaryContainer,
                      border: Border.all(color: Color(0xffF3F4F6), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          offset: Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsetsDirectional.all(16),
                    child: Column(
                      children: [
                        SectionCard(
                          containerColor: Color(0xffFEE2E2),
                          iconColor: Color(0xffDC2626),
                          icon: FontAwesomeIcons.circleQuestion.data,
                          title: 'ادارة العروض',
                          subtitle: 'انشاء وتعديل العروض الترويجية',
                          onTap: () {
                            context.pushRoute('/offers_management');
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 16,
                          ),
                          child: Divider(color: context.surface, thickness: .5),
                        ),
                        SectionCard(
                          containerColor: Color(0xffFEF3C7),
                          iconColor: Color(0xffD97706),
                          icon: FontAwesomeIcons.ticket.data,
                          title: 'الكوبونات',
                          subtitle: 'ادارة اكواد الخصم',
                          onTap: () {
                            context.pushRoute('/coupons_management');
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  SectionTitle(title: 'الموظفون والسجل'),
                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.onPrimaryContainer,
                      border: Border.all(color: Color(0xffF3F4F6), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          offset: Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsetsDirectional.all(16),
                    child: Column(
                      children: [
                        SectionCard(
                          containerColor: Color(0xffCFFAFE),
                          iconColor: Color(0xff0891B2),
                          icon: FontAwesomeIcons.users.data,
                          title: 'ادارة الموظفين',
                          subtitle: 'إضافة وتعديل بيانات الموظفين',
                          onTap: () {
                            context.pushRoute('/profile/employees');
                          },
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            vertical: 16,
                          ),
                          child: Divider(color: context.surface, thickness: .5),
                        ),
                        SectionCard(
                          containerColor: Color(0xffF1F5F9),
                          iconColor: Color(0xff475569),
                          icon: FontAwesomeIcons.circleXmark.data,                          title: 'سجل نشاط الموظفين',
                          subtitle: 'متابعة نشاط الفريق',
                          onTap: () {
                            context.pushRoute('/profile/employees/activity_log');
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      color: context.onPrimaryContainer,
                      border: Border.all(color: Color(0xffF3F4F6), width: 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withAlpha(6),
                          offset: Offset(0, 2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: EdgeInsetsDirectional.all(16),
                    child: Column(
                      children: [
                        SectionCard(
                          containerColor: Color(0xffDBEAFE),
                          iconColor: Color(0xff2563EB),
                          icon: FontAwesomeIcons.headset.data,
                          title: 'الدعم الفني',
                          subtitle: 'تواصل مع فريق الدعم',
                          onTap: () {
                            AppToast.showToast(
                              context: context,
                              message: "هذه الميزة غير متوفرة حالياً",
                              type: ToastificationType.info,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  _LogoutButton(),
                  SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    storeProfile = jsonDecode(
      SharedPreferencesHelper.getData(key: 'user') as String,
    );
    print(storeProfile);
  }
}
