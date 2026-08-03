import 'package:flutter/material.dart';

import '../../generated/app_routes.g.dart';
import '../../features/main_page.dart';
import '../helpers/seller_permission_access.dart';

class AppRouter {
  const AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final access = SellerPermissionAccess.current();
    final requiredPermission = _requiredPermission(settings.name);

    if (requiredPermission != null && !access.can(requiredPermission)) {
      return _permissionDeniedRoute(settings);
    }

    if (_isOwnerOnlyRoute(settings.name) && !access.hasFullAccess) {
      return _permissionDeniedRoute(settings);
    }

    return GeneratedAppRoutes.onGenerateRoute(settings);
  }

  static String? _requiredPermission(String? routeName) {
    if (routeName == '/orders/order_details') {
      return SupermarketPermissionCodes.orders;
    }

    if (routeName?.startsWith('/products/') ?? false) {
      return SupermarketPermissionCodes.products;
    }

    if (routeName?.startsWith('/coupons_management') ?? false) {
      return SupermarketPermissionCodes.offersAndCoupons;
    }

    if (routeName == '/offers_management' || routeName == '/create_offer') {
      return SupermarketPermissionCodes.offersAndCoupons;
    }

    if (routeName?.startsWith('/profile/employees') ?? false) {
      return SupermarketPermissionCodes.employees;
    }

    if (routeName == '/profile' || routeName == '/workingtime') {
      return SupermarketPermissionCodes.storeData;
    }

    return null;
  }

  static bool _isOwnerOnlyRoute(String? routeName) {
    return routeName == '/performance_report';
  }

  static Route<dynamic> _permissionDeniedRoute(RouteSettings settings) {
    return MaterialPageRoute(
      settings: settings,
      builder: (context) => Scaffold(
        appBar: AppBar(title: const Text('غير مصرح')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline, size: 48),
                const SizedBox(height: 16),
                const Text(
                  'ليس لديك صلاحية للوصول إلى هذه الصفحة.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const MainPage()),
                      (_) => false,
                    );
                  },
                  child: const Text('العودة إلى الرئيسية'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
