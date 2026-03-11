part of 'products_bloc.dart';

class ProductsState {
  BlocStatus? totalProducstCountStatus;
  TotalProducstCountModel? totalProducstCount;
  BlocStatus? productsStatus;
  PaginationStateModel<GetProductsModelDataItem>? products;
  BlocStatus? categoriesStatus;
  PaginationStateModel<GetCategoriesModelDataItem>? categories;
  BlocStatus? lowStockStatus;
  GetLowStockModel? lowStock;
  String? errorMessage;

  ProductsState({
    this.errorMessage,
    this.productsStatus,
    this.products = const PaginationStateModel(perPage: 10),
    this.categories = const PaginationStateModel(perPage: 10),
    this.lowStock,
    this.lowStockStatus,
    this.categoriesStatus,
    this.totalProducstCount,
    this.totalProducstCountStatus,
  
  });

  ProductsState copyWith({
    String? errorMessage,
    BlocStatus? allProductsStatus,
    GetLowStockModel? lowStock,
    BlocStatus? lowStockStatus,
    PaginationStateModel<GetCategoriesModelDataItem>? categories,
    BlocStatus? categoriesStatus,
    PaginationStateModel<GetProductsModelDataItem>? products,
    TotalProducstCountModel? totalProducstCount,
    BlocStatus? totalProducstCountStatus,
  }) => ProductsState(
    errorMessage: errorMessage ?? this.errorMessage,
    productsStatus: allProductsStatus ?? this.productsStatus,
    lowStock: lowStock ?? this.lowStock,
    lowStockStatus: lowStockStatus ?? this.lowStockStatus,
    categories: categories ?? this.categories,
    categoriesStatus: categoriesStatus ?? this.categoriesStatus,
    products: products ?? this.products,
        totalProducstCount: totalProducstCount ?? this.totalProducstCount,
        totalProducstCountStatus: totalProducstCountStatus ?? this.totalProducstCountStatus,);


}