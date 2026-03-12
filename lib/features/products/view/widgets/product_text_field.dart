import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/date_time_extensions.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    required this.title,
    this.hintText,
    this.controller,
    this.readOnly = false,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
    this.suffixIcon,
    this.isRequired = false,
  });
  final bool isRequired;
  final String title;
  final String? hintText;
  final int? maxLines;
  final bool readOnly;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: [
              if (isRequired)
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
            ],
          ),

          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        TextField(
          maxLines: maxLines,
          readOnly: readOnly,
          controller: controller,
          keyboardType: keyboardType,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          decoration: InputDecoration(
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            hintText: hintText,
            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductMenuField<T> extends StatelessWidget {
  const ProductMenuField({
    super.key,
    required this.title,
    this.hintText,
    this.onChanged,
    required this.items,
    this.isRequired = false,
  });
  final String title;
  final bool isRequired;
  final String? hintText;
  final void Function(T? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: [
              if (isRequired)
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
            ],
          ),

          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        DropdownButtonFormField<T>(
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          hint: AppText(
            hintText ?? "",
            style: TextStyle(
              fontFamily: "Cairo",
              color: Color(0xFF111827),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class ProductDatePicker extends StatefulWidget {
  const ProductDatePicker({
    super.key,
    required this.title,
    this.isRequired = false,
    required this.onDateChanged,
  });
  final String title;
  final bool isRequired;
  final void Function(DateTime expiredDate) onDateChanged;
  @override
  State<ProductDatePicker> createState() => _ProductDatePickerState();
}

class _ProductDatePickerState extends State<ProductDatePicker> {
  DateTime? expiredDate;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: widget.title,
            children: [
              if (widget.isRequired)
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
            ],
          ),
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        TextField(
          controller: expiredDate == null
              ? null
              : TextEditingController(text: expiredDate!.format),
          readOnly: true,
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          decoration: InputDecoration(
            suffixIcon: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(4)),
                onTap: () async {
                  DateTime? date = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2030),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                          colorScheme: ColorScheme.light(
                            primary: AppColors.primary,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (date == null) return;
                  expiredDate = date;
                  setState(() {});
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Icon(
                    Icons.date_range_rounded,
                    size: 18,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ),
            ),
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            hintText: "01 - 01 - 2030",
            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}
