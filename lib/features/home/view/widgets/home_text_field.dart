import 'package:flutter/material.dart';

class HomeTextField extends StatelessWidget {
  const HomeTextField({
    super.key,
    required this.hintText,
    required this.prefix,
  });

  final String hintText;
  final Widget? prefix;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      // controller: controller,
      style: TextStyle(
        color: Color(0xFF111827),
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        prefixIcon: prefix,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        hint: Text(
          hintText,
          style: TextStyle(
            color: Color(0xFF9CA3AF),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1,
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
    );
  }
}
