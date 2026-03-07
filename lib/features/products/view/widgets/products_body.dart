import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_svgs.dart';
import '../../data/models/get_products_model.dart';
import 'big_button_with_icon.dart';
import 'product_card.dart';
import 'products_tab_bar.dart';
import 'state_pointer.dart';

class ProductsBody extends StatelessWidget {
  const ProductsBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: context.width,
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
        Padding(
          padding: EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Row(
            spacing: 12,
            children: [
              Expanded(
                child: StatePointer(title: "إجمالي المنتجات النشطة", value: 7),
              ),
              Expanded(
                child: StatePointer(
                  isCritical: true,
                  title: "منخفض المخزون",
                  value: 4,
                ),
              ),
              // TODO: uncomment this block when you start link with api
              // Expanded(
              //   child: BlocBuilder<ProductsBloc, ProductsState>(
              //     buildWhen: (previous, current) =>
              //         previous.lowStockStatus != current.lowStockStatus,
              //     builder: (context, state) {
              //       switch (state.lowStockStatus) {
              //         case BlocStatus.loading:
              //           return StatePointerLoading();
              //         case BlocStatus.success:
              //           return StatePointer(
              //             isCritical: true,
              //             title: "منخفض المخزون",
              //             value: state.lowStock?.data?.total ?? 0,
              //           );
              //         default:
              //           return SizedBox();
              //       }
              //     },
              //   ),
              // ),
            ],
          ),
        ),
        ProductsTabBar(
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
        // TODO: uncomment this block when you start link with api
        // Expanded(
        //   child: BlocBuilder<ProductsBloc, ProductsState>(
        //     buildWhen: (previous, current) =>
        //         previous.products != current.products,
        //     builder: (context, state) {
        //       return state.products!.builder(
        //         loadingWidget: ProductsLoading(),
        //         emptyWidget: AppText.labelMedium(
        //           'لا يوجد مهام',
        //           fontWeight: FontWeight.w400,
        //         ),
        //         successWidget: () {
        //           return ListView.separated(
        //             padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
        //             itemBuilder: (context, index) {
        //               if (state.products!.length <= index) {
        //                 log(index.toString());
        //                 if (state.products!.length == index) {
        //                   context.read<ProductsBloc>().add(
        //                     GetProductsEvent(
        //                       isReload: false,
        //                       params: GetProductsParams(
        //                         page: state.products!.pageNumber,
        //                       ),
        //                     ),
        //                   );
        //                 }
        //                 return SizedBox(
        //                   width: 30,
        //                   height: 30,
        //                   child: FittedBox(
        //                     child: CircularProgressIndicator.adaptive(
        //                       strokeWidth: 3,
        //                     ),
        //                   ),
        //                 );
        //               }
        //               return ProductCard(product: state.products!.list[index]);
        //             },
        //             separatorBuilder: (context, index) => SizedBox(height: 16),
        //             itemCount: state.products!.listLength(1),
        //           );
        //         },
        //         onTapRetry: () {
        //           context.read<ProductsBloc>().add(
        //             GetProductsEvent(
        //               params: GetProductsParams(page: 1),
        //               isReload: true,
        //             ),
        //           );
        //         },
        //       );
        //     },
        //   ),
        // ),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
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
                "stockQuantity": index == 0
                    ? 11
                    : index == 1
                    ? 5
                    : 0,
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
