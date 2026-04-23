import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/warning_alert.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/view/manager/bloc/inventory_bloc.dart';
import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/get_low_stock_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../screens/all_low_stock_screen.dart';

class LowStockAlertsSection extends StatelessWidget {
  const LowStockAlertsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InventoryBloc, InventoryState>(
      buildWhen: (previous, current) =>
          previous.lowStockStatus != current.lowStockStatus ||
          previous.lowStock != current.lowStock,
      builder: (context, state) {
        final status = state.lowStockStatus;
        if (status == null || status == BlocStatus.loading) {
          return const SizedBox.shrink();
        }
        if (status == BlocStatus.failed) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: AppText(
                    state.errorMessage ?? 'تعذر تحميل التنبيهات',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    context.read<InventoryBloc>().add(
                      GetLowStockEvent(params: GetLowStockParams()),
                    );
                  },
                  child: AppText(
                    'إعادة المحاولة',
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        if (status != BlocStatus.success) {
          return const SizedBox.shrink();
        }
        final total = state.lowStock?.data?.total ?? 0;
        final first = state.lowStock?.data?.products?.isNotEmpty == true
            ? state.lowStock!.data!.products!.first
            : null;
        if (total <= 0 || first == null) {
          return const SizedBox.shrink();
        }
        final name = first.productName ?? '';
        final current = first.currentStock ?? 0;
        final threshold = first.threshold ?? 0;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: 12,
            children: [
            Row(
              children: [
                AppText(
                  'التنبيهات',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111827),
                    height: 1.5,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 6,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFEF4444),
                          borderRadius: BorderRadius.all(
                            Radius.circular(20),
                          ),
                        ),
                        child: AppText(
                          total.toString(),
                          style: const TextStyle(
                            color: AppColors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (total > 2)
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<InventoryBloc>(),
                                  child: const AllLowStockScreen(),
                                ),
                              ),
                            );
                          },
                          child: AppText(
                            'عرض الكل',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xB22F2B3D),
                              fontWeight: FontWeight.w700,
                              height: 1.333,
                            ),
                          ),
                        ),
                      const SizedBox(width: 26),
                    ],
                  ),
                ),
              ],
            ),
            WarningAlert(
              icon: FontAwesomeIcons.triangleExclamation,
              title: 'تنبيه مخزون منخفض',
              description:
                  'مادة "$name" قاربت على النفاد (الكمية الحالية: $current، الحد الأدنى: $threshold)',
              labelButton: 'عرض',
            ),
            ],
          ),
        );
      },
    );
  }
}
