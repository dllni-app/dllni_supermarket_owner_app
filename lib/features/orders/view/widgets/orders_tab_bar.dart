import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_gradients.dart';

class OrdersTabBarItem {
  final String title;
  final int count;
  final Color? leadingColor;

  OrdersTabBarItem({
    required this.title,
    required this.count,
    this.leadingColor,
  });
}

class OrdersTabBar extends StatefulWidget {
  const OrdersTabBar({super.key, required this.items, required this.onChanged});
  final List<OrdersTabBarItem> items;
  final void Function(int index) onChanged;

  @override
  State<OrdersTabBar> createState() => _OrdersTabBarState();
}

class _OrdersTabBarState extends State<OrdersTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38 + 32,
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: () {
            if (index != selectedIndex) {
              selectedIndex = index;
              setState(() {});
              widget.onChanged(index);
            }
          },
          child: _CategoryChip(
            isSelected: index == selectedIndex,
            item: widget.items[index],
          ),
        ),
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemCount: widget.items.length,
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.item,
    required this.isSelected,
  });

  final OrdersTabBarItem item;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? null : AppColors.white,
        gradient: isSelected ? AppGradients.gradient : null,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: isSelected ? null : Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (item.leadingColor != null)
            CircleAvatar(radius: 4, backgroundColor: item.leadingColor),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42,
              color: isSelected ? AppColors.white : Color(0xFF4B5563),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.accent : Color(0xFFF3F4F6),
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Text(
              item.count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.white : Color(0xFF4B5563),
                height: 1.333,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
