part of 'products_bloc.dart';

const Object _catalogMasterSearchIndexUnset = Object();

class ProductsState {
  BlocStatus? importProductsFromMasterStatus;
  ImportProductsFromMasterModel? importProductsFromMaster;
  BlocStatus? importProductsFileStatus;
  ImportProductsFileModel? importProductsFile;
  BlocStatus? productStatus;
  UpdateProductModel? product;
  BlocStatus? deleteProductStatus;
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
  PaginationStateModel<SearchMasterProductsDataItem>? catalogMasterProducts;
  String? catalogMasterSearchIndex;
  BlocStatus? lowStockStatus;
  GetLowStockModel? lowStock;
  String? errorMessage;

  ProductsState({
    this.importProductsFromMaster,
    this.importProductsFromMasterStatus,
    this.errorMessage,
    this.productsStatus,
    this.products = const PaginationStateModel(perPage: 10),
    this.catalogMasterProducts = const PaginationStateModel(perPage: 10),
    this.catalogMasterSearchIndex,
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
    this.deleteProductStatus,
    this.product,
    this.productStatus,
    this.importProductsFile,
    this.importProductsFileStatus,
  });

  ProductsState copyWith({
    ImportProductsFromMasterModel? importProductsFromMaster,
    BlocStatus? importProductsFromMasterStatus,
    String? errorMessage,
    BlocStatus? allProductsStatus,
    GetLowStockModel? lowStock,
    BlocStatus? lowStockStatus,
    PaginationStateModel<GetProductsModelDataItem>? products,
    PaginationStateModel<SearchMasterProductsDataItem>? catalogMasterProducts,
    Object? catalogMasterSearchIndex = _catalogMasterSearchIndexUnset,
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
    BlocStatus? deleteProductStatus,
    UpdateProductModel? product,
    BlocStatus? productStatus,
    ImportProductsFileModel? importProductsFile,
    BlocStatus? importProductsFileStatus,
  }) => ProductsState(
    importProductsFromMaster:
        importProductsFromMaster ?? this.importProductsFromMaster,
    importProductsFromMasterStatus:
        importProductsFromMasterStatus ?? this.importProductsFromMasterStatus,
    errorMessage: errorMessage ?? this.errorMessage,
    productsStatus: allProductsStatus ?? productsStatus,
    lowStock: lowStock ?? this.lowStock,
    lowStockStatus: lowStockStatus ?? this.lowStockStatus,
    products: products ?? this.products,
    catalogMasterProducts: catalogMasterProducts ?? this.catalogMasterProducts,
    catalogMasterSearchIndex:
        catalogMasterSearchIndex == _catalogMasterSearchIndexUnset
        ? this.catalogMasterSearchIndex
        : catalogMasterSearchIndex as String?,
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
    deleteProductStatus: deleteProductStatus ?? this.deleteProductStatus,
    product: product ?? this.product,
    productStatus: productStatus ?? this.productStatus,
    importProductsFile: importProductsFile ?? this.importProductsFile,
    importProductsFileStatus:
        importProductsFileStatus ?? this.importProductsFileStatus,
  );
}
