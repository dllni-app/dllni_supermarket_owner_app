import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/app_config.dart';
import '../data/repository/home_repo_impl.dart';
import '../data/source/home_remote_data_source.dart';
import '../domain/usecases/accept_order_use_case.dart';
import '../domain/usecases/get_dashboard_use_case.dart';
import '../domain/usecases/get_low_stock_use_case.dart';
import '../domain/usecases/get_orders_by_status_use_case.dart';
import '../domain/usecases/reject_order_use_case.dart';
import 'manager/bloc/home_bloc.dart';
import 'widgets/widgets/home_body.dart';
import 'widgets/models/home_models.dart';
import 'widgets/widgets/home_app_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final storeId = 1;
    return BlocProvider(
      create: (_) => _buildHomeBloc()..add(HomeLoadEvent(storeId: storeId)),
      child: Scaffold(
        body: Column(
          children: [
            const HomeAppBar(),
            Expanded(child: HomeBody()),
          ],
        ),
      ),

      // BlocConsumer<HomeBloc, HomeState>(
      //   listener: (context, state) {
      //     if (state.actionStatus == BlocStatus.success &&
      //         state.actionMessage.isNotEmpty) {
      //       ScaffoldMessenger.of(
      //         context,
      //       ).showSnackBar(SnackBar(content: Text(state.actionMessage)));
      //     } else if (state.actionStatus == BlocStatus.failed &&
      //         state.actionMessage.isNotEmpty) {
      //       ScaffoldMessenger.of(
      //         context,
      //       ).showSnackBar(SnackBar(content: Text(state.actionMessage)));
      //     }
      //   },
      //   builder: (context, state) {
      //     final vm = HomeViewModel.fromState(state);
      //     return ;
      //   },
      // ),
    );
  }
}

HomeBloc _buildHomeBloc() {
  final dioNetwork = DioNetwork(baseUrl: AppConfig.baseUrl);
  final remoteDataSource = HomeRemoteDataSource(dioNetwork: dioNetwork);
  final repo = HomeRepoImpl(remoteDataSource: remoteDataSource);
  return HomeBloc(
    GetDashboardUseCase(homeRepo: repo),
    GetLowStockUseCase(homeRepo: repo),
    GetOrdersByStatusUseCase(homeRepo: repo),
    AcceptOrderUseCase(homeRepo: repo),
    RejectOrderUseCase(homeRepo: repo),
  );
}

const List<QuickActionData> quickActions = [
  QuickActionData(
    label: "مخزون جديد",
    icon: Icons.add_shopping_cart,
    color: Color(0xFFFF7A00),
  ),
  QuickActionData(
    label: "إنشاء عرض",
    icon: Icons.percent,
    color: Color(0xFF1E2A78),
  ),
  QuickActionData(
    label: "تفعيل مخزون",
    icon: Icons.inventory_2,
    color: Color(0xFF6C63FF),
  ),
  QuickActionData(
    label: "التقارير",
    icon: Icons.receipt_long,
    color: Color(0xFF22C55E),
  ),
];
