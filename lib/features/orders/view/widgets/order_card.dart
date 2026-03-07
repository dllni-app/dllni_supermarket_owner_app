import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_buttons.dart';

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
    return Container(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: status == OrderStatus.completed
            ? null
            : Border(
                right: BorderSide(color: context.primaryContainer, width: 4),
              ),
        boxShadow: status != OrderStatus.pending
            ? null
            : [
                BoxShadow(
                  blurRadius: 32,
                  offset: const Offset(0, 8),
                  color: const Color(0x33000000),
                ),
              ],
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
                  bottom: BorderSide(color: statusColor.withValues(alpha: .16)),
                  right: BorderSide(color: statusColor.withValues(alpha: .16)),
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
            padding: EdgeInsets.fromLTRB(16, 2, 16, 16),
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
                          color: context.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                        ),
                      ),
                    ],
                  )
                : Column(
                    spacing: 12,
                    children: [
                      Row(
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
                                  color: Color(0xE52F2B3D),
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
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            spacing: 4,
                            children: [
                              AppText(
                                "145 ل.س",
                                style: TextStyle(
                                  color: context.primary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.42,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: context.primaryContainer,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(4),
                                  ),
                                ),
                                child: AppText(
                                  "نقدي",
                                  style: TextStyle(
                                    color: AppColors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    height: 1.7,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerRight,
                        width: context.width,
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0x1F2F2B3D),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "1× مشاوي مشكل - 2× حمص - 4× بيبسي",
                              style: TextStyle(
                                color: const Color(0xE52F2B3D),
                                fontSize: 12,
                                height: 1.333,
                              ),
                            ),
                            Divider(color: const Color(0x1F2F2B3D)),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: 4,
                              children: [
                                Icon(
                                  FontAwesomeIcons.personBiking,
                                  size: 15,
                                  color: const Color(0x992F2B3D),
                                ),
                                AppText.labelMedium(
                                  "توصيل",
                                  style: TextStyle(
                                    color: const Color(0x992F2B3D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ],
                            ),
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
                          child: AppOutlinedButton(
                            color: context.primaryContainer,
                            withBackground: false,
                            icon: Icons.arrow_forward_rounded,
                            title: "عرض التفاصيل",
                            onTap: () {
                              print("show details");
                            },
                          ),
                        )
                      else if (status == OrderStatus.readyForPickup)
                        Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: AppButton(
                                withShadow: false,
                                color: context.secondary,
                                title: "تسليم للمندوب",
                                onTap: () {
                                  print("give to worker");
                                },
                              ),
                            ),
                            Expanded(
                              child: AppOutlinedButton(
                                withBackground: false,
                                color: const Color(0xFF151D54),
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
