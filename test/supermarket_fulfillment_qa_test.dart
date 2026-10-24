import 'package:flutter_test/flutter_test.dart';
import 'package:dllni_supermarket_owner_app/features/orders/data/models/supermarket_fulfillment.dart';
import 'package:dllni_supermarket_owner_app/features/orders/data/models/get_order_details_model.dart';
import 'package:dllni_supermarket_owner_app/features/orders/data/models/get_orders_model.dart';

void main() {
  test('timing immediate_pickup must never imply customer pickup', () {
    expect(
      supermarketFulfillmentLabel('delivery', 49, 'immediate_pickup'),
      'توصيل فوري',
    );
    expect(
      supermarketFulfillmentLabel('pickup', null, 'immediate_pickup'),
      'استلام فوري من المتجر',
    );
    expect(isSupermarketDelivery(null, 49), isTrue);
    expect(isSupermarketDelivery(null, null), isFalse);
  });

  test('delivery relationship from API is parsed by order detail and list', () {
    final json = {
      'id': 49,
      'fulfillmentType': 'delivery',
      'deliveryOrderId': 27,
      'pickupMode': 'immediate_pickup',
      'deliveryDriverId': 81,
    };
    final detail = GetOrderDetailsModelData.fromJson(json);
    final listed = GetOrdersModelDataItem.fromJson(json);
    expect(
      isSupermarketDelivery(detail.fulfillmentType, detail.deliveryOrderId),
      true,
    );
    expect(listed.fulfillmentType, 'delivery');
    expect(listed.deliveryOrderId, 27);
    expect(detail.deliveryDriverId, 81);
  });
}
