import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_low_stock_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../../domain/usecases/total_producst_count_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/big_button_with_icon.dart';
import '../widgets/loadings/products_list_loading.dart';
import '../widgets/loadings/products_tab_bar_loading.dart';
import '../widgets/loadings/state_pointer_loading.dart';
import '../widgets/product_card.dart';
import '../widgets/products_tab_bar.dart';
import '../widgets/state_pointer.dart';

// @AutoRoutePage(path: "/products")
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  int? selectedCategoryId;
  String? search;
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsBloc>()
        ..add(GetProductsEvent(params: GetProductsParams(page: 1)))
        ..add(GetCategoriesEvent(params: GetCategoriesParams()))
        ..add(TotalProductsCountEvent(params: TotalProductsCountParams()))
        ..add(GetLowStockEvent(params: GetLowStockParams(storeId: 1))),
      child: Scaffold(
        body: Column(
          children: [
            Builder(
              builder: (context) {
                print("rebuild appsimpleappbarwithsearch");
                return AppSimpleAppBarWithSearch(
                  title: "المنتجات",
                  onSearchChanged: (value) {
                    search = value;
                    context.read<ProductsBloc>().add(
                      GetProductsEvent(
                        isReload: true,
                        params: GetProductsParams(
                          page: 1,
                          categoryId: selectedCategoryId,
                          search: search,
                        ),
                      ),
                    );
                  },
                  onFilterTap: () {},
                );
              },
            ),
            Expanded(
              child: Column(
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
                          child: BlocBuilder<ProductsBloc, ProductsState>(
                            buildWhen: (previous, current) =>
                                previous.totalProductsCountStatus !=
                                current.totalProductsCountStatus,
                            builder: (context, state) {
                              switch (state.totalProductsCountStatus) {
                                case BlocStatus.loading:
                                  return StatePointerLoading();
                                case BlocStatus.success:
                                  return StatePointer(
                                    title: "إجمالي المنتجات النشطة",
                                    value: state.totalProductsCount?.count ?? 0,
                                  );
                                default:
                                  return SizedBox();
                              }
                            },
                          ),
                        ),
                        BlocBuilder<ProductsBloc, ProductsState>(
                          buildWhen: (previous, current) =>
                              previous.lowStockStatus != current.lowStockStatus,
                          builder: (context, state) {
                            switch (state.lowStockStatus) {
                              case BlocStatus.loading:
                                return StatePointerLoading();
                              case BlocStatus.success:
                                return Expanded(
                                  child: StatePointer(
                                    isCritical: true,
                                    title: "منخفض المخزون",
                                    value: state.lowStock?.data?.total ?? 0,
                                  ),
                                );
                              case BlocStatus.failed:
                                return Expanded(
                                  child: FailureWidget(
                                    message:
                                        state.errorMessage ?? "Unknown Error",
                                    onRetry: () {
                                      context.read<ProductsBloc>().add(
                                        GetLowStockEvent(
                                          params: GetLowStockParams(storeId: 1),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              default:
                                return SizedBox();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  BlocBuilder<ProductsBloc, ProductsState>(
                    builder: (context, state) {
                      print(state.categoriesStatus);
                      switch (state.categories) {
                        case null:
                          return ProductsTabBarLoading();
                        default:
                          return ProductsTabBar(
                            items: [
                              ProductsTabBarItem(
                                title: "الكل",
                                count:
                                    state.categories?.data?.fold<int>(
                                      0,
                                      (previousValue, element) =>
                                          previousValue +
                                          (element.productsCount ?? 0),
                                    ) ??
                                    0,
                              ),
                              ...state.categories!.data?.map(
                                    (category) => ProductsTabBarItem(
                                      title: category.name.toString(),
                                      count: category.productsCount ?? 0,
                                    ),
                                  ) ??
                                  [],
                              // ProductsTabBarItem(title: "دجاج", count: 34),
                              // ProductsTabBarItem(title: "لحم", count: 34),
                              // ProductsTabBarItem(title: "المقبلات", count: 50),
                            ],
                            onChanged: (index) {
                              if (index == 0) {
                                selectedCategoryId = null;
                              } else {
                                selectedCategoryId =
                                    state.categories?.data?[index - 1].id;
                              }
                              context.read<ProductsBloc>().add(
                                GetProductsEvent(
                                  isReload: true,
                                  params: GetProductsParams(
                                    page: 1,
                                    categoryId: selectedCategoryId,
                                    search: search,
                                  ),
                                ),
                              );
                            },
                          );
                        // case !null when state.categoriesStatus == BlocStatus.failed:
                        //   return ;
                        // default:
                        //   print("else");
                        //   return SizedBox();
                      }
                    },
                  ),
                  Expanded(
                    child: BlocBuilder<ProductsBloc, ProductsState>(
                      buildWhen: (previous, current) =>
                          previous.products != current.products,
                      builder: (context, state) {
                        return state.products!.builder(
                          loadingWidget: ProductsLoading(),
                          emptyWidget: AppText.labelMedium(
                            'لا يوجد منتجات',
                            fontWeight: FontWeight.w400,
                          ),
                          successWidget: () {
                            return ListView.separated(
                              padding: EdgeInsetsDirectional.symmetric(
                                horizontal: 24,
                              ),
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
                                return ProductCard(
                                  product: state.products!.list[index],
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  SizedBox(height: 16),
                              itemCount: state.products!.listLength(1),
                            );
                          },
                          failedWidget: Center(child: FailureWidget(message: state.errorMessage.toString(),onRetry: () {
                            context.read<ProductsBloc>().add(
                              GetProductsEvent(
                                params: GetProductsParams(categoryId: selectedCategoryId, search: search),
                                isReload: true,
                              ),
                            );
                          },),),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Expanded(
//   child: ListView.separated(
//     padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
//     separatorBuilder: (context, index) =>
//         SizedBox(height: 16),
//     itemCount: 3,
//     itemBuilder: (context, index) => ProductCard(
//       product: GetProductsModelDataItem.fromJson({
//         "id": 1,
//         "storeId": 1,
//         "categoryId": 1,
//         "masterProductId": 1,
//         "name": "حليب كامل الدسم 1 لتر",
//         "barcode": null,
//         "sourceType": "manual",
//         "description": null,
//         "price": "6.00",
//         "discountedPrice": null,
//         "stockQuantity": index == 0
//             ? 11
//             : index == 1
//             ? 5
//             : 0,
//         "lowStockThreshold": 10,
//         "expiresAt": null,
//         "isAvailable": true,
//         "createdAt": "2026-02-27 03:38:03",
//         "updatedAt": "2026-02-27 03:38:03",
//       }),
//     ),
//   ),
// ),
