part of 'products_bloc.dart';

abstract class ProductsEvent {}

class GetLowStockEvent extends ProductsEvent {
  final GetLowStockParams params;

  GetLowStockEvent({required this.params});
}

class GetCategoriesEvent extends ProductsEvent with EventWithReload {
  final GetCategoriesParams params;

  @override
  final bool isReload;
  GetCategoriesEvent({required this.params, this.isReload = false});
}

class GetProductsEvent extends ProductsEvent with EventWithReload {
  final GetProductsParams params;

  @override
  final bool isReload;

  GetProductsEvent({required this.params, this.isReload = false});
}

class TotalProducstCountEvent extends ProductsEvent {
  final TotalProducstCountParams params;

  TotalProducstCountEvent({required this.params});
}
