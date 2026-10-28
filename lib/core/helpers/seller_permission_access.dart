import 'dart:convert';

import 'package:common_package/common_package.dart';

abstract final class SupermarketPermissionCodes {
  static const String products = 'so.products';
  static const String offersAndCoupons = 'so.offers_coupons';
  static const String orders = 'so.orders';
  static const String employees = 'so.staff_register';
  static const String storeData = 'so.store_hours';
  static const String warehouse = 'so.warehouse';
}

final class SellerPermissionAccess {
  const SellerPermissionAccess._({
    required this.permissions,
    required this.isOwner,
    required this.hasExplicitPermissions,
  });

  final Set<String> permissions;
  final bool isOwner;
  final bool hasExplicitPermissions;

  // An absent or malformed permission payload must never grant staff full access.
  bool get hasFullAccess => isOwner;

  factory SellerPermissionAccess.current() {
    final rawSession = SharedPreferencesHelper.getData(key: 'user');
    final session = _decodeSession(rawSession);

    if (session == null) {
      return const SellerPermissionAccess._(
        permissions: <String>{},
        isOwner: false,
        hasExplicitPermissions: false,
      );
    }

    final role = session['role'];
    final roleSlug = role is Map ? role['slug']?.toString() : null;
    final rawPermissions = session['permissions'];
    final hasExplicitPermissions = rawPermissions is List;
    final permissions = <String>{};

    if (rawPermissions is List) {
      for (final item in rawPermissions) {
        if (item is Map && item['name'] != null) {
          permissions.add(item['name'].toString());
        }
      }
    }

    return SellerPermissionAccess._(
      permissions: permissions,
      isOwner: roleSlug == 'owner',
      hasExplicitPermissions: hasExplicitPermissions,
    );
  }

  bool can(String permission) {
    return hasFullAccess || permissions.contains(permission);
  }

  static Map<String, dynamic>? _decodeSession(dynamic rawSession) {
    try {
      if (rawSession is String) {
        final decoded = jsonDecode(rawSession);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      }

      if (rawSession is Map) {
        return Map<String, dynamic>.from(rawSession);
      }
    } catch (_) {
      return null;
    }

    return null;
  }
}
