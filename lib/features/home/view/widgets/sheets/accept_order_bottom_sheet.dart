import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/home/view/widgets/home_text_field_with_title.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/themes/app_shadows.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../home_menu_field.dart';
import '../home_text_field.dart';

class AcceptOrderBottomSheet extends StatelessWidget {
  const AcceptOrderBottomSheet({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });
  final int orderId;
  final String orderNumber;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        AppText(
                          "قبول الطلب #$orderNumber",
                          style: TextStyle(
                            color: const Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 2),
                        AppText(
                          "يرجى تأكيد تفاصيل التجهيز قبل البدء",
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            height: 1.42,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      customBorder: CircleBorder(),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFF9FAFB),
                        radius: 16,
                        child: Icon(
                          FontAwesomeIcons.x,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.clock,
                            size: 14,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            "وقت التجهيز المتوقع",
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      TimeChoices(
                        minutes: [15, 25, 35, 45],
                        onChanged: (value) {
                          print(value);
                        },
                      ),
                      SizedBox(height: 12),
                      HomeTextField(
                        hintText: "أدخل وقت مخصص (دقيقة)",
                        prefix: Icon(
                          FontAwesomeIcons.solidHourglassHalf,
                          color: Color(0xFF9CA3AF),
                          size: 16,
                        ),
                      ),
                      SizedBox(height: 24),
                      HomeMenuField(
                        hintText: "اختر موظف...",
                        items: [
                          DropdownMenuItem(
                            value: "موظف 1",
                            child: Text("موظف 1"),
                          ),
                          DropdownMenuItem(
                            value: "موظف 2",
                            child: Text("موظف 2"),
                          ),
                        ],
                        onChanged: (value) {
                          print(value);
                        },
                        title: "تعيين موظف مسؤول",
                        icon: FontAwesomeIcons.userGroup,
                      ),
                      SizedBox(height: 24),
                      HomeTextFieldWithTitle(
                        title: "ملاحظات المطبخ",
                        hintText: "أضف ملاحظات خاصة للتجهيز...",
                        icon: FontAwesomeIcons.noteSticky,
                        maxLines: 3,
                      ),
                      SizedBox(height: 24),
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          border: Border.all(color: Color(0xFFF3F4F6)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              "الإجراءات التلقائية",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                height: 1.333,
                                letterSpacing: .6,
                              ),
                            ),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    boxShadow: [AppShadows.shadow],
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.boxesStacked,
                                    size: 14,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  children: [
                                    AppText(
                                      "سيتم خصم المخزون",
                                      style: TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 1.42,
                                      ),
                                    ),
                                    AppText(
                                      "تحديث تلقائي للكميات المتاحة",
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 10,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Divider(height: 1, color: Color(0xFFE5E7EB)),
                            SizedBox(height: 12),
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    border: Border.all(
                                      color: const Color(0xFFE5E7EB),
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    boxShadow: [AppShadows.shadow],
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.bell,
                                    size: 14,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Column(
                                  children: [
                                    AppText(
                                      "سيتم إشعار العميل",
                                      style: TextStyle(
                                        color: Color(0xFF1F2937),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        height: 1.42,
                                      ),
                                    ),
                                    AppText(
                                      'إرسال حالة "قيد التحضير" فوراً',
                                      style: TextStyle(
                                        color: Color(0xFF6B7280),
                                        fontSize: 10,
                                        height: 1.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            width: context.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                context.padding.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              ),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: AppButton(title: "تأكيد القبول", onTap: () {}),
                  ),
                  AppOutlinedButton(
                    title: "إلغاء",
                    color: const Color(0xFFFF4C51),
                    onTap: () => context.pop(),
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

class TimeChip extends StatelessWidget {
  const TimeChip({
    super.key,
    required this.minute,
    required this.isSelected,
    required this.onTap,
  });
  final int minute;
  final bool isSelected;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(12)),
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Color(0xFFEFF6FF) : AppColors.white,
            borderRadius: BorderRadius.all(Radius.circular(12)),
            border: Border.all(
              color: isSelected ? Color(0xFF3B82F6) : Color(0xFFE5E7EB),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(
                minute.toString(),
                style: TextStyle(
                  color: isSelected ? Color(0xFF1D4ED8) : Color(0xFF4B5563),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  height: 1.42,
                ),
              ),
              AppText(
                "دقيقة",
                style: TextStyle(
                  color: isSelected ? Color(0xFF1D4ED8) : Color(0xFF4B5563),
                  fontSize: 10,
                  height: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TimeChoices extends StatefulWidget {
  const TimeChoices({
    super.key,
    required this.minutes,
    required this.onChanged,
  });
  final List<int> minutes;
  final void Function(int value) onChanged;
  @override
  State<TimeChoices> createState() => _TimeChoicesState();
}

class _TimeChoicesState extends State<TimeChoices> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 4,
      children: List.generate(
        widget.minutes.length,
        (index) => Expanded(
          child: TimeChip(
            onTap: () {
              if (index != _selectedIndex) {
                _selectedIndex = index;
                setState(() {});
                widget.onChanged(_selectedIndex);
              }
            },
            minute: widget.minutes[index],
            isSelected: index == _selectedIndex,
          ),
        ),
      ),
    );
  }
}
