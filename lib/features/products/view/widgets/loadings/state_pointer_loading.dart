import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../state_pointer.dart';

class StatePointerLoading extends StatelessWidget {
  const StatePointerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: StatePointer(title: "إجمالي المنتجات النشطة", value: 142),
    );
  }
}
