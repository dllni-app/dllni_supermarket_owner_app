import 'package:flutter/material.dart';

import '../widgets/products_app_bar.dart';
import '../widgets/products_body.dart';

// @AutoRoutePage(path: "/products")
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProductsAppBar(),
          Expanded(child: ProductsBody()),
        ],
      ),
    );
  }
}
