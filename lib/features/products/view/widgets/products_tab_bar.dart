import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class ProductsTabBarItem {
  final String title;
  final int count;

  ProductsTabBarItem({required this.title, required this.count});
}

class ProductsTabBar extends StatefulWidget {
  const ProductsTabBar({
    super.key,
    required this.items,
    required this.onChanged,
  });
  final List<ProductsTabBarItem> items;
  final void Function(int index) onChanged;

  @override
  State<ProductsTabBar> createState() => _ProductsTabBarState();
}

class _ProductsTabBarState extends State<ProductsTabBar> {
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
          child: CategoryChip(
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

class CategoryChip extends StatelessWidget {
  const CategoryChip({super.key, required this.item, required this.isSelected});

  final ProductsTabBarItem item;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: isSelected ? null : Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              height: 1.42,
              color: isSelected ? AppColors.white : Color(0xFF4B5563),
            ),
          ),
          SizedBox(width: 8),
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
