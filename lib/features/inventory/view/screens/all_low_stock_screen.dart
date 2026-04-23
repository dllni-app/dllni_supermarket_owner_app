import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/themes/app_colors.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/app_app_bars.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/view/manager/bloc/inventory_bloc.dart';
import 'package:dllni_supermarket_owner_app/features/products/data/models/get_low_stock_model.dart';
import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/get_low_stock_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllLowStockScreen extends StatelessWidget {
  const AllLowStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppSimpleAppBar(title: 'مخزون منخفض'),
          Expanded(
            child: BlocBuilder<InventoryBloc, InventoryState>(
              buildWhen: (previous, current) =>
                  previous.lowStockStatus != current.lowStockStatus ||
                  previous.lowStock != current.lowStock,
              builder: (context, state) {
                if (state.lowStockStatus == BlocStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.lowStockStatus == BlocStatus.failed) {
                  return FailureWidget(
                    message: state.errorMessage ?? 'حدث خطأ',
                    onRetry: () {
                      context.read<InventoryBloc>().add(
                        GetLowStockEvent(params: GetLowStockParams()),
                      );
                    },
                  );
                }
                final products = state.lowStock?.data?.products;
                if (products == null || products.isEmpty) {
                  return Center(
                    child: AppText.labelMedium('لا توجد منتجات منخفضة المخزون'),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    vertical: 24,
                    horizontal: 16,
                  ),
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _LowStockListTile(item: products[index]);
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

class _LowStockListTile extends StatelessWidget {
  const _LowStockListTile({required this.item});

  final GetLowStockModelDataItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border(
          right: const BorderSide(color: Color(0xFFE64449), width: 4),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            color: Color(0x1F5E6695),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 6,
        children: [
          AppText(
            item.productName ?? '—',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          if (item.category != null && item.category!.isNotEmpty)
            AppText(
              item.category!,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFF6B7280),
              ),
            ),
          AppText(
            'الكمية: ${item.currentStock ?? 0} • الحد الأدنى: ${item.threshold ?? 0}'
            '${item.barcode != null && item.barcode!.isNotEmpty ? ' • ${item.barcode}' : ''}',
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4B5563),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
