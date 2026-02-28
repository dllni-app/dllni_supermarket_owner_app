import 'package:common_package/widgets/app_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    required this.onChanged,
    required this.hintText,
  });
  final void Function(String value) onChanged;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: "Cairo",
          fontWeight: FontWeight.w500,
          fontSize: 12,
          color: Color(0xFF9CA3AF),
        ),
        filled: true,
        fillColor: AppColors.filledInputBackgroundColor,
        contentPadding: EdgeInsets.fromLTRB(16, 14, 44, 13),
        prefixIcon: Padding(
          padding: EdgeInsets.only(right: 12),
          child: AppImage.asset(AppImages.search, size: 16),
        ),
        // prefixIcon: Icon(Icons.search, size: 32),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
