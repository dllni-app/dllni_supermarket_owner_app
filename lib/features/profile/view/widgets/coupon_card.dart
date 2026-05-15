import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/themes/app_shadows.dart';
import '../../data/models/get_coupon_codes_model.dart';

class _CouponStatus {
  final String label;
  final Color color;

  const _CouponStatus({required this.label, required this.color});
}

class CouponCard extends StatelessWidget {
  const CouponCard({super.key, required this.coupon});
  final GetCouponCodesModelDataItem coupon;
  static const List<_CouponStatus> statuses = [
    _CouponStatus(label: "نشط", color: Color(0xff10B981)),
    _CouponStatus(label: "معطل", color: Color(0xffF59E0B)),
    _CouponStatus(label: "منتهي", color: Color(0xff9CA3AF)),
  ];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: status.label == "منتهي" ? .6 : 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffF3F4F6), width: 1),
          color: context.onPrimary,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [AppShadows.shadow],
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
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: const Color(0x1A064E3B),
                              border: Border.all(color: Color(0xFFE5E7EB)),
                            ),
                            child: AppText(
                              coupon.code.toString(),
                              style: TextStyle(
                                color: Color(0xFF064E3B),
                                fontSize: 16,
                                height: 1.5,
                                letterSpacing: 2,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          InkWell(
                            onTap: () async {
                              await Clipboard.setData(
                                ClipboardData(text: coupon.code.toString()),
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
                              color: status.color.withValues(alpha: .1),
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: Row(
                              spacing: 4,
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: status.color,
                                ),
                                AppText(
                                  status.label,
                                  style: TextStyle(
                                    color: status.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: isPercent
                                  ? Color(0x1A10B981)
                                  : Color(0x1AD97706),
                            ),
                            padding: EdgeInsetsDirectional.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            child: AppText(
                              isPercent ? "نسبة مئوية" : "مبلغ ثابت",
                              style: TextStyle(
                                color: isPercent
                                    ? Color(0xFF064E3B)
                                    : Color(0xFFD97706),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.333,
                              ),
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
                      AppText(
                        'قيمة الخصم',
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                      AppText(
                        isPercent
                            ? "${coupon.percent}%"
                            : "${coupon.value} ل.س",
                        style: TextStyle(
                          color: Color(0xff064E3B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.42,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        "الحد الأدنى للطلب",
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                      AppText(
                        "${coupon.minOrderAmount} ل.س",
                        style: TextStyle(
                          color: Color(0xff064E3B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.42,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        "عدد الاستخدامات",
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                      AppText(
                        "${coupon.usedCount} / ${coupon.usageLimit}",
                        style: TextStyle(
                          color: Color(0xff064E3B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.42,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AppText(
                        "مدة العرض",
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                      AppText(
                        DateFormat.yMMMMd('ar_SA').format(
                          DateTime.tryParse(coupon.endsAt ?? "") ??
                              DateTime(2025),
                        ),
                        style: TextStyle(
                          color: Color(0xff064E3B),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          height: 1.42,
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

  _CouponStatus get status {
    final DateTime endAt =
        DateTime.tryParse(coupon.endsAt ?? "") ?? DateTime(2025);
    final bool isEnded = DateTime.now().difference(endAt).inMilliseconds > 0;

    if (isEnded) {
      return statuses[2];
    } else if (coupon.isActive ?? false) {
      return statuses[0];
    }
    return statuses[1];
  }

  bool get isPercent => coupon.type == "percent";
}
