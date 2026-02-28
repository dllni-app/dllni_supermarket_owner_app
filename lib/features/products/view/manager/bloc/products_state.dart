part of 'products_bloc.dart';

class ProductsState {
  BlocStatus? allProductsStatus;
  GetAllProductsModel? allProducts;
  String? errorMessage;

  ProductsState({
    this.errorMessage,
    this.allProducts,
    this.allProductsStatus,
  });

  ProductsState copyWith({
    String? errorMessage,
    GetAllProductsModel? allProducts,
    BlocStatus? allProductsStatus,
  }) =>
      ProductsState(
        errorMessage: errorMessage ?? this.errorMessage,
        allProducts: allProducts ?? this.allProducts,
        allProductsStatus: allProductsStatus ?? this.allProductsStatus,
      );}
