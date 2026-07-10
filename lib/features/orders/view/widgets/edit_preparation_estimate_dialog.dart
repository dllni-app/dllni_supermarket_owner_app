import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../domain/repository/orders_repo.dart';
import '../../domain/usecases/update_preparation_estimate_params.dart';

Future<void> showEditPreparationEstimateDialog({
  required BuildContext context,
  required int orderId,
  required VoidCallback onUpdated,
}) async {
  final rootContext = context;
  final controller = TextEditingController();
  var loading = false;

  await showDialog<void>(
    context: rootContext,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) {
        Future<void> submit() async {
          final raw = controller.text.trim();
          final minutes = raw.isEmpty ? null : int.tryParse(raw);
          if (raw.isNotEmpty &&
              (minutes == null || minutes < 1 || minutes > 120)) {
            AppToast.showToast(
              context: dialogContext,
              message: 'يجب أن يكون وقت التجهيز بين 1 و120 دقيقة',
              type: ToastificationType.error,
            );
            return;
          }

          setState(() => loading = true);
          final result = await getIt<OrdersRepo>().updatePreparationEstimate(
            UpdatePreparationEstimateParams(
              orderId: orderId,
              preparationTimeMinutes: minutes,
            ),
          );

          if (!dialogContext.mounted) return;
          result.fold(
            (failure) {
              setState(() => loading = false);
              AppToast.showToast(
                context: dialogContext,
                message: failure.message,
                type: ToastificationType.error,
              );
            },
            (_) {
              Navigator.of(dialogContext).pop();
              onUpdated();
              if (rootContext.mounted) {
                AppToast.showToast(
                  context: rootContext,
                  message: minutes == null
                      ? 'تم مسح وقت التجهيز المتوقع'
                      : 'تم تحديث وقت التجهيز المتوقع',
                  type: ToastificationType.success,
                );
              }
            },
          );
        }

        return AlertDialog(
          title: const Text('تحديث وقت التجهيز'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'أدخل الدقائق المتبقية من الآن. اترك الحقل فارغاً لمسح التقدير.',
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                enabled: !loading,
                autofocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  hintText: 'من 1 إلى 120 دقيقة، أو فارغ',
                  prefixIcon: Icon(Icons.timer_outlined),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading
                  ? null
                  : () => Navigator.of(dialogContext).pop(),
              child: const Text('إلغاء'),
            ),
            FilledButton.icon(
              onPressed: loading ? null : submit,
              icon: loading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.save_outlined),
              label: const Text('حفظ'),
            ),
          ],
        );
      },
    ),
  );

  controller.dispose();
}
