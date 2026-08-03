import 'dart:convert';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/helpers/seller_permission_access.dart';
import '../widgets/more_app_bar.dart';
import '../widgets/section_card.dart';
import '../widgets/section_title.dart';

class ProfilePermissionScreen extends StatelessWidget {
  const ProfilePermissionScreen({
    super.key,
    required this.permission,
  });

  final String permission;

  String get _userName {
    final rawProfile = SharedPreferencesHelper.getData(key: 'user');
    if (rawProfile is! String) return '';

    try {
      final decoded = jsonDecode(rawProfile);
      if (decoded is! Map) return '';
      final user = decoded['user'];
      if (user is Map && user['name'] != null) {
        return user['name'].toString();
      }
    } catch (_) {
      return '';
    }

    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          MoreAppBar(title: _userName),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  SectionTitle(title: _sectionTitle),
                  const SizedBox(height: 16),
                  _SectionContainer(children: _sectionCards(context)),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _sectionTitle {
    switch (permission) {
      case SupermarketPermissionCodes.storeData:
        return 'إعدادات السوبر ماركت';
      case SupermarketPermissionCodes.offersAndCoupons:
        return 'العروض والتسويق';
      case SupermarketPermissionCodes.employees:
        return 'الموظفون والسجل';
      default:
        return '';
    }
  }

  List<Widget> _sectionCards(BuildContext context) {
    switch (permission) {
      case SupermarketPermissionCodes.storeData:
        return [
          SectionCard(
            containerColor: const Color(0xffD1FAE5),
            iconColor: const Color(0xff059669),
            icon: FontAwesomeIcons.store.data,
            title: 'معلومات السوبر ماركت',
            subtitle: 'الاسم والعنوان والتفاصيل',
            onTap: () => context.pushRoute('/profile'),
          ),
          const _SectionDivider(),
          SectionCard(
            containerColor: const Color(0xffE0F2FE),
            iconColor: const Color(0xff0284C7),
            icon: FontAwesomeIcons.solidClock.data,
            title: 'ساعات العمل',
            subtitle: 'تحديد اوقات الفتح والاغلاق',
            onTap: () => context.pushRoute('/workingtime'),
          ),
        ];
      case SupermarketPermissionCodes.offersAndCoupons:
        return [
          SectionCard(
            containerColor: const Color(0xffFEE2E2),
            iconColor: const Color(0xffDC2626),
            icon: FontAwesomeIcons.tags.data,
            title: 'ادارة العروض',
            subtitle: 'انشاء وتعديل العروض الترويجية',
            onTap: () => context.pushRoute('/offers_management'),
          ),
          const _SectionDivider(),
          SectionCard(
            containerColor: const Color(0xffFEF3C7),
            iconColor: const Color(0xffD97706),
            icon: FontAwesomeIcons.ticket.data,
            title: 'الكوبونات',
            subtitle: 'ادارة اكواد الخصم',
            onTap: () => context.pushRoute('/coupons_management'),
          ),
        ];
      case SupermarketPermissionCodes.employees:
        return [
          SectionCard(
            containerColor: const Color(0xffCFFAFE),
            iconColor: const Color(0xff0891B2),
            icon: FontAwesomeIcons.users.data,
            title: 'ادارة الموظفين',
            subtitle: 'إضافة وتعديل بيانات الموظفين',
            onTap: () => context.pushRoute('/profile/employees'),
          ),
          const _SectionDivider(),
          SectionCard(
            containerColor: const Color(0xffF1F5F9),
            iconColor: const Color(0xff475569),
            icon: FontAwesomeIcons.clockRotateLeft.data,
            title: 'سجل نشاط الموظفين',
            subtitle: 'متابعة نشاط الفريق',
            onTap: () => context.pushRoute(
              '/profile/employees/activity_log',
            ),
          ),
        ];
      default:
        return const [];
    }
  }
}

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.onPrimaryContainer,
        border: Border.all(color: const Color(0xffF3F4F6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            offset: const Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: const EdgeInsetsDirectional.all(16),
      child: Column(children: children),
    );
  }
}

class _SectionDivider extends StatelessWidget {
  const _SectionDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
      child: Divider(color: context.surface, thickness: .5),
    );
  }
}
