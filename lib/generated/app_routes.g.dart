// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'package:dllni_supermarket_owner_app/features/auth/view/screens/login_screen.dart';
import 'package:dllni_supermarket_owner_app/features/main_page.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_new_product_screen.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/screens/add_product_ai_screen.dart';

class GeneratedAppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/login':
        return MaterialPageRoute(
          builder: (_) => LoginScreen(),
          settings: settings,
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => MainPage(),
          settings: settings,
        );
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
