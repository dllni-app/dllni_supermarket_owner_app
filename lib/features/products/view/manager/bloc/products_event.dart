part of 'products_bloc.dart';

abstract class ProductsEvent {}

class GetAllProductsEvent extends ProductsEvent {
  final GetAllProductsParams params;

  GetAllProductsEvent({required this.params});
}
