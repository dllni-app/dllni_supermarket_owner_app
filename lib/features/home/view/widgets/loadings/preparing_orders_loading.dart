import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../data/models/get_preparing_orders_model.dart';
import '../preparing_orders_section.dart';

class PreparingOrdersLoading extends StatelessWidget {
  const PreparingOrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFFF3F4F6)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 2),
              color: const Color(0x08000000),
            ),
          ],
        ),
        child: Column(
          children: List.generate(
            2,
            (index) => Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: index > 0
                    ? const Border(top: BorderSide(color: Color(0xFFF9FAFB)))
                    : null,
              ),
              child: PreparingOrderCard(
                order: GetPreparingOrdersModelDataItem.fromJson({
                  "id": 3,
                  "customerId": 20,
                  "storeId": 1,
                  "couponId": null,
                  "cancellationPolicyId": 5,
                  "orderNumber": "SM-8DKBUF-1-2",
                  "status": "preparing",
                  "pickupMode": "immediate_pickup",
                  "pickupScheduledFor": null,
                  "readyForPickupAt": null,
                  "pickedUpAt": null,
                  "customerPickupConfirmedAt": null,
                  "subtotal": "0.00",
                  "discountAmount": "0.00",
                  "serviceFee": "0.00",
                  "totalAmount": "0.00",
                  "cancellationFeeAmount": null,
                  "cancellationPolicySnapshot": null,
                  "specialInstructions": null,
                  "cancelledAt": null,
                  "cancellationReason": null,
                  "createdAt": "2026-03-03 12:59:58",
                  "updatedAt": "2026-03-03 12:59:58",
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
