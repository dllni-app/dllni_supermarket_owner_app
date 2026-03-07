import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

class CouponCard extends StatelessWidget {
  const CouponCard({super.key});

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
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Color(0xff064E3B).withAlpha(25),
                          ),
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          child: AppText.titleMedium(
                            'SAVE25',
                            fontWeight: FontWeight.w400,
                            color: Color(0xff064E3B),
                          ),
                        ),
                        SizedBox(width: 8),
                        InkWell(
                          onTap: () async {
                            await Clipboard.setData(
                              ClipboardData(text: "your text"),
                            );
                            if (context.mounted) {
                              AppToast.showToast(
                                context: context,
                                message: 'تم نسخ اسم الكوبون',
                                type: ToastificationType.info,
                              );
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Color(0xffF3F4F6),
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                            child: Icon(Icons.copy_rounded, size: 20),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
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
                      'الحد الأدنى للطلب',
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                    AppText.bodyMedium(
                      '200 ل.س',
                      color: Color(0xff064E3B),
                      fontWeight: FontWeight.bold,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText.labelLarge(
                      'عدد الاستخدامات',
                      color: Color(0xff4B5563),
                      fontWeight: FontWeight.w400,
                    ),
                    AppText.bodyMedium(
                      '104 / 200',
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
                      '28 فبراير 2026',
                      color: Color(0xff064E3B),
                      fontWeight: FontWeight.bold,
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
}
