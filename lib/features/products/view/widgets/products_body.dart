import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import 'big_button_with_icon.dart';
import 'loadings/products_tab_bar_loading.dart';
import 'loadings/state_pointer_loading.dart';
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
            children: [
              // TODO: make [StatePointer] with Bloc
              Expanded(
                child: StatePointer(title: "إجمالي المنتجات النشطة", value: 7),
              ),
              SizedBox(width: 12),
              Expanded(
                child: BlocBuilder<ProductsBloc, ProductsState>(
                  buildWhen: (previous, current) =>
                      previous.lowStockStatus != current.lowStockStatus,
                  builder: (context, state) {
                    switch (state.lowStockStatus) {
                      case BlocStatus.loading:
                        return StatePointerLoading();
                      case BlocStatus.success:
                        return StatePointer(
                          isCritical: true,
                          title: "منخفض المخزون",
                          value: state.lowStock?.data?.total ?? 0,
                        );
                      default:
                        return SizedBox();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        ProductsTabBarLoading(),
        // BlocBuilder<ProductsBloc, ProductsState>(
        //   buildWhen: (previous, current) =>
        //       previous.categoriesStatus != current.categoriesStatus,
        //   builder: (context, state) {
        //     switch (state.categoriesStatus) {
        //       case BlocStatus.loading:
        //         return ProductsTabBarLoading();
        //       case BlocStatus.success:
        //         return ProductsTabBar(
        //           items: [
        //             ProductsTabBarItem(title: "الكل", count: 154),
        //             ...state.categories?.list
        //                     .map(
        //                       (category) => ProductsTabBarItem(
        //                         title: category.name ?? "Unknown",
        //                         count: 0,
        //                       ),
        //                     )
        //                     .toList() ??
        //                 [],
        //           ],
        //           onChanged: (index) {
        //             print(index);
        //           },
        //         );
        //       default:
        //         return SizedBox();
        //     }
        //   },
        // ),
        Expanded(
          child: BlocBuilder<ProductsBloc, ProductsState>(
            buildWhen: (previous, current) =>
                previous.products != current.products,
            builder: (context, state) {
              log(state.products?.length.toString() ?? "null");
              return state.products!.builder(
                loadingWidget: Padding(
                  padding: EdgeInsetsDirectional.only(top: 40),
                  child: Center(child: CircularProgressIndicator.adaptive()),
                ),
                emptyWidget: AppText.labelMedium(
                  'لا يوجد مهام',
                  fontWeight: FontWeight.w400,
                ),
                successWidget: () {
                  return ListView.separated(
                    padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
                    itemBuilder: (context, index) {
                      if (state.products!.length <= index) {
                        log(index.toString());
                        if (state.products!.length == index) {
                          context.read<ProductsBloc>().add(
                            GetProductsEvent(
                              isReload: false,
                              params: GetProductsParams(
                                page: state.products!.pageNumber,
                              ),
                            ),
                          );
                        }
                        return SizedBox(
                          width: 30,
                          height: 30,
                          child: FittedBox(
                            child: CircularProgressIndicator.adaptive(
                              strokeWidth: 3,
                            ),
                          ),
                        );
                      }
                      return ProductCard(product: state.products!.list[index]);
                    },
                    separatorBuilder: (context, index) => SizedBox(height: 16),
                    itemCount: state.products!.listLength(1),
                  );
                },
                onTapRetry: () {
                  context.read<ProductsBloc>().add(
                    GetProductsEvent(
                      params: GetProductsParams(page: 1),
                      isReload: true,
                    ),
                  );
                },
              );
            },
          ),
        ),
        // Expanded(
        //   child: BlocConsumer<ProductsBloc, ProductsState>(
        //     buildWhen: (previous, current) =>
        //         previous.allProductsStatus != current.allProductsStatus,
        //     listener: (context, state) {},
        //     builder: (context, state) {
        //       switch (state.allProductsStatus) {
        //         case BlocStatus.loading:
        //           return ProductsLoading();
        //         case BlocStatus.success:
        //           return ListView.separated(
        //             padding: EdgeInsets.symmetric(horizontal: 20),
        //             separatorBuilder: (context, index) => SizedBox(height: 16),
        //             itemCount: state.allProducts!.data!.length,
        //             itemBuilder: (context, index) =>
        //                 ProductCard(product: state.allProducts!.data![index]),
        //           );
        //         default:
        //           return SizedBox();
        //       }
        //     },
        //   ),
        // ),
      ],
    );
  }
}

// Expanded(
//               child: BlocBuilder<OrdersBloc, OrdersState>(
//                 buildWhen: (previous, current) => previous.ordersUsecase != current.ordersUsecase,
//                 builder: (context, state) {
//                   return state.ordersUsecase!.builder(
//                     loadingWidget: Padding(
//                       padding: EdgeInsetsDirectional.only(top: 40),
//                       child: Center(child: CircularProgressIndicator.adaptive()),
//                     ),
//                     emptyWidget: AppText.labelMedium('لا يوجد مهام', fontWeight: FontWeight.w400),
//                     successWidget: () {
//                       return ValueListenableBuilder(
//                         valueListenable: orderNotifier.status,
//                         builder: (context, status, _) => ListView.separated(
//                           padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
//                           itemBuilder: (context, index) {
//                             if (state.ordersUsecase!.length <= index) {
//                               if (state.ordersUsecase!.length == index) {
//                                 context.read<OrdersBloc>().add(
//                                   FetchOrdersUsecaseEvent(
//                                     isReload: false,
//                                     params: FetchOrdersUsecaseParams(page: state.ordersUsecase!.pageNumber, status: status),
//                                   ),
//                                 );
//                               }
//                               return SizedBox(width: 30, height: 30, child: FittedBox(child: CircularProgressIndicator.adaptive(strokeWidth: 3)));
//                             }
//                             return status != 'completed'
//                                 ? OrderCard(
//                                     date: state.ordersUsecase!.list[index],
//                                     orderStatus: status == 'worker_assigned' ? OrderStatus.workerAssigned : OrderStatus.inProgress,
//                                     bloc: context.read<OrdersBloc>(),
//                                   )
//                                 : CompletedOrderCard(date: state.ordersUsecase!.list[index]);
//                           },
//                           separatorBuilder: (context, index) => SizedBox(height: 16),
//                           itemCount: state.ordersUsecase!.listLength(1),
//                         ),
//                       );
//                     },
//                     onTapRetry: () {
//                       context.read<OrdersBloc>().add(
//                         FetchOrdersUsecaseEvent(params: FetchOrdersUsecaseParams(page: 1, status: 'worker_assigned'), isReload: true),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
