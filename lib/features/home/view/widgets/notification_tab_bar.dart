import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class NotificationsTabBarItem {
  final String title;
  final IconData? icon;
  final int count;

  NotificationsTabBarItem({
    required this.title,
    required this.icon,
    required this.count,
  });
}

class NotificationsTabBar extends StatefulWidget {
  const NotificationsTabBar({
    super.key,
    required this.items,
    required this.onChanged,
  });
  final List<NotificationsTabBarItem> items;
  final void Function(int index) onChanged;

  @override
  State<NotificationsTabBar> createState() => _NotificationsTabBarState();
}

class _NotificationsTabBarState extends State<NotificationsTabBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16),
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
          child: _NotificationsCategoryChip(
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

class _NotificationsCategoryChip extends StatelessWidget {
  const _NotificationsCategoryChip({
    required this.item,
    required this.isSelected,
  });
  final NotificationsTabBarItem item;
  final bool isSelected;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isSelected ? AppColors.accent : AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 8,
        children: [
          if (item.icon != null)
            Icon(
              item.icon,
              size: 14,
              color: isSelected ? AppColors.white : Color(0xFF374151),
            ),
          Text(
            item.title,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.42,
              color: isSelected ? AppColors.white : Color(0xFF4B5563),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
            decoration: BoxDecoration(
              color: Color(0x80FFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Text(
              item.count.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? AppColors.white : Color(0xFF374151),
                height: 1.333,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
