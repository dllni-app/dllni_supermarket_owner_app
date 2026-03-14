part of 'inventory_bloc.dart';

abstract class InventoryEvent {}

class GetProductsEvent extends InventoryEvent {
  final GetProductsParams params;

  GetProductsEvent({required this.params});
}

class UpdateProductAmountEvent extends InventoryEvent {
  final UpdateProductAmountParams params;

  UpdateProductAmountEvent({required this.params});
}

class GetHourlyCountEvent extends InventoryEvent {
  final GetHourlyCountParams params;

  GetHourlyCountEvent({required this.params});
}
