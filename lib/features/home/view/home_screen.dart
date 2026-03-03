import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/di/injection.dart';
import 'manager/bloc/home_bloc.dart';
import 'widgets/models/home_models.dart';
import 'widgets/widgets/home_app_bar.dart';
import 'widgets/widgets/home_body.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F7FB),
        body: Column(
          children: [
            const HomeAppBar(
              shopName: 'مطعم البيت الحلبي',
              shopAddress: "الفرع الرئيسي - العزيزية",
            ),
            Expanded(child: HomeBody()),
          ],
        ),
      ),
    );
  }
}

// HomeBloc _buildHomeBloc() {
//   final dioNetwork = DioNetwork(baseUrl: AppConfig.baseUrl);
//   final remoteDataSource = HomeRemoteDataSource(dioNetwork: dioNetwork);
//   final repo = HomeRepoImpl(remoteDataSource: remoteDataSource);
//   return HomeBloc(
//     GetDashboardUseCase(homeRepo: repo),
//     GetLowStockUseCase(homeRepo: repo),
//     GetOrdersByStatusUseCase(homeRepo: repo),
//     AcceptOrderUseCase(homeRepo: repo),
//     RejectOrderUseCase(homeRepo: repo),
//   );
// }

const List<QuickActionData> quickActions = [
  QuickActionData(
    label: "التقارير",
    icon: Icons.receipt_long,
    color: Color(0xFF16A34A),
  ),
  QuickActionData(
    label: "تفعيل مخزون",
    icon: Icons.inventory_2,
    color: Color(0xFF7C3AED),
  ),
  QuickActionData(
    label: "إنشاء عرض",
    icon: Icons.percent,
    color: Color(0xFF1E2A78),
  ),
  QuickActionData(
    label: "مخزون جديد",
    icon: Icons.add,
    color: Color(0xFFFF7A00),
  ),
];
