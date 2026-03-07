import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../widgets/more_screen_app_bar.dart';
import '../widgets/section_card.dart';
import '../widgets/section_title.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          MoreScreenAppBar(),
          SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
              child: Column(
                children: [
                  SectionTitle(title: 'إعدادات المتجر'),
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
                          imageColor: Color(0xff059669),
                          icon: FontAwesomeIcons.store,
                          title: 'معلومات المتجر',
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
                          imageColor: Color(0xff0284C7),
                          icon: FontAwesomeIcons.solidClock,
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
                          imageColor: Color(0xffDC2626),
                          icon: FontAwesomeIcons.circleQuestion,
                          title: 'ادارة العروض',
                          subtitle: 'انشاء وتعديل العروض الترويجية',
                          onTap: () {
                            context.pushRoute('/offersmanagement');
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
                          imageColor: Color(0xffD97706),
                          icon: FontAwesomeIcons.ticket,
                          title: 'الكوبونات',
                          subtitle: 'ادارة اكواد الخصم',
                          onTap: () {
                            context.pushRoute('/couponsmanagement');
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
                          imageColor: Color(0xff2563EB),
                          icon: FontAwesomeIcons.headset,
                          title: 'الدعم الفني',
                          subtitle: 'تواصل مع فريق الدعم',
                          onTap: () {},
                        ),
                      ],
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
