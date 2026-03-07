import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/products_app_bar.dart';
import '../widgets/products_body.dart';

// @AutoRoutePage(path: "/products")
class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsBloc>(),
        // ..add(GetProductsEvent(params: GetProductsParams(page: 1)))
        // ..add(GetCategoriesEvent(params: GetCategoriesParams()))
        // ..add(GetLowStockEvent(params: GetLowStockParams(storeId: 1))),
      child: Scaffold(
        body: Column(
          children: [
            ProductsAppBar(),
            Expanded(child: ProductsBody()),
          ],
        ),
      ),
    );
  }
}
