import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

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
  });
  final String title;
  final String? hintText;
  final int maxLines;
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
        Text(
          title,
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
  });
  final String title;
  final String? hintText;
  final void Function(T? value)? onChanged;
  final List<DropdownMenuItem<T>> items;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
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
