part of 'products_bloc.dart';

class ProductsState {
  BlocStatus? productFromTextStatus;
  GetProductFromTextModel? productFromText;
  BlocStatus? productFromImageStatus;
  GetProductFromImageModel? productFromImage;
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
    this.productFromImage,
    this.productFromImageStatus,

    this.productFromText,
    this.productFromTextStatus,
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
    GetProductFromImageModel? productFromImage,
    BlocStatus? productFromImageStatus,
    GetProductFromTextModel? productFromText,
    BlocStatus? productFromTextStatus,
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
    productFromImage: productFromImage ?? this.productFromImage,
    productFromImageStatus:
        productFromImageStatus ?? this.productFromImageStatus,
        productFromText: productFromText ?? this.productFromText,
        productFromTextStatus: productFromTextStatus ?? this.productFromTextStatus,);
}
