import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../screens/order_details_screen.dart';

enum PaymentWay { cash }

enum OrderStatus { pending, preparing, readyForPickup, completed, rejected }

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.status,
    this.paymentWay = PaymentWay.cash,
  });
  final OrderStatus status;
  final PaymentWay paymentWay;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RoundedRectDottedBorderOptions(
        radius: Radius.circular(8),
        dashPattern: [10, 10],
        color: status == OrderStatus.completed
            ? Color(0xFF10B981)
            : Color(0xFF8591E0),
      ),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        decoration: BoxDecoration(
          color: status == OrderStatus.completed
              ? AppColors.white
              : Color(0x1F8591E0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: .08),
                  border: Border(
                    bottom: BorderSide(
                      color: statusColor.withValues(alpha: .16),
                    ),
                    right: BorderSide(
                      color: statusColor.withValues(alpha: .16),
                    ),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    leadingStatusTag,
                    if (status != OrderStatus.completed) SizedBox(width: 4),
                    AppText.labelSmall(
                      statusLabel,
                      style: TextStyle(
                        color: statusFontColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(
                13,
                2,
                13,
                status == OrderStatus.completed ? 16 : 26,
              ),
              child: status == OrderStatus.completed
                  ? Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: statusColor.withValues(alpha: .16),
                          child: Icon(
                            FontAwesomeIcons.check,
                            size: 16,
                            color: statusFontColor,
                          ),
                        ),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppText(
                              "#ORD-4923",
                              style: TextStyle(
                                color: Color(0xE52F2B3D),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.42,
                              ),
                            ),
                            AppText(
                              "منذ ساعة",
                              textDirection: TextDirection.ltr,
                              style: TextStyle(
                                color: Color(0x992F2B3D),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        AppText(
                          "145 ل.س",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            height: 1.42,
                          ),
                        ),
                      ],
                    )
                  : Column(
                      spacing: 16,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                color: const Color(0xFF1F2937),
                              ),
                              child: Icon(
                                FontAwesomeIcons.user,
                                size: 16,
                                color: const Color(0xFF9CA3AF),
                              ),
                            ),
                            SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AppText(
                                  "عبدالله المحمد",
                                  style: TextStyle(
                                    color: Color(0xE5000000),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    height: 1.42,
                                  ),
                                ),
                                AppText(
                                  "#ORD-4923 • منذ 2 دقيقة",
                                  textDirection: TextDirection.ltr,
                                  style: TextStyle(
                                    color: Color(0x992F2B3D),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 2.5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AppText(
                                    "145 ل.س",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.54,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  AppText(
                                    "نقدي",
                                    style: TextStyle(
                                      color: AppColors.accent,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      height: 1.3,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: context.width,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                          ),
                          child: Column(
                            spacing: 12,
                            children: [
                              _RequirementRow(
                                label: "1- سيتي كورن ( نكهة الحار و الحلو )",
                              ),
                              _RequirementRow(label: "2- سطل لبن بقر"),
                              _RequirementRow(
                                label: "4- علبة كاتشب العجمي (حار) * 2",
                              ),
                              _RequirementRow(
                                label: "3- كيس كريم توم العجمي * 2",
                              ),
                              _RequirementRow(label: "5- كيس مخلل الأزرق * 2"),
                            ],
                          ),
                        ),
                        if (status == OrderStatus.pending)
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: "قبول الطلب",
                                  onTap: () {
                                    print("accept");
                                  },
                                ),
                              ),
                              AppOutlinedButton(
                                color: const Color(0xFFFF4C51),
                                title: "رفض",
                                onTap: () {
                                  print("Reject");
                                  // showModalBottomSheet(
                                  //   context: context,
                                  //   builder: (_) => RejectOrderSheet(orderId: 1),
                                  // );
                                },
                              ),
                            ],
                          )
                        else if (status == OrderStatus.preparing)
                          SizedBox(
                            width: context.width,
                            child: AppButton(
                              icon: Icons.arrow_forward_rounded,
                              title: "عرض التفاصيل",
                              onTap: () {
                                print("show details");
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => OrderDetailsScreen(),
                                  ),
                                );
                              },
                            ),
                          )
                        else if (status == OrderStatus.readyForPickup)
                          Row(
                            spacing: 16,
                            children: [
                              Expanded(
                                child: AppButton(
                                  color: const Color(0xFF24B364),
                                  title: "تسليم للمندوب",
                                  onTap: () {
                                    print("give to worker");
                                  },
                                ),
                              ),
                              Expanded(
                                child: AppOutlinedButton(
                                  withBackground: false,
                                  color: const Color(0xFF6C63FF),
                                  title: "طباعة الفاتورة",
                                  onTap: () {
                                    print("print bill");
                                  },
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Color get statusColor => switch (status) {
    OrderStatus.completed ||
    OrderStatus.readyForPickup => const Color(0xFF28C76F),
    OrderStatus.preparing => AppColors.accent,
    _ => AppColors.primary,
  };

  Color get statusFontColor => switch (status) {
    OrderStatus.completed ||
    OrderStatus.readyForPickup => const Color(0xFF24B364),
    OrderStatus.preparing => AppColors.accent,
    _ => AppColors.primary,
  };

  Widget get leadingStatusTag => switch (status) {
    OrderStatus.pending => CircleAvatar(
      radius: 4,
      backgroundColor: AppColors.primary,
    ),
    OrderStatus.preparing => Icon(
      FontAwesomeIcons.fireBurner,
      size: 12,
      color: statusFontColor,
    ),
    OrderStatus.readyForPickup => Icon(
      FontAwesomeIcons.solidCircleCheck,
      size: 12,
      color: statusFontColor,
    ),
    _ => SizedBox(),
  };

  String get statusLabel => switch (status) {
    OrderStatus.pending => "طلب جديد",
    OrderStatus.preparing => "قيد التحضير",
    OrderStatus.readyForPickup => "جاهز للتسليم",
    OrderStatus.completed => "مكتمل",
    OrderStatus.rejected => "مرفوض",
  };
}

class _RequirementRow extends StatelessWidget {
  const _RequirementRow({required this.label});

  final String label;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AppText(
          label,
          style: TextStyle(
            color: Color(0xE52F2B3D),
            fontSize: 12,
            height: 1.333,
          ),
        ),
        Spacer(),
        CircleAvatar(radius: 9.5, backgroundColor: Color(0xFFD9D9D9)),
        SizedBox(width: 12),
        GestureDetector(
          onTap: () {},
          child: Icon(
            FontAwesomeIcons.circleQuestion,
            color: Color(0xFFFFAF66),
            size: 18,
          ),
        ),
      ],
    );
  }
}
