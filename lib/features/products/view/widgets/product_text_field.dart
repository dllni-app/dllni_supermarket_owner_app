import 'package:flutter/material.dart';

class ProductTextField extends StatelessWidget {
  const ProductTextField({
    super.key,
    required this.title,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
  });
  final String title;
  final String hintText;
  final int maxLines;
  final TextEditingController controller;
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
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          decoration: InputDecoration(
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
