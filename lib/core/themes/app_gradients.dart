import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppGradients {
  const AppGradients._();
  static const LinearGradient gradient = LinearGradient(
    colors: [const Color(0xFF6100C6), AppColors.primary],
    stops: [.03, 0.4],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );
}
