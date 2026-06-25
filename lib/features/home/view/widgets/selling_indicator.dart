import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SellingIndicator extends StatelessWidget {
  final num percent;

  const SellingIndicator({super.key, required this.percent});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: percent >= 0 ? const Color(0x3322C55E) : const Color(0x33EF4444),
        borderRadius: BorderRadius.all(Radius.circular(100)),
      ),
      child: Row(
        spacing: 4,
        children: [
          FaIcon(
            percent > 0
                ? FontAwesomeIcons.arrowUpShortWide
                : FontAwesomeIcons.arrowDownShortWide,
            size: 13,
            color: percent > 0 ? Color(0xFF4ADE80) : Color(0xFFEF4444),
          ),
          AppText(
            "${percent > 0 ? "+$percent" : percent}%",
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: percent > 0 ? Color(0xFF4ADE80) : Color(0xFFEF4444),
              fontSize: 12,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}
