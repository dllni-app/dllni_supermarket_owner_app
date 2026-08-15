import 'package:flutter_test/flutter_test.dart';

import 'package:dllni_supermarket_owner_app/features/home/data/models/get_new_orders_model.dart';
import 'package:dllni_supermarket_owner_app/features/orders/data/models/get_orders_model.dart';

void main() {
  test('orders parser safely defaults null stock availability to false', () {
    final order = GetOrdersModelDataItem.fromJson({
      'items': [
        {'productName': 'Milk', 'isAvailableInStock': null},
        {'productName': 'Bread', 'isAvailableInStock': true},
      ],
    });

    expect(order.availableItems, [false, true]);
  });

  test('orders parsers accept common boolean response formats', () {
    final order = GetOrdersModelDataItem.fromJson({
      'items': [
        {'productName': 'Milk', 'isAvailableInStock': 1},
        {'productName': 'Bread', 'isAvailableInStock': 'false'},
      ],
    });
    final newOrder = GetNewOrdersModelDataItem.fromJson({
      'items': [
        {'productName': 'Milk', 'isAvailableInStock': '1'},
        {'productName': 'Bread', 'isAvailableInStock': 0},
      ],
    });

    expect(order.availableItems, [true, false]);
    expect(newOrder.availableItems, [true, false]);
  });
}
