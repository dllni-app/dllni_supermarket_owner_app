// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'package:dllni_supermarket_owner_app/features/auth/view/screens/login_screen.dart';
import 'package:dllni_supermarket_owner_app/features/home/view/screens/notification_screen.dart';
import 'package:dllni_supermarket_owner_app/features/home/view/screens/performance_report_screen.dart';
import 'package:dllni_supermarket_owner_app/features/main_page.dart';
import 'package:dllni_supermarket_owner_app/features/orders/view/screens/order_details_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_new_product_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_product_ai_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_product_details_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_product_menu_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/search_from_catalog_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/coupons_management_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/create_coupon_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/create_new_employee_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/create_offer_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/employee_activity_log_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/employee_management_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/offers_management_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/profile_screen.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/working_time_screen.dart';

import '../features/profile/data/models/get_store_employees_model.dart';

class GeneratedAppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case '/notification_screen':
        return MaterialPageRoute(
          builder: (_) => NotificationsScreen(),
          settings: settings,
        );
      case '/performance_report':
        return MaterialPageRoute(
          builder: (_) => PerformanceReportScreen(),
          settings: settings,
        );
      case '/':
        if (args is int?) {
          return MaterialPageRoute(
            builder: (_) => MainPage(initialPage: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      case '/orders/order_details':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(orderId: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      case '/products/new_product':
        return MaterialPageRoute(
          builder: (_) => AddNewProductScreen(),
          settings: settings,
        );
      case '/products/new_product/ai':
        return MaterialPageRoute(
          builder: (_) => AddProductAIScreen(),
          settings: settings,
        );
      case '/products/new_product/details':
        if (args is AddProductDetailsParams?) {
          return MaterialPageRoute(
            builder: (_) => AddProductDetailsScreen(params: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      case '/products/new_product/menu':
        if (args is UploadFileType?) {
          return MaterialPageRoute(
            builder: (_) => AddProductMenuScreen(type: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      case '/products/new_product/catalog':
        return MaterialPageRoute(
          builder: (_) => SearchFromCatalogScreen(),
          settings: settings,
        );
      case '/coupons_management':
        return MaterialPageRoute(
          builder: (_) => CouponsManagementScreen(),
          settings: settings,
        );
      case '/coupons_management/new':
        return MaterialPageRoute(
          builder: (_) => CreateCouponScreen(),
          settings: settings,
        );
      case '/profile/employees/create_employee':
        if (args is GetStoreEmployeesModelDataEmployeesItem?) {
          return MaterialPageRoute(
            builder: (_) => CreateNewEmployeeScreen(params: args),
            settings: settings,
          );
        }
        return _errorRoute(settings);
      case '/create_offer':
        return MaterialPageRoute(
          builder: (_) => CreateOfferScreen(),
          settings: settings,
        );
      case '/profile/employees/activity_log':
        return MaterialPageRoute(
          builder: (_) => EmployeeActivityLogScreen(),
          settings: settings,
        );
      case '/profile/employees':
        return MaterialPageRoute(
          builder: (_) => EmployeeManagementScreen(),
          settings: settings,
        );
      case '/offers_management':
        return MaterialPageRoute(
          builder: (_) => OffersManagementScreen(),
          settings: settings,
        );
      case '/profile':
        return MaterialPageRoute(
          builder: (_) => ProfileScreen(),
          settings: settings,
        );
      case '/workingtime':
        return MaterialPageRoute(
          builder: (_) => WorkingTimeScreen(),
          settings: settings,
        );

    }

    return null;
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('Route Error')),
      ),
      settings: settings,
    );
  }
}
