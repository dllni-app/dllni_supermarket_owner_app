import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import '../../../domain/usecases/get_products_use_case.dart';
import '../../../data/models/get_products_model.dart';
import '../../../domain/usecases/update_product_amount_use_case.dart';
import '../../../data/models/update_product_amount_model.dart';
import '../../../domain/usecases/get_hourly_count_use_case.dart';
import '../../../data/models/get_hourly_count_model.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

@injectable
class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final GetHourlyCountUseCase getHourlyCountUseCase;
  final UpdateProductAmountUseCase updateProductAmountUseCase;
  final GetProductsUseCase getProductsUseCase;
  InventoryBloc(
    this.getProductsUseCase,
    this.updateProductAmountUseCase,
    this.getHourlyCountUseCase,) : super(InventoryState()) {
    
  
    on<GetProductsEvent>(_getProducts);
    on<UpdateProductAmountEvent>(_updateProductAmount);
    on<GetHourlyCountEvent>(_getHourlyCount);}


  FutureOr<void> _getProducts(GetProductsEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(productsStatus: BlocStatus.loading));
    final res = await getProductsUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        productsStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        productsStatus: BlocStatus.success,
        products: r,
      ));
    });
  }

  FutureOr<void> _updateProductAmount(UpdateProductAmountEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(productAmountStatus: BlocStatus.loading));
    final res = await updateProductAmountUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        productAmountStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        productAmountStatus: BlocStatus.success,
        productAmount: r,
      ));
    });
  }

  FutureOr<void> _getHourlyCount(GetHourlyCountEvent event, Emitter<InventoryState> emit) async {
    emit(state.copyWith(hourlyCountStatus: BlocStatus.loading));
    final res = await getHourlyCountUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        hourlyCountStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        hourlyCountStatus: BlocStatus.success,
        hourlyCount: r,
      ));
    });
  }}
