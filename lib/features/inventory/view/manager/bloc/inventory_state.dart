part of 'inventory_bloc.dart';

class InventoryState {
  BlocStatus? hourlyCountStatus;
  GetHourlyCountModel? hourlyCount;
  BlocStatus? productAmountStatus;
  UpdateProductAmountModel? productAmount;
  BlocStatus? productsStatus;
  GetProductsModel? products;
  String? errorMessage;

  InventoryState({
    this.errorMessage,
    this.products,
    this.productsStatus,
    this.productAmount,
    this.productAmountStatus,
    this.hourlyCount,
    this.hourlyCountStatus,
  });

  InventoryState copyWith({
    String? errorMessage,
    GetProductsModel? products,
    BlocStatus? productsStatus,
    UpdateProductAmountModel? productAmount,
    BlocStatus? productAmountStatus,
    GetHourlyCountModel? hourlyCount,
    BlocStatus? hourlyCountStatus,
  }) => InventoryState(
    errorMessage: errorMessage ?? this.errorMessage,
    products: products ?? this.products,
    productsStatus: productsStatus ?? this.productsStatus,
    productAmount: productAmount ?? this.productAmount,
    productAmountStatus: productAmountStatus ?? this.productAmountStatus,
    hourlyCount: hourlyCount ?? this.hourlyCount,
    hourlyCountStatus: hourlyCountStatus ?? this.hourlyCountStatus,
  );
}
