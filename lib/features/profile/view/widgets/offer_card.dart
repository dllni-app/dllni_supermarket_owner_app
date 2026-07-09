import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../data/models/get_offer_codes_model.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});
  final GetOfferCodesModelDataItem offer;
  static const List<_OfferStatus> statuses = [
    _OfferStatus(label: "نشط", color: Color(0xff10B981)),
    _OfferStatus(label: "معطل", color: Color(0xffF59E0B)),
    _OfferStatus(label: "منتهي", color: Color(0xff9CA3AF)),
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
                      AppText(
                        offer.name.toString(),
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
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
                                  ? Color(0x1C1E2A78)
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
                                    ? AppColors.primary
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
                            ? "${offer.discountPercent}%"
                            : "${offer.discountValue} ل.س",
                        style: TextStyle(
                          color: Color(0xff111827),
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
                        "${DateFormat.MMMMd('ar_SA').format(DateTime.tryParse(offer.startsAt ?? "") ?? DateTime(2025))} - ${DateFormat.MMMMd('ar_SA').format(DateTime.tryParse(offer.endsAt ?? "") ?? DateTime(2025))}",
                        style: TextStyle(
                          color: Color(0xff111827),
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
                        "المنتجات المرتبطة",
                        style: TextStyle(
                          color: Color(0xff4B5563),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                      AppText(
                        "8 منتجات",
                        style: TextStyle(
                          color: Color(0xff111827),
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
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Color(0xFFF3F4F6)),
              ),
              child: Row(
                children: [
                  Icon(
                    FontAwesomeIcons.receipt.data,
                    size: 14,
                    color: Color(0xFF9CA3AF),
                  ),
                  SizedBox(width: 8),
                  AppText(
                    "طلبات مستفيدة",
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 12,
                      height: 1.333,
                    ),
                  ),
                  Spacer(),
                  AppText(
                    "142 طلب",
                    style: TextStyle(
                      color: Color(0xFF10B981),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _OfferStatus get status {
    final DateTime endAt =
        DateTime.tryParse(offer.endsAt ?? "") ?? DateTime(2025);
    final bool isEnded = DateTime.now().difference(endAt).inMilliseconds > 0;

    if (isEnded) {
      return statuses[2];
    } else if (offer.isActive ?? false) {
      return statuses[0];
    }
    return statuses[1];
  }

  bool get isPercent => offer.offerType == "percentage";
}

class _OfferStatus {
  final String label;
  final Color color;

  const _OfferStatus({required this.label, required this.color});
}
