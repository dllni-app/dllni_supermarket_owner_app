import 'dart:convert';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/helpers/seller_permission_access.dart';
import '../widgets/more_app_bar.dart';
import '../widgets/section_card.dart';
import '../widgets/section_title.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({super.key});

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  Map<String, dynamic> storeProfile = {};

  String get _userName {
    final user = storeProfile['user'];
    if (user is Map && user['name'] != null) {
      return user['name'].toString();
    }
    return '';
  }

  @override
  void initState() {
    super.initState();

    final rawProfile = SharedPreferencesHelper.getData(key: 'user');
    if (rawProfile is String) {
      try {
        final decoded = jsonDecode(rawProfile);
        if (decoded is Map) {
          storeProfile = Map<String, dynamic>.from(decoded);
        }
      } catch (_) {
        storeProfile = {};
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final access = SellerPermissionAccess.current();
    final canManageStore = access.can(SupermarketPermissionCodes.storeData);
    final canManageOffers = access.can(
      SupermarketPermissionCodes.offersAndCoupons,
    );
    final canManageEmployees = access.can(
      SupermarketPermissionCodes.employees,
    );

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
                  if (canManageStore) ...[
                    const SectionTitle(title: 'إعدادات السوبر ماركت'),
                    const SizedBox(height: 16),
                    _SectionContainer(
                      children: [
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
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (canManageOffers) ...[
                    const SectionTitle(title: 'العروض والتسويق'),
                    const SizedBox(height: 16),
                    _SectionContainer(
                      children: [
                        SectionCard(
                          containerColor: const Color(0xffFEE2E2),
                          iconColor: const Color(0xffDC2626),
                          icon: FontAwesomeIcons.circleQuestion.data,
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
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (canManageEmployees) ...[
                    const SectionTitle(title: 'الموظفون والسجل'),
                    const SizedBox(height: 16),
                    _SectionContainer(
                      children: [
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
                          icon: FontAwesomeIcons.circleXmark.data,
                          title: 'سجل نشاط الموظفين',
                          subtitle: 'متابعة نشاط الفريق',
                          onTap: () => context.pushRoute(
                            '/profile/employees/activity_log',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                  _SectionContainer(
                    children: [
                      SectionCard(
                        containerColor: const Color(0xffDBEAFE),
                        iconColor: const Color(0xff2563EB),
                        icon: FontAwesomeIcons.headset.data,
                        title: 'الدعم الفني',
                        subtitle: 'تواصل مع فريق الدعم',
                        onTap: () {
                          AppToast.showToast(
                            context: context,
                            message: 'هذه الميزة غير متوفرة حالياً',
                            type: ToastificationType.info,
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const _LogoutButton(),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<void>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: AppText(
              'تأكيد تسجيل الخروج',
              color: Color(0xFF111827),
            ),
            content: AppText(
              'هل أنت متأكد أنك تريد تسجيل الخروج؟',
              color: Color(0xFF111827),
            ),
            actions: [
              TextButton(
                onPressed: () => dialogContext.pop(),
                child: AppText('إلغاء'),
              ),
              ElevatedButton(
                onPressed: () async {
                  dialogContext.pop();
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
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x0DEF4444),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0x33EF4444)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0x1AEF4444),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Icon(
                FontAwesomeIcons.arrowRightFromBracket.data,
                size: 18,
                color: const Color(0xFFEF4444),
              ),
            ),
            const SizedBox(width: 12),
            AppText(
              'تسجيل الخروج',
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
