import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/widgets/add_new_product_body.dart';
import 'package:flutter/material.dart';

import '../widgets/add_new_product_app_bar.dart';

@AutoRoutePage(path: "/products/new_product")
class AddNewProductScreen extends StatelessWidget {
  const AddNewProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AddNewProductAppBar(),
          Expanded(child: AddNewProductBody()),
        ],
      ),
    );
  }
}
