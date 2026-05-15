import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';

class HomeRadioItem {
  final String title;
  final String subtitle;

  HomeRadioItem({required this.title, required this.subtitle});
}

class HomeRadioGroup extends StatefulWidget {
  const HomeRadioGroup({
    super.key,
    required this.onChanged,
    required this.radios,
  });
  final void Function(int value) onChanged;
  final List<HomeRadioItem> radios;

  @override
  State<HomeRadioGroup> createState() => _HomeRadioGroupState();
}

class _HomeRadioGroupState extends State<HomeRadioGroup> {
  int? _selectedRadio;
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) => InkWell(
        onTap: () {
          if (index != _selectedRadio) {
            _selectedRadio = index;
            setState(() {});
            widget.onChanged(index);
          }
        },
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: Color(0xFFE5E7EB)),
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          child: Row(
            children: [
              SizedBox(width: 12),
              Container(
                width: 20,
                height: 20,
                padding: EdgeInsets.all(3),
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Color(0xFFD1D5DB)),
                  shape: BoxShape.circle,
                ),
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  decoration: BoxDecoration(
                    color: index == _selectedRadio
                        ? context.primary
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    widget.radios[index].title,
                    style: TextStyle(
                      color: const Color(0xFF0F172A),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                  SizedBox(height: 2),
                  AppText(
                    widget.radios[index].subtitle,
                    style: TextStyle(
                      color: const Color(0xFF6B7280),
                      fontSize: 12,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      separatorBuilder: (context, index) => SizedBox(height: 12),
      itemCount: widget.radios.length,
      padding: EdgeInsets.zero,
    );
  }
}
