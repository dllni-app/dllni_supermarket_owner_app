part of 'inventory_bloc.dart';

class InventoryState {
  BlocStatus? invetoryCountsStatus;
  GetInvetoryCountsModel? invetoryCounts;
  BlocStatus? hourlyCountStatus;
  GetHourlyCountModel? hourlyCount;
  BlocStatus? productAmountStatus;
  UpdateProductAmountModel? productAmount;
  PaginationStateModel<GetProductsModelDataItem>? products;
  BlocStatus? inventorySummaryStatus;
  GetInventorySummaryModel? inventorySummary;
  GetLowStockModel? lowStock;
  BlocStatus? lowStockStatus;
  String? errorMessage;

  InventoryState({
    this.errorMessage,
    this.products = const PaginationStateModel(perPage: 10),
    this.productAmount,
    this.productAmountStatus,
    this.hourlyCount,
    this.hourlyCountStatus,
    this.inventorySummary,
    this.inventorySummaryStatus,
    this.lowStock,
    this.lowStockStatus,
    this.invetoryCounts,
    this.invetoryCountsStatus,
  });

  InventoryState copyWith({
    String? errorMessage,
    PaginationStateModel<GetProductsModelDataItem>? products,
    UpdateProductAmountModel? productAmount,
    BlocStatus? productAmountStatus,
    GetHourlyCountModel? hourlyCount,
    BlocStatus? hourlyCountStatus,
    GetInventorySummaryModel? inventorySummary,
    BlocStatus? inventorySummaryStatus,
    GetLowStockModel? lowStock,
    BlocStatus? lowStockStatus,
    GetInvetoryCountsModel? invetoryCounts,
    BlocStatus? invetoryCountsStatus,
  }) => InventoryState(
    errorMessage: errorMessage ?? this.errorMessage,
    products: products ?? this.products,
    productAmount: productAmount ?? this.productAmount,
    productAmountStatus: productAmountStatus ?? this.productAmountStatus,
    hourlyCount: hourlyCount ?? this.hourlyCount,
    hourlyCountStatus: hourlyCountStatus ?? this.hourlyCountStatus,
    inventorySummary: inventorySummary ?? this.inventorySummary,
    inventorySummaryStatus:
        inventorySummaryStatus ?? this.inventorySummaryStatus,
    lowStock: lowStock ?? this.lowStock,
    lowStockStatus: lowStockStatus ?? this.lowStockStatus,
        invetoryCounts: invetoryCounts ?? this.invetoryCounts,
        invetoryCountsStatus: invetoryCountsStatus ?? this.invetoryCountsStatus,);
}
