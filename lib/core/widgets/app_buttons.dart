import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({super.key, this.onTap, required this.title});
  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: context.primary,
          boxShadow: [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 16,
              color: const Color(0x661E2A78),
            ),
          ],
        ),
        child: AppText(
          title,
          style: TextStyle(
            color: const Color(0xFFFFEEFF),
            fontSize: 14,
            height: 1.42,
          ),
        ),
      ),
    );
  }
}

class AppButtonWithBorder extends StatelessWidget {
  const AppButtonWithBorder({super.key, this.onTap, required this.title});
  final void Function()? onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          color: const Color(0x14FF4C51),
          border: Border.all(color: const Color(0xFFFF4C51)),
        ),
        child: AppText(
          title,
          style: TextStyle(
            color: const Color(0xFFFF4C51),
            fontSize: 14,
            height: 1.42,
          ),
        ),
      ),
    );
  }
}
