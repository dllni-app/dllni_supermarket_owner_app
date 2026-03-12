part of 'products_bloc.dart';

abstract class ProductsEvent {}

class GetLowStockEvent extends ProductsEvent {
  final GetLowStockParams params;

  GetLowStockEvent({required this.params});
}

class GetProductsEvent extends ProductsEvent with EventWithReload {
  final GetProductsParams params;

  @override
  final bool isReload;

  GetProductsEvent({required this.params, this.isReload = false});
}

class TotalProductsCountEvent extends ProductsEvent {
  final TotalProductsCountParams params;

  TotalProductsCountEvent({required this.params});
}

class GetCategoriesEvent extends ProductsEvent {
  final GetCategoriesParams params;

  GetCategoriesEvent({required this.params});
}
