import 'package:flutter/material.dart';

// import '../data/models/low_stock_model.dart';
import 'manager/bloc/home_bloc.dart';
import 'widgets/models/home_models.dart';

class HomeViewModel {
  final List<OverviewStatData> stats;
  final List<OrderCardData> newOrders;
  final List<PreparingOrderData> preparingOrders;
  // final LowStockProduct? lowStockProduct;
  final num? totalSales;

  const HomeViewModel({
    required this.stats,
    required this.newOrders,
    required this.preparingOrders,
    // required this.lowStockProduct,
    required this.totalSales,
  });

  factory HomeViewModel.fromState(HomeState state) {
    // final dashboardData = state.dashboard?.data;
    final stats = [
      OverviewStatData(
        label: "طلبات جديدة",
        value: "0",
        icon: Icons.shopping_bag,
        color: const Color(0xFF4F46E5),
        background: const Color(0xFFF5F3FF),
      ),
      OverviewStatData(
        label: "قيد التحضير",
        value: "0",
        icon: Icons.restaurant_menu,
        color: const Color(0xFFF97316),
        background: const Color(0xFFFFF7ED),
      ),
      OverviewStatData(
        label: "تم التوصيل",
        value: "0",
        icon: Icons.check_circle,
        color: const Color(0xFF22C55E),
        background: const Color(0xFFF0FDF4),
      ),
    ];

    // final lowStockProducts = state.lowStock?.data?.products ?? const [];
    // final lowStockProduct = lowStockProducts.isNotEmpty
    //     ? lowStockProducts.first
    //     : null;

    final List<OrderCardData> newOrders = [];
    // (state.pendingOrders?.data ?? const [])
    //     .map(
    //       (order) => OrderCardData(
    //         orderId: order.id,
    //         id: order.orderNumber ?? "#${order.id ?? '--'}",
    //         name: order.customer?.name ?? "عميل جديد",
    //         total: "${order.totalAmount ?? '0'} ل.س",
    //         timeAgo: formatTimeAgo(order.createdAt),
    //         items: "تفاصيل الطلب متاحة",
    //       ),
    //     )
    //     .toList();

    final List<PreparingOrderData> preparingOrders = [];
    // (state.preparingOrders?.data ?? const [])
    //     .map(
    //       (order) => PreparingOrderData(
    //         id: order.orderNumber ?? "#${order.id ?? '--'}",
    //         minutesSince: minutesSince(order.createdAt),
    //       ),
    //     )
    //     .toList();

    return HomeViewModel(
      stats: stats,
      newOrders: newOrders,
      preparingOrders: preparingOrders,
      // lowStockProduct: lowStockProduct,
      totalSales: 0, //dashboardData?.totalSales,
    );
  }
}

String todayLabel() {
  final now = DateTime.now();
  return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
}

String formatTimeAgo(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return "";
  final parsed = DateTime.tryParse(createdAt.replaceAll(' ', 'T'));
  if (parsed == null) return "";
  final diff = DateTime.now().difference(parsed);
  if (diff.inMinutes < 1) return "الآن";
  if (diff.inMinutes < 60) return "منذ ${diff.inMinutes} دقيقة";
  if (diff.inHours < 24) return "منذ ${diff.inHours} ساعة";
  return "منذ ${diff.inDays} يوم";
}

int minutesSince(String? createdAt) {
  if (createdAt == null || createdAt.isEmpty) return 0;
  final parsed = DateTime.tryParse(createdAt.replaceAll(' ', 'T'));
  if (parsed == null) return 0;
  final diff = DateTime.now().difference(parsed);
  return diff.inMinutes < 0 ? 0 : diff.inMinutes;
}
