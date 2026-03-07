import 'package:flutter/material.dart';

import '../widgets/orders_app_bar.dart';
import '../widgets/orders_body.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      body: Column(
        children: const [
          OrdersAppBar(),
          Expanded(child: OrdersBody()),
        ],
      ),
    );
  }
}
