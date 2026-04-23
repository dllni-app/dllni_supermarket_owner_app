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

class GetProductFromImageEvent extends ProductsEvent {
  final GetProductFromImageParams params;

  GetProductFromImageEvent({required this.params});
}

class GetProductFromTextEvent extends ProductsEvent {
  final GetProductFromTextParams params;

  GetProductFromTextEvent({required this.params});
}

class AddProductEvent extends ProductsEvent {
  final AddProductParams params;

  AddProductEvent({required this.params});
}

class UpdateProductEvent extends ProductsEvent {
  final UpdateProductParams params;

  UpdateProductEvent({required this.params});
}

class DeleteProductEvent extends ProductsEvent {
  final DeleteProductParams params;

  DeleteProductEvent({required this.params});
}

class ResetDeleteProductEvent extends ProductsEvent {}

class ImportProductsFileEvent extends ProductsEvent {
  final ImportProductsFileParams params;

  ImportProductsFileEvent({required this.params});
}

class FetchMasterProductsSearchEvent extends ProductsEvent
    with EventWithReload {
  @override
  final bool isReload;

  FetchMasterProductsSearchEvent({this.isReload = false});
}

class SearchMasterProductsSubmitted extends ProductsEvent {
  final String raw;

  SearchMasterProductsSubmitted(this.raw);
}

class ImportProductsFromMasterEvent extends ProductsEvent {
  final ImportProductsFromMasterParams params;

  ImportProductsFromMasterEvent({required this.params});
}
