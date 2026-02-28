import 'package:common_package/annotations/auto_route_page.dart';
import 'package:flutter/material.dart';

import '../widgets/add_new_product_app_bar.dart';
import '../widgets/add_product_ai_body.dart';

@AutoRoutePage(path: "/products/new_product/ai")
class AddProductAIScreen extends StatelessWidget {
  const AddProductAIScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AddNewProductAppBar(),
          Expanded(child: AddProductAIBody()),
        ],
      ),
    );
  }
}
