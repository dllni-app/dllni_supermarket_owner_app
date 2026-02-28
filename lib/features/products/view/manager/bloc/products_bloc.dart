import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'dart:async';
import 'package:common_package/helpers/pagination_helper.dart';
import '../../../domain/usecases/get_all_products_use_case.dart';
import '../../../data/models/get_all_products_model.dart';

part 'products_event.dart';
part 'products_state.dart';

@injectable
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetAllProductsUseCase getAllProductsUseCase;
  ProductsBloc(
    this.getAllProductsUseCase,
  ) : super(ProductsState()) {
    
  
    on<GetAllProductsEvent>(_getAllProducts);}


  FutureOr<void> _getAllProducts(GetAllProductsEvent event, Emitter<ProductsState> emit) async {
    emit(state.copyWith(allProductsStatus: BlocStatus.loading));
    
    final res = await getAllProductsUseCase(event.params);
    res.fold((l) {
      emit(state.copyWith(
        allProductsStatus: BlocStatus.failed,
        errorMessage: l.message,
      ));
    }, (r) {
      emit(state.copyWith(
        allProductsStatus: BlocStatus.success,
        allProducts: r,
      ));
    });
  }}
