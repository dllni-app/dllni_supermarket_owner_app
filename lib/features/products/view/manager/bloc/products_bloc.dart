import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import 'package:common_package/helpers/droppable_helper.dart';
import '../../../domain/usecases/get_products_use_case.dart';
import '../../../data/models/get_products_model.dart';
import '../../../domain/usecases/get_categories_use_case.dart';
import '../../../data/models/get_categories_model.dart';
import '../../../domain/usecases/get_low_stock_use_case.dart';
import '../../../data/models/get_low_stock_model.dart';

part 'products_event.dart';
part 'products_state.dart';

@injectable
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetLowStockUseCase getLowStockUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductsUseCase getProductsUseCase;
  ProductsBloc(
    this.getProductsUseCase,
    this.getCategoriesUseCase,
    this.getLowStockUseCase,
  ) : super(ProductsState()) {
    on<GetProductsEvent>(_getProducts, transformer: droppableProMax());
    on<GetCategoriesEvent>(_getCategories, transformer: droppableProMax());
    on<GetLowStockEvent>(_getLowStock);
  }

  EventTransformer<T> droppableProMax<T extends EventWithReload>() {
    return (events, mapper) {
      return events.transform(ExhaustMapStreamTransformer(mapper));
    };
  }

  FutureOr<void> _getProducts(
    GetProductsEvent event,
    Emitter<ProductsState> emit,
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
            state.copyWith(products: state.products!.setSuccess(data: r.data!)),
          );
        },
      );
    }
  }

  FutureOr<void> _getCategories(
    GetCategoriesEvent event,
    Emitter<ProductsState> emit,
  ) async {
    if (!state.categories!.isEndPage || event.isReload) {
      emit(
        state.copyWith(
          categories: state.categories!.setLoading(isReload: event.isReload),
        ),
      );
      final res = await getCategoriesUseCase(event.params);
      res.fold(
        (l) {
          emit(
            state.copyWith(
              categories: state.categories!.setFaild(errorMessage: l.message),
              errorMessage: l.message,
            ),
          );
        },
        (r) {
          emit(
            state.copyWith(
              categories: state.categories!.setSuccess(data: r.data!),
            ),
          );
        },
      );
    }
  }

  FutureOr<void> _getLowStock(
    GetLowStockEvent event,
    Emitter<ProductsState> emit,
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
        emit(state.copyWith(lowStockStatus: BlocStatus.success, lowStock: r));
      },
    );
  }
}
