import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../models/home_models.dart';

class NewOrdersSection extends StatelessWidget {
  const NewOrdersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppText(
                  "طلبات جديدة",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.5,
                  ),
                ),
                SizedBox(width: 8),
              ],
            ),
            InkWell(
              onTap: () {},
              child: AppText(
                "عرض الكل",
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xB22F2B3D),
                  fontWeight: FontWeight.w700,
                  height: 1.333,
                ),
              ),
            ),
          ],
        ),
        OrderCard(),
      ],
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: context.primaryContainer, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 32,
            offset: const Offset(0, 8),
            color: const Color(0x33000000),
          ),
        ],
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
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
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: context.primaryContainer,
                      borderRadius: BorderRadius.all(Radius.circular(4)),
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
            child: AppText(
              "1× مشاوي مشكل - 2× حمص - 4× بيبسي",
              style: TextStyle(
                color: const Color(0xE52F2B3D),
                fontSize: 12,
                height: 1.333,
              ),
            ),
          ),

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
              AppButtonWithBorder(
                title: "رفض",
                onTap: () {
                  print("Reject");
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
