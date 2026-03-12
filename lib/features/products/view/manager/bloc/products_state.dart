part of 'products_bloc.dart';

class ProductsState {
  BlocStatus? categoriesStatus;
  GetCategoriesModel? categories;
  BlocStatus? totalProductsCountStatus;
  TotalProducstCountModel? totalProductsCount;
  BlocStatus? productsStatus;
  PaginationStateModel<GetProductsModelDataItem>? products;
  BlocStatus? lowStockStatus;
  GetLowStockModel? lowStock;
  String? errorMessage;

  ProductsState({
    this.errorMessage,
    this.productsStatus,
    this.products = const PaginationStateModel(perPage: 10),
    this.lowStock,
    this.lowStockStatus,
    this.totalProductsCount,
    this.totalProductsCountStatus,
    this.categories,
    this.categoriesStatus,
  });

  ProductsState copyWith({
    String? errorMessage,
    BlocStatus? allProductsStatus,
    GetLowStockModel? lowStock,
    BlocStatus? lowStockStatus,
    PaginationStateModel<GetProductsModelDataItem>? products,
    TotalProducstCountModel? totalProducstCount,
    BlocStatus? totalProducstCountStatus,
    GetCategoriesModel? categories,
    BlocStatus? categoriesStatus,
  }) => ProductsState(
    errorMessage: errorMessage ?? this.errorMessage,
    productsStatus: allProductsStatus ?? productsStatus,
    lowStock: lowStock ?? this.lowStock,
    lowStockStatus: lowStockStatus ?? this.lowStockStatus,
    products: products ?? this.products,
    totalProductsCount: totalProducstCount ?? totalProductsCount,
    totalProductsCountStatus:
        totalProducstCountStatus ?? totalProductsCountStatus,
    categories: categories ?? this.categories,
    categoriesStatus: categoriesStatus ?? this.categoriesStatus,
  );
}
