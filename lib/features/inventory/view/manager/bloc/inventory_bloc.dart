import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/common_package.dart';
import '../../../../products/data/models/get_low_stock_model.dart';
import '../../../../products/domain/usecases/get_low_stock_use_case.dart';
import '../../../domain/usecases/get_products_use_case.dart';
import '../../../domain/editing_type.dart';
import '../../../data/models/get_products_model.dart';
import '../../../domain/usecases/update_product_amount_use_case.dart';
import '../../../data/models/update_product_amount_model.dart';
import '../../../domain/usecases/get_hourly_count_use_case.dart';
import '../../../data/models/get_hourly_count_model.dart';
import '../../../domain/usecases/get_inventory_summary_use_case.dart';
import '../../../data/models/get_inventory_summary_model.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetHourlyCountUseCase getHourlyCountUseCase;
  final UpdateProductAmountUseCase updateProductAmountUseCase;
  final GetProductsUseCase getProductsUseCase;
  final GetInventorySummaryUseCase getInventorySummaryUseCase;
  final GetLowStockUseCase getLowStockUseCase;

  InventoryBloc(
    this.getProductsUseCase,
    this.updateProductAmountUseCase,
    this.getHourlyCountUseCase,
    this.getInventorySummaryUseCase,
    this.getLowStockUseCase,
  ) : super(InventoryState()) {
    on<GetProductsEvent>(_getProducts, transformer: droppableProMax());
    on<UpdateProductAmountEvent>(_updateProductAmount);
    on<GetHourlyCountEvent>(_getHourlyCount);
    on<GetInventorySummaryEvent>(_getInventorySummary);
    on<GetLowStockEvent>(_getLowStock);
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getProducts(
    GetProductsEvent event,
    Emitter<InventoryState> emit,
  ) async {
    if (!state.products!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          products: state.products!.setLoading(isReload: event.isReload),
        ),
      );
      final res = await getProductsUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              products: state.products!.setFaild(errorMessage: l.message),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              products: state.products!.setSuccess(
                data: r.data ?? <GetProductsModelDataItem>[],
                perPage: r.meta?.perPage,
              ),
            ),
          );
        },
      );
    }
  }

  PaginationStateModel<GetProductsModelDataItem>? _productsWithPatchedStock(
    PaginationStateModel<GetProductsModelDataItem>? current,
    UpdateProductAmountParams params,
  ) {
    if (current == null) return null;
    int newStock(int currentStock) {
      switch (params.operation) {
        case EditingType.increment:
          return currentStock + params.quantity;
        case EditingType.decrement:
          return currentStock - params.quantity;
        case EditingType.set:
          return params.quantity;
      }
    }

    final list = current.list.map((item) {
      if (item.id != params.productId) return item;
      final j = Map<String, dynamic>.from(item.toJson());
      j['stockQuantity'] = newStock(item.stockQuantity ?? 0);
      return GetProductsModelDataItem.fromJson(j);
    }).toList();
    return current.copyWith(list: list);
  }

  FutureOr<void> _updateProductAmount(
    UpdateProductAmountEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(productAmountStatus: BlocStatus.loading));
    final res = await updateProductAmountUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            productAmountStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            productAmountStatus: BlocStatus.success,
            productAmount: r,
            products: _productsWithPatchedStock(state.products, event.params),
          ),
        );
        add(GetLowStockEvent(params: GetLowStockParams()));
      },
    );
  }

  FutureOr<void> _getLowStock(
    GetLowStockEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(lowStockStatus: BlocStatus.loading));
    final res = await getLowStockUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            lowStockStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(lowStockStatus: BlocStatus.success, lowStock: r),
        );
      },
    );
  }

  FutureOr<void> _getHourlyCount(
    GetHourlyCountEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(hourlyCountStatus: BlocStatus.loading));
    final res = await getHourlyCountUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            hourlyCountStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(hourlyCountStatus: BlocStatus.success, hourlyCount: r),
        );
      },
    );
  }

  FutureOr<void> _getInventorySummary(
    GetInventorySummaryEvent event,
    Emitter<InventoryState> emit,
  ) async {
    emit(state.copyWith(inventorySummaryStatus: BlocStatus.loading));
    final res = await getInventorySummaryUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            inventorySummaryStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            inventorySummaryStatus: BlocStatus.success,
            inventorySummary: r,
          ),
        );
      },
    );
  }
}
