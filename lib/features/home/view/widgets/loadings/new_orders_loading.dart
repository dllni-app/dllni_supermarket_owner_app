import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/get_new_orders_model.dart';
import '../new_orders_section.dart';

class NewOrdersLoading extends StatelessWidget {
  const NewOrdersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          NewOrderCard(
            order: GetNewOrdersModelDataItem.fromJson({
              "id": 1,
              "customerId": 20,
              "storeId": 1,
              "couponId": null,
              "cancellationPolicyId": 5,
              "orderNumber": "SM-IU3XEK-1-0",
              "status": "pending",
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
              "specialInstructions": "بدون أكياس بلاستيك إن أمكن",
              "cancelledAt": null,
              "cancellationReason": null,
              "createdAt": "2026-03-03 12:59:58",
              "updatedAt": "2026-03-03 12:59:58",
            }),
          ),
          SizedBox(height: 12),
          NewOrderCard(
            order: GetNewOrdersModelDataItem.fromJson({
              "id": 1,
              "customerId": 20,
              "storeId": 1,
              "couponId": null,
              "cancellationPolicyId": 5,
              "orderNumber": "SM-IU3XEK-1-0",
              "status": "pending",
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
              "specialInstructions": "بدون أكياس بلاستيك إن أمكن",
              "cancelledAt": null,
              "cancellationReason": null,
              "createdAt": "2026-03-03 12:59:58",
              "updatedAt": "2026-03-03 12:59:58",
            }),
          ),
        ],
      ),
    );
  }
}
