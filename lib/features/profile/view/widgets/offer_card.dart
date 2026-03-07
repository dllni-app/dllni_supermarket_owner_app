import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffF3F4F6), width: 1),
        color: context.onPrimary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            offset: Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText.titleMedium(
                      'خصم 25% على الوجبات العائلية',
                      fontWeight: FontWeight.bold,
                    ),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xff10B981).withAlpha(25),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 9,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              AppText.labelLarge(
                                'نشط',
                                color: Color(0xff10B981),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xffF9FAFB),
            ),
            padding: EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            child: Column(
              spacing: 10,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelLarge(
                      'قيمة الخصم',
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                    AppText.bodyMedium(
                      '25%',
                      color: Color(0xff064E3B),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelLarge(
                      'مدة العرض',
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                    AppText.bodyMedium(
                      '1 يناير - 31 يناير',
                      color: Color(0xff064E3B),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelLarge(
                      'المنتجات المرتبطة',
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                    AppText.bodyMedium(
                      '8 منتجات',
                      color: Color(0xff064E3B),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          Divider(color: Color(0xffF3F4F6), thickness: 1),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                spacing: 8,
                children: [
                  Icon(
                    FontAwesomeIcons.receipt,
                    color: Color(0xff4B5563),
                    size: 10,
                  ),
                  AppText.labelLarge(
                    'طلبات مستفيدة',
                    color: Color(0xff4B5563),
                    fontWeight: FontWeight.w400,
                  ),
                ],
              ),
              AppText.bodyMedium(
                '142 طلب',
                color: Color(0xff10B981),
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
