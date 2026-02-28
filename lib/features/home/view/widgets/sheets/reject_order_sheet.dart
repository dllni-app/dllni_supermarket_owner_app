import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../manager/bloc/home_bloc.dart';

class RejectOrderSheet extends StatefulWidget {
  const RejectOrderSheet({super.key, required this.orderId});

  final int orderId;

  @override
  State<RejectOrderSheet> createState() => _RejectOrderSheetState();
}

class _RejectOrderSheetState extends State<RejectOrderSheet> {
  final TextEditingController _reasonController = TextEditingController();
  String _selectedType = 'out_of_stock';
  String? _errorText;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reasonController.text.trim();
    if (reason.isEmpty) {
      setState(() {
        _errorText = "اكتب سبب الرفض";
      });
      return;
    }
    context.read<HomeBloc>().add(
      HomeRejectOrderEvent(
        orderId: widget.orderId,
        reason: reason,
        rejectionType: _selectedType,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "رفض الطلب",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111827),
              ),
            ),
            SizedBox(height: 12),
            Text(
              "اختر سبب الرفض",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [
                ReasonChip(
                  label: "نفاد المخزون",
                  value: "out_of_stock",
                  selectedValue: _selectedType,
                  onSelected: (value) => setState(() {
                    _selectedType = value;
                  }),
                ),
                ReasonChip(
                  label: "طلب وهمي",
                  value: "fake_order",
                  selectedValue: _selectedType,
                  onSelected: (value) => setState(() {
                    _selectedType = value;
                  }),
                ),
                ReasonChip(
                  label: "سبب آخر",
                  value: "other",
                  selectedValue: _selectedType,
                  onSelected: (value) => setState(() {
                    _selectedType = value;
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              "السبب التفصيلي",
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "اكتب السبب هنا...",
                errorText: _errorText,
                filled: true,
                fillColor: const Color(0xFFF9FAFB),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (_) {
                if (_errorText != null) {
                  setState(() {
                    _errorText = null;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                      side: const BorderSide(color: Color(0xFFE5E7EB)),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      "إلغاء",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF4444),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text(
                      "تأكيد الرفض",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class ReasonChip extends StatelessWidget {
  const ReasonChip({
    super.key,
    required this.label,
    required this.value,
    required this.selectedValue,
    required this.onSelected,
  });

  final String label;
  final String value;
  final String selectedValue;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selectedValue;
    final color = isSelected ? AppColors.accent : const Color(0xFFF3F4F6);
    final textColor = isSelected ? Colors.white : const Color(0xFF4B5563);
    return InkWell(
      onTap: () => onSelected(value),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
