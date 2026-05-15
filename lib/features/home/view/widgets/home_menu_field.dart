import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

class HomeMenuField<T> extends StatelessWidget {
  const HomeMenuField({
    super.key,
    required this.title,
    required this.hintText,
    this.icon,
    this.isOptional = false,
    required this.items,
    required this.onChanged,
  });

  final String title;
  final String hintText;
  final IconData? icon;
  final bool isOptional;
  final List<DropdownMenuItem<T>> items;
  final void Function(T? value) onChanged;

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
        DropdownButtonFormField<T>(
          items: items,
          onChanged: onChanged,
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          hint: Text(
            hintText,
            style: TextStyle(
              fontFamily: "Cairo",
              color: Color(0xFF9CA3AF),
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42,
            ),
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),

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
