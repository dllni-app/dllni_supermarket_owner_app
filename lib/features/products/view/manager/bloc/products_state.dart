part of 'products_bloc.dart';

class ProductsState {
  BlocStatus? importProductsFileStatus;
  ImportProductsFileModel? importProductsFile;
  BlocStatus? productStatus;
  UpdateProductModel? product;
  BlocStatus? addProductStatus;
  AddProductModel? addProduct;
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
    this.addProduct,
    this.addProductStatus,
    this.product,
    this.productStatus,
    this.importProductsFile,
    this.importProductsFileStatus,
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
    AddProductModel? addProduct,
    BlocStatus? addProductStatus,
    UpdateProductModel? product,
    BlocStatus? productStatus,
    ImportProductsFileModel? importProductsFile,
    BlocStatus? importProductsFileStatus,
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
    productFromTextStatus: productFromTextStatus ?? this.productFromTextStatus,
    addProduct: addProduct ?? this.addProduct,
    addProductStatus: addProductStatus ?? this.addProductStatus,
    product: product ?? this.product,
    productStatus: productStatus ?? this.productStatus,
        importProductsFile: importProductsFile ?? this.importProductsFile,
        importProductsFileStatus: importProductsFileStatus ?? this.importProductsFileStatus,);

}
