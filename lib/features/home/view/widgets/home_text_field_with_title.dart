import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

class HomeTextFieldWithTitle extends StatelessWidget {
  const HomeTextFieldWithTitle({
    super.key,
    required this.title,
    required this.hintText,
    this.icon,
    this.isOptional = false,
    this.maxLines = 1,
    this.controller,
  });

  final String title;
  final String hintText;
  final IconData? icon;
  final bool isOptional;
  final int? maxLines;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          spacing: 8,
          children: [
            if (icon != null) Icon(icon, size: 14, color: Color(0xFF3B82F6)),
            AppText(
              title,
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isOptional)
              AppText(
                "(اختياري)",
                style: TextStyle(
                  color: Color(0xFF9CA3AF),
                  fontSize: 12,
                  height: 1.333,
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          controller: controller,
          maxLines: maxLines,
          style: TextStyle(
            color: Color(0xFF111827),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            hint: Text(
              hintText,
              style: TextStyle(
                color: Color(0xFF9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.42,
              ),
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
            ),
          ),
        ),
      ],
    );
  }
}
