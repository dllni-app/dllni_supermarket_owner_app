import 'dart:async';

import 'package:common_package/helpers/droppable_helper.dart';
import 'package:common_package/helpers/pagination_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../data/models/get_low_stock_model.dart';
import '../../../data/models/get_products_model.dart';
import '../../../data/models/total_producst_count_model.dart';
import '../../../domain/usecases/get_low_stock_use_case.dart';
import '../../../domain/usecases/get_products_use_case.dart';
import '../../../domain/usecases/total_producst_count_use_case.dart';
import '../../../domain/usecases/get_categories_use_case.dart';
import '../../../data/models/get_categories_model.dart';
import '../../../domain/usecases/get_product_from_image_use_case.dart';
import '../../../data/models/get_product_from_image_model.dart';
import '../../../domain/usecases/get_product_from_text_use_case.dart';
import '../../../data/models/get_product_from_text_model.dart';
import '../../../domain/usecases/add_product_use_case.dart';
import '../../../data/models/add_product_model.dart';

part 'products_event.dart';
part 'products_state.dart';

@injectable
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final AddProductUseCase addProductUseCase;
  final GetProductFromTextUseCase getProductFromTextUseCase;
  final GetProductFromImageUseCase getProductFromImageUseCase;
  final GetCategoriesUseCase getCategoriesUseCase;
  final TotalProducstCountUseCase totalProducstCountUseCase;
  final GetLowStockUseCase getLowStockUseCase;
  final GetProductsUseCase getProductsUseCase;
  ProductsBloc(
    this.getProductsUseCase,
    this.getLowStockUseCase,
    this.totalProducstCountUseCase,
    this.getCategoriesUseCase,
    this.getProductFromImageUseCase,
    this.getProductFromTextUseCase,
    this.addProductUseCase,) : super(ProductsState()) {
    on<GetProductsEvent>(_getProducts, transformer: droppableProMax());
    on<GetLowStockEvent>(_getLowStock);
    on<TotalProductsCountEvent>(_totalProducstCount);
    on<GetCategoriesEvent>(_getCategories);
    on<GetProductFromImageEvent>(_getProductFromImage);
    on<GetProductFromTextEvent>(_getProductFromText);
    on<AddProductEvent>(_addProduct);}

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

  FutureOr<void> _totalProducstCount(
    TotalProductsCountEvent event,
    Emitter<ProductsState> emit,
  ) async {
    emit(state.copyWith(totalProducstCountStatus: BlocStatus.loading));
    final res = await totalProducstCountUseCase(event.params);
    res.fold(
      (l) {
        emit(
          state.copyWith(
            totalProducstCountStatus: BlocStatus.failed,
            errorMessage: l.message,
          ),
        );
      },
      (r) {
        emit(
          state.copyWith(
            totalProducstCountStatus: BlocStatus.success,
            totalProducstCount: r,
          ),
        );
      },
    );
  }


  FutureOr<void> _getCategories(GetCategoriesEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(categoriesStatus: BlocStatus.loading));
    final res = await getCategoriesUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        categoriesStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        categoriesStatus: BlocStatus.success,
        categories: r,
      ));
    });
  }

  FutureOr<void> _getProductFromImage(GetProductFromImageEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(productFromImageStatus: BlocStatus.loading));
    final res = await getProductFromImageUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        productFromImageStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        productFromImageStatus: BlocStatus.success,
        productFromImage: r,
      ));
    });
  }

  FutureOr<void> _getProductFromText(GetProductFromTextEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(productFromTextStatus: BlocStatus.loading));
    final res = await getProductFromTextUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        productFromTextStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        productFromTextStatus: BlocStatus.success,
        productFromText: r,
      ));
    });
  }

  FutureOr<void> _addProduct(AddProductEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(addProductStatus: BlocStatus.loading));
    final res = await addProductUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        addProductStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        addProductStatus: BlocStatus.success,
        addProduct: r,
      ));
    });
  }}
