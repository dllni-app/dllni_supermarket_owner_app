import 'dart:convert';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/helpers/seller_permission_access.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/create_new_employee_screen.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> mockSession(Map<String, dynamic> value) async {
  SharedPreferences.setMockInitialValues({});
  await SharedPreferencesHelper.init();
  await SharedPreferencesHelper.saveData(
    key: 'user',
    value: jsonEncode(value),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('missing or malformed staff permissions never grant full access', () async {
    await mockSession({'role': {'slug': 'employee'}});
    expect(SellerPermissionAccess.current().hasFullAccess, isFalse);
    expect(SellerPermissionAccess.current().can(SupermarketPermissionCodes.orders), isFalse);

    await mockSession({'role': {'slug': 'employee'}, 'permissions': 'invalid'});
    expect(SellerPermissionAccess.current().can(SupermarketPermissionCodes.products), isFalse);
  });

  test('staff can only access permissions explicitly assigned by backend', () async {
    await mockSession({
      'role': {'slug': 'employee'},
      'permissions': [
        {'name': SupermarketPermissionCodes.orders},
      ],
    });
    expect(SellerPermissionAccess.current().can(SupermarketPermissionCodes.orders), isTrue);
    expect(SellerPermissionAccess.current().can(SupermarketPermissionCodes.products), isFalse);
  });

  test('only owner has unrestricted access', () async {
    await mockSession({'role': {'slug': 'owner'}});
    expect(SellerPermissionAccess.current().hasFullAccess, isTrue);
  });

  test('permission labels are Arabic instead of raw technical identifiers', () {
    const codes = [
      SupermarketPermissionCodes.products,
      SupermarketPermissionCodes.offersAndCoupons,
      SupermarketPermissionCodes.orders,
      SupermarketPermissionCodes.employees,
      SupermarketPermissionCodes.storeData,
      SupermarketPermissionCodes.warehouse,
    ];
    for (final code in codes) {
      final details = getPermissionDetails(code);
      expect(details.title, isNot(contains('so.')));
      expect(details.title, isNotEmpty);
      expect(details.description, isNotEmpty);
    }
    expect(getPermissionDetails('so.unknown').title, 'صلاحية إضافية');
  });
}
