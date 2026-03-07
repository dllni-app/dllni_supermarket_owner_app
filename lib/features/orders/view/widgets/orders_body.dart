import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/widgets/warning_alert.dart';
import 'order_card.dart';

class OrdersBody extends StatelessWidget {
  const OrdersBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: WarningAlert(
            icon: FontAwesomeIcons.clock,
            title: "طلب متأخر #2475",
            description: "تجاوز الوقت المحدد بـ 5 دقائق.",
            labelButton: "عرض",
          ),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: EdgeInsets.only(bottom: 16, left: 20, right: 20),
            itemBuilder: (_, index) => [
              OrderCard(status: OrderStatus.pending),
              OrderCard(status: OrderStatus.pending),
              OrderCard(status: OrderStatus.preparing),
              OrderCard(status: OrderStatus.readyForPickup),
              OrderCard(status: OrderStatus.completed),
            ][index],
            separatorBuilder: (_, _) => SizedBox(height: 16),
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}
