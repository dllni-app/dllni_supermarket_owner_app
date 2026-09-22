import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_app_bars.dart';
import '../../../products/view/widgets/loadings/products_list_loading.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'create_offer_screen.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.selectedProducts});
  final List<GetProductsModelDataItem> selectedProducts;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  bool _isSelected(GetProductsModelDataItem product) {
    return widget.selectedProducts.any((item) => item.id == product.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "جميع المنتجات"),
          Expanded(
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.products != current.products,
              builder: (context, state) {
                return state.products!.builder(
                  loadingWidget: const ProductsLoading(),
                  emptyWidget: AppText.labelMedium(
                    'لا يوجد منتجات',
                    fontWeight: FontWeight.w400,
                  ),
                  successWidget: () {
                    return ListView.separated(
                      padding: EdgeInsetsDirectional.symmetric(
                        horizontal: 24,
                        vertical: 16,
                      ),
                      itemBuilder: (context, index) {
                        if (state.products!.length <= index) {
                          log(index.toString());
                          if (state.products!.length == index) {
                            context.read<ProfileBloc>().add(
                              GetProductsEvent(
                                isReload: false,
                                params: GetProductsParams(
                                  page: state.products!.pageNumber,
                                ),
                              ),
                            );
                          }
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator.adaptive(),
                            ),
                          );
                        }
                        final product = state.products!.list[index];
                        return OfferCheckbox(
                          product: product,
                          selected: _isSelected(product),
                          onChanged: (value) {
                            setState(() {
                              if (value && !_isSelected(product)) {
                                widget.selectedProducts.add(product);
                              } else if (!value) {
                                widget.selectedProducts.removeWhere(
                                  (element) => element.id == product.id,
                                );
                              }
                            });
                          },
                        );
                      },
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemCount: state.products!.listLength(1),
                    );
                  },
                  onTapRetry: () {
                    context.read<ProfileBloc>().add(
                      GetProductsEvent(
                        params: GetProductsParams(page: 1),
                        isReload: true,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
