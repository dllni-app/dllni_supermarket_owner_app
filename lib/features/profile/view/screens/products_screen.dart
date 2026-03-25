import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_app_bars.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'create_offer_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key, required this.selectedProducts});
  final List<GetProductsModelDataItem> selectedProducts;
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
                  loadingWidget: OfferLoading(),
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
                          return OfferLoading();
                        }
                        return OfferCheckbox(
                          product: state.products!.list[index],
                          onChanged: (value) {
                            if (value) {
                              selectedProducts.add(state.products!.list[index]);
                            } else {
                              selectedProducts.removeWhere(
                                (element) =>
                                    element.id ==
                                    state.products!.list[index].id,
                              );
                            }
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
