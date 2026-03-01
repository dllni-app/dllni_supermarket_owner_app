import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../products_tab_bar.dart';

class ProductsTabBarLoading extends StatelessWidget {
  const ProductsTabBarLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ProductsTabBar(
        items: [
          ProductsTabBarItem(title: "الكل", count: 154),
          ProductsTabBarItem(title: "دجاج", count: 34),
          ProductsTabBarItem(title: "لحم", count: 34),
          ProductsTabBarItem(title: "المقبلات", count: 50),
        ],
        onChanged: (index) {
          print(index);
        },
      ),
    );
  }
}
