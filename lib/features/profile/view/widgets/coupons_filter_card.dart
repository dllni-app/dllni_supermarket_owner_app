import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_shadows.dart';

Map<String, String> sortMapper = {
  'name': 'حسب الاسم',
  '-name': 'حسب الاسم تنازليا',
  'startsAt': 'حسب التاريخ البدء',
  '-startsAt': 'حسب التاريخ البدء تنازليا',
  'endsAt': 'حسب التاريخ الانتهاء',
  '-endsAt': 'حسب التاريخ الانتهاء تنازليا',
  'createdAt': 'حسب التاريخ الإنشاء',
  '-createdAt': 'حسب التاريخ الإنشاء تنازليا',
};

class CouponsFilterCard extends StatefulWidget {
  final void Function(String value) onSearchChanged;
  final void Function(int index) onTabChanged;
  final void Function(String sort) onSortChanged;
  const CouponsFilterCard({
    super.key,
    required this.onSearchChanged,
    required this.onTabChanged,
    required this.onSortChanged,
  });

  @override
  State<CouponsFilterCard> createState() => _CouponsFilterCardState();
}

class _CouponsFilterCardState extends State<CouponsFilterCard> {
  int selectedIndex = 0;
  String selectedSort = '';

  List<Color> colors = [
    Color(0xff10B981),
    Color(0xffF59E0B),
    Color(0xff9CA3AF),
  ];

  List<String> titles = ['الكل', 'نشط', 'معطل', 'منتهي'];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: context.onPrimary,
        boxShadow: [AppShadows.shadow],
        border: Border.all(color: Color(0xffF3F4F6)),
      ),
      margin: EdgeInsetsDirectional.symmetric(horizontal: 24),
      padding: EdgeInsetsDirectional.all(16),
      child: Column(
        children: [
          TextFormField(
            onFieldSubmitted: widget.onSearchChanged,
            style: TextStyle(
              color: Color(0xff2F2B3D),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF9FAFB),
              prefixIcon: Icon(Icons.search, color: Color(0xff9CA3AF)),
              hintText: 'ابحث عن عرض...',
              hintStyle: TextStyle(
                color: Color(0xff9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 36,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemCount: titles.length,
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  if (selectedIndex == index) return;
                  widget.onTabChanged(index);
                  selectedIndex = index;
                  setState(() {});
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: selectedIndex == index
                        ? Color(0xff064E3B)
                        : Color(0xffF3F4F6),
                  ),
                  padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    children: [
                      index == 0
                          ? SizedBox.shrink()
                          : CircleAvatar(
                              radius: 4,
                              backgroundColor: colors[index - 1],
                            ),
                      index == 0 ? SizedBox.shrink() : SizedBox(width: 6),
                      AppText(
                        titles[index],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          height: 1.33,
                          color: index == selectedIndex
                              ? context.onPrimary
                              : Color(0xff374151),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, index) => SizedBox(width: 8),
            ),
          ),
          SizedBox(height: 12),
          PopupMenuButton(
            onSelected: (value) {
              if (value == selectedSort) return;
              widget.onSortChanged(value);
              setState(() => selectedSort = value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: '',
                child: AppText.bodyMedium(
                  'لا شيء',
                  overflow: TextOverflow.ellipsis,
                  color: Color(0xff374151),
                  fontWeight: FontWeight.bold,
                ),
              ),
              ...sortMapper.entries.map(
                (entry) => PopupMenuItem(
                  value: entry.key,
                  child: AppText.bodyMedium(
                    entry.value,
                    overflow: TextOverflow.ellipsis,
                    color: Color(0xff374151),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xffE5E7EB), width: 1),
              ),
              padding: EdgeInsetsDirectional.symmetric(vertical: 11),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_alt_rounded,
                    color: Color(0xff374151),
                    size: 14,
                  ),
                  SizedBox(width: 8),
                  Flexible(
                    child: AppText.bodyMedium(
                      sortMapper[selectedSort] ?? 'ترتيب',
                      overflow: TextOverflow.ellipsis,
                      color: Color(0xff374151),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
