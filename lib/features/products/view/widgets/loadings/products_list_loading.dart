import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../data/models/get_products_model.dart';
import '../product_card.dart';

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: 3,
        itemBuilder: (context, index) => ProductCard(
          product: GetProductsModelDataItem.fromJson({
            "id": 1,
            "storeId": 1,
            "categoryId": 1,
            "masterProductId": 1,
            "name": "حليب كامل الدسم 1 لتر",
            "barcode": null,
            "sourceType": "manual",
            "description": null,
            "price": "6.00",
            "discountedPrice": null,
            "stockQuantity": 11,
            "lowStockThreshold": 10,
            "expiresAt": null,
            "isAvailable": true,
            "createdAt": "2026-02-27 03:38:03",
            "updatedAt": "2026-02-27 03:38:03",
          }),
        ),
      ),
    );
  }
}
