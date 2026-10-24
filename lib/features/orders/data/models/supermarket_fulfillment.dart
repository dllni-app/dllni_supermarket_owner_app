/// Fulfillment type and timing are independent concepts in the API.
/// pickupMode == immediate_pickup describes timing, NOT customer pickup.
bool isSupermarketDelivery(String? fulfillmentType, int? deliveryOrderId) {
  final type = fulfillmentType?.trim().toLowerCase();
  if (type == 'delivery') return true;
  if (type == 'pickup') return false;
  return deliveryOrderId != null;
}

String supermarketFulfillmentLabel(
  String? fulfillmentType,
  int? deliveryOrderId,
  String? pickupMode,
) {
  final scheduled = (pickupMode ?? '').toLowerCase().contains('scheduled');
  if (isSupermarketDelivery(fulfillmentType, deliveryOrderId)) {
    return scheduled ? 'توصيل مجدول' : 'توصيل فوري';
  }
  return scheduled ? 'استلام مجدول من المتجر' : 'استلام فوري من المتجر';
}
