import 'package:flutter/material.dart';

import '../../data/models/get_coupon_codes_model.dart';
import '../../data/models/get_offer_codes_model.dart';

Future<Map<String, dynamic>?> showOfferEditDialog(
  BuildContext context,
  GetOfferCodesModelDataItem offer,
) async {
  final name = TextEditingController(text: offer.name ?? '');
  final description = TextEditingController(text: '${offer.description ?? ''}');
  final discount = TextEditingController(
    text: offer.offerType == 'percentage'
        ? '${offer.discountPercent ?? ''}'
        : '${offer.discountValue ?? ''}',
  );
  var type = offer.offerType == 'percentage' ? 'percentage' : 'fixed';
  var isActive = offer.isActive ?? true;
  var startsAt = DateTime.tryParse('${offer.startsAt ?? ''}');
  var endsAt = DateTime.tryParse('${offer.endsAt ?? ''}');
  String? error;

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('تعديل العرض'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'اسم العرض'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: description,
                  minLines: 2,
                  maxLines: 4,
                  decoration: const InputDecoration(labelText: 'الوصف'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'نوع الخصم'),
                  items: const [
                    DropdownMenuItem(
                      value: 'percentage',
                      child: Text('نسبة مئوية'),
                    ),
                    DropdownMenuItem(
                      value: 'fixed',
                      child: Text('مبلغ ثابت'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => type = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText:
                        type == 'percentage' ? 'نسبة الخصم' : 'قيمة الخصم',
                  ),
                ),
                const SizedBox(height: 10),
                _DateRow(
                  label: 'بداية العرض',
                  value: startsAt,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startsAt ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) setState(() => startsAt = picked);
                  },
                ),
                _DateRow(
                  label: 'نهاية العرض',
                  value: endsAt,
                  onTap: () async {
                    final base = startsAt ?? DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          endsAt != null && !endsAt!.isBefore(base)
                              ? endsAt!
                              : base,
                      firstDate: base,
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) setState(() => endsAt = picked);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('العرض مفعل'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
                if (error != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final amount = num.tryParse(discount.text.trim());
              if (name.text.trim().isEmpty || amount == null || amount < 0) {
                setState(() => error = 'تحقق من اسم العرض وقيمة الخصم');
                return;
              }
              if (type == 'percentage' && amount > 100) {
                setState(() => error = 'نسبة الخصم لا يمكن أن تتجاوز 100%');
                return;
              }
              if (startsAt != null &&
                  endsAt != null &&
                  endsAt!.isBefore(startsAt!)) {
                setState(() => error = 'نهاية العرض يجب أن تكون بعد البداية');
                return;
              }

              Navigator.pop(dialogContext, {
                'name': name.text.trim(),
                'description': description.text.trim().isEmpty
                    ? null
                    : description.text.trim(),
                'offerType': type,
                'discountPercent': type == 'percentage'
                    ? amount.toInt()
                    : null,
                'discountValue': type == 'percentage' ? null : amount,
                'startsAt': startsAt?.toIso8601String(),
                'endsAt': endsAt?.toIso8601String(),
                'isActive': isActive,
              });
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    ),
  );

  name.dispose();
  description.dispose();
  discount.dispose();
  return result;
}

Future<Map<String, dynamic>?> showCouponEditDialog(
  BuildContext context,
  GetCouponCodesModelDataItem coupon,
) async {
  final code = TextEditingController(text: coupon.code ?? '');
  final discount = TextEditingController(
    text: coupon.type == 'percent'
        ? '${coupon.percent ?? ''}'
        : coupon.value ?? '',
  );
  final minOrder = TextEditingController(text: coupon.minOrderAmount ?? '');
  final maxDiscount = TextEditingController(
    text: coupon.maxDiscountAmount ?? '',
  );
  final usageLimit = TextEditingController(
    text: coupon.usageLimit == null ? '' : '${coupon.usageLimit}',
  );
  var type = coupon.type == 'percent' ? 'percent' : 'fixed';
  var isActive = coupon.isActive ?? true;
  var startsAt = DateTime.tryParse(coupon.startsAt ?? '');
  var endsAt = DateTime.tryParse(coupon.endsAt ?? '');
  String? error;

  final result = await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('تعديل الكوبون'),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: code,
                  decoration: const InputDecoration(labelText: 'رمز الكوبون'),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'نوع الخصم'),
                  items: const [
                    DropdownMenuItem(
                      value: 'percent',
                      child: Text('نسبة مئوية'),
                    ),
                    DropdownMenuItem(
                      value: 'fixed',
                      child: Text('مبلغ ثابت'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => type = value);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: discount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(labelText: 'قيمة الخصم'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: minOrder,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(labelText: 'الحد الأدنى للطلب'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: maxDiscount,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration:
                      const InputDecoration(labelText: 'أقصى قيمة للخصم'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: usageLimit,
                  keyboardType: TextInputType.number,
                  decoration:
                      const InputDecoration(labelText: 'حد الاستخدامات'),
                ),
                const SizedBox(height: 10),
                _DateRow(
                  label: 'بداية الكوبون',
                  value: startsAt,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: startsAt ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) setState(() => startsAt = picked);
                  },
                ),
                _DateRow(
                  label: 'نهاية الكوبون',
                  value: endsAt,
                  onTap: () async {
                    final base = startsAt ?? DateTime.now();
                    final picked = await showDatePicker(
                      context: context,
                      initialDate:
                          endsAt != null && !endsAt!.isBefore(base)
                              ? endsAt!
                              : base,
                      firstDate: base,
                      lastDate: DateTime(DateTime.now().year + 10),
                    );
                    if (picked != null) setState(() => endsAt = picked);
                  },
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('الكوبون مفعل'),
                  value: isActive,
                  onChanged: (value) => setState(() => isActive = value),
                ),
                if (error != null)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Text(
                      error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () {
              final amount = num.tryParse(discount.text.trim());
              if (code.text.trim().isEmpty || amount == null || amount < 0) {
                setState(() => error = 'تحقق من رمز الكوبون وقيمة الخصم');
                return;
              }
              if (type == 'percent' && amount > 100) {
                setState(() => error = 'نسبة الخصم لا يمكن أن تتجاوز 100%');
                return;
              }
              Navigator.pop(dialogContext, {
                'code': code.text.trim(),
                'type': type,
                'percent': type == 'percent' ? amount.toInt() : null,
                'value': type == 'percent' ? null : amount,
                'minOrderAmount': num.tryParse(minOrder.text.trim()),
                'maxDiscountAmount': num.tryParse(maxDiscount.text.trim()),
                'usageLimit': int.tryParse(usageLimit.text.trim()),
                'startsAt': startsAt?.toIso8601String(),
                'endsAt': endsAt?.toIso8601String(),
                'isActive': isActive,
              });
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    ),
  );

  code.dispose();
  discount.dispose();
  minOrder.dispose();
  maxDiscount.dispose();
  usageLimit.dispose();
  return result;
}

class _DateRow extends StatelessWidget {
  final String label;
  final DateTime? value;
  final VoidCallback onTap;

  const _DateRow({
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final display = value == null
        ? 'غير محدد'
        : '${value!.year}-${value!.month.toString().padLeft(2, '0')}-'
              '${value!.day.toString().padLeft(2, '0')}';

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(display),
      trailing: const Icon(Icons.calendar_month_outlined),
      onTap: onTap,
    );
  }
}
