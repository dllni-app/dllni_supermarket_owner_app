import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/data/models/get_all_products_model.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_svgs.dart';
import 'big_button_with_icon.dart';
import 'product_card.dart';
import 'products_tab_bar.dart';
import 'state_pointer.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: BigButtonWithIcon(
              icon: AppImage.asset(AppSvgs.add, size: 22),
              title: "إضافة منتج جديد",
              onPressed: () {
                context.pushRoute("/products/new_product");
              },
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Expanded(
                  child: StatePointer(
                    title: "إجمالي المنتجات النشطة",
                    value: 142,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(child: StatePointer(title: "منخفض المخزون", value: 8)),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
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
        ),
        SliverList.builder(
          itemCount: 5,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsetsGeometry.fromLTRB(20, 0, 20, 16),
            child: ProductCard(
              product: GetAllProductsModelDataItem.fromJson({
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
        ),
      ],
    );
  }
}
