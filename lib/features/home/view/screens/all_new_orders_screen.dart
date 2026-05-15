import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_new_orders_use_case.dart';
import '../manager/bloc/home_bloc.dart';
import '../widgets/loadings/new_orders_loading.dart';
import '../widgets/new_orders_section.dart';

class AllNewOrdersScreen extends StatelessWidget {
  const AllNewOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "الطلبات الجديدة"),
          Expanded(
            child: BlocBuilder<HomeBloc, HomeState>(
              buildWhen: (previous, current) =>
                  previous.newOrders != current.newOrders,
              builder: (context, state) {
                return state.newOrders!.builder(
                  loadingWidget: NewOrdersLoading(),
                  emptyWidget: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: AppText.labelMedium('لا يوجد طلبات للعرض'),
                    ),
                  ),
                  successWidget: () => ListView.separated(
                    padding: EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                    itemBuilder: (context, index) =>
                        NewOrderCard(order: state.newOrders![index]),
                    separatorBuilder: (_, _) => SizedBox(height: 12),
                    itemCount: state.newOrders!.length,
                  ),
                  onTapRetry: () {
                    context.read<HomeBloc>().add(
                      GetNewOrdersEvent(params: GetNewOrdersParams()),
                    );
                  },
                  failedWidget: FailureWidget(
                    message: state.errorMessage ?? "Error an occurred",
                    onRetry: () {
                      context.read<HomeBloc>().add(
                        GetNewOrdersEvent(params: GetNewOrdersParams()),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
