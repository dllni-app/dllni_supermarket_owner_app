part of 'inventory_bloc.dart';

abstract class InventoryEvent {}

class GetProductsEvent extends InventoryEvent with EventWithReload {
  final GetProductsParams params;

  @override
  final bool isReload;

  GetProductsEvent({required this.params, this.isReload = false});
}

class UpdateProductAmountEvent extends InventoryEvent {
  final UpdateProductAmountParams params;

  UpdateProductAmountEvent({required this.params});
}

class GetHourlyCountEvent extends InventoryEvent {
  final GetHourlyCountParams params;

  GetHourlyCountEvent({required this.params});
}

class GetInventorySummaryEvent extends InventoryEvent {
  final GetInventorySummaryParams params;

  GetInventorySummaryEvent({required this.params});
}

class GetLowStockEvent extends InventoryEvent {
  final GetLowStockParams params;

  GetLowStockEvent({required this.params});
}

class GetInvetoryCountsEvent extends InventoryEvent {
  final GetInvetoryCountsParams params;

  GetInvetoryCountsEvent({required this.params});
}
