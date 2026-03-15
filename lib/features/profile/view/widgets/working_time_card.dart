import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_pickers.dart';
import '../../data/models/get_store_hours_model.dart';

class WorkingTimeCard extends StatefulWidget {
  const WorkingTimeCard({
    super.key,
    required this.dayName,
    required this.dayNameEn,
    required this.isToday,
    required this.dayIndex,
    required this.periods,
    required this.addedPeriods,
    required this.updatedPeriods,
    required this.deletedPeriods,
  });

  final String dayName;
  final String dayNameEn;
  final bool isToday;
  final int dayIndex;
  final List<GetStoreHoursModelDataItem> periods;
  final List<GetStoreHoursModelDataItem> addedPeriods;
  final List<GetStoreHoursModelDataItem> updatedPeriods;
  final List<GetStoreHoursModelDataItem> deletedPeriods;

  @override
  State<WorkingTimeCard> createState() => _WorkingTimeCardState();
}

class _WorkingTimeCardState extends State<WorkingTimeCard> {
  static const List<String> periods = [
    'الفترة الأولى',
    'الفترة الثانية',
    'الفترة الثالثة',
    'الفترة الرابعة',
    'الفترة الخامسة',
    'الفترة السادسة',
    'الفترة السابعة',
    'الفترة الثامنة',
    'الفترة التاسعة',
    'الفترة العاشرة',
    'الفترة الحادية عشر',
    'الفترة الثانية عشر',
    'الفترة الثالثة عشر',
    'الفترة الرابعة عشر',
    'الفترة الخامسة عشر',
    'الفترة السادسة عشر',
    'الفترة السابعة عشر',
    'الفترة الثامنة عشر',
    'الفترة التاسعة عشر',
    'الفترة العشرون',
    'الفترة الحادية والعشرون',
    'الفترة الثانية والعشرون',
    'الفترة الثالثة والعشرون',
    'الفترة الرابعة والعشرون',
  ];

  late bool isEnabled;
  late List<GetStoreHoursModelDataItem> periodsList;

  @override
  void initState() {
    super.initState();
    periodsList = [...widget.periods];
    isEnabled = periodsList.where((period) => period.isClosed == true).isEmpty;
  }

  void _openCloseDay(bool value) {
    for (int i = 0; i < widget.periods.length; i++) {
      final bool isExistsInUpdated = widget.updatedPeriods
          .where((period) => period.id == widget.periods[i].id)
          .isNotEmpty;
      final bool isExistsInDeleted = widget.deletedPeriods
          .where((period) => period.id == widget.periods[i].id)
          .isNotEmpty;
      if (!isExistsInUpdated &&
          !isExistsInDeleted &&
          widget.periods[i].isClosed != value) {
        widget.updatedPeriods.add(widget.periods[i]);
        widget.updatedPeriods.last.isClosed = value;
      } else if (widget.periods[i].isClosed == value) {
        widget.updatedPeriods.removeWhere(
          (period) => period.id == widget.periods[i].id,
        );
      }
    }
    for (int i = 0; i < widget.addedPeriods.length; i++) {
      widget.addedPeriods[i].isClosed = value;
    }
    for (int i = 0; i < widget.updatedPeriods.length; i++) {
      widget.updatedPeriods[i].isClosed = value;
    }
    print(widget.addedPeriods.length);
    print(widget.updatedPeriods.length);
  }

  void _addPeriod() {
    if (periodsList.length < 24) {
      setState(() {
        periodsList.add(GetStoreHoursModelDataItem());
        widget.addedPeriods.add(GetStoreHoursModelDataItem());
      });
    }
  }

  void _deletePeriod(int index) {
    if (periodsList.isNotEmpty) {
      if (periodsList[index].id != null) {
        print(widget.deletedPeriods.length);
        widget.updatedPeriods.removeWhere(
          (period) => periodsList[index].id == period.id,
        );
        widget.deletedPeriods.add(periodsList[index]);
        print(widget.deletedPeriods.length);
      } else {
        widget.addedPeriods.removeWhere(
          (period) =>
              period.opensAt == periodsList[index].opensAt &&
              period.closesAt == periodsList[index].closesAt,
        );
      }
      setState(() {
        periodsList.removeAt(index);
      });
    }
  }

  void _updatePeriod(int index, String? from, String? to) {
    print("update Time");
    if (periodsList[index].id == null) {
      widget.addedPeriods.removeWhere(
        (period) =>
            period.opensAt == periodsList[index].opensAt &&
            period.closesAt == periodsList[index].closesAt,
      );
    }
    setState(() {
      periodsList[index].opensAt = from;
      periodsList[index].closesAt = to;
    });
    if (periodsList[index].id != null) {
      print(widget.updatedPeriods.length);
      widget.updatedPeriods.removeWhere(
        (period) => periodsList[index].id == period.id,
      );
      widget.updatedPeriods.add(periodsList[index]);
      print(widget.updatedPeriods.length);
      print("exists");
    } else {
      widget.addedPeriods.add(periodsList[index]);
      print("not exists");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isToday ? null : AppColors.white,
        gradient: widget.isToday
            ? LinearGradient(
                colors: [Color(0xFFECFDF5), Color(0xFFD1FAE5)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(16),
        border: widget.isToday ? Border.all(color: Color(0xFFF3F4F6)) : null,
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: widget.isToday && isEnabled
                          ? Color(0xff10B981)
                          : isEnabled
                          ? const Color(0x1A1E2A78)
                          : Color(0xFFE5E7EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Icon(
                        isEnabled && widget.isToday
                            ? FontAwesomeIcons.solidCalendarCheck
                            : isEnabled
                            ? FontAwesomeIcons.calendarDay
                            : Icons.door_front_door,
                        color: isEnabled && widget.isToday
                            ? AppColors.white
                            : isEnabled
                            ? AppColors.primary
                            : Color(0xFF9CA3AF),
                        size: isEnabled ? 18 : 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              AppText.bodyMedium(
                                widget.dayName,
                                fontWeight: FontWeight.bold,
                              ),
                              if (!isEnabled) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: AppText(
                                    'مغلق',
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                              if (widget.isToday && isEnabled) ...[
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0x2B24B364),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: AppText(
                                    'اليوم',
                                    style: TextStyle(
                                      color: Color(0xFF10B981),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          AppText.labelLarge(
                            widget.dayNameEn,
                            fontWeight: FontWeight.w400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: isEnabled,
                activeTrackColor: const Color(0xff1FAF7A),
                inactiveTrackColor: const Color(0xffD1D5DB),
                onChanged: (value) {
                  /// [!value] because when it is false means [isClose = true]
                  _openCloseDay(!value);
                  setState(() {
                    isEnabled = value;
                  });
                },
              ),
            ],
          ),
          if (isEnabled) ...[
            if (periodsList.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...periodsList.asMap().entries.map((entry) {
                final index = entry.key;
                final period = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: PeriodCard(
                    periodIndex: index,
                    periodName: periods[index],
                    from: period.opensAt,
                    to: period.closesAt,
                    onDelete: () => _deletePeriod(index),
                    onTimeChanged: (from, to) => _updatePeriod(index, from, to),
                    isDeletable: index > 0,
                  ),
                );
              }),
            ],
            const SizedBox(height: 16),
            GestureDetector(
              onTap: periodsList.length < 24 ? _addPeriod : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: periodsList.length < 24
                        ? const Color(0x361E2A78)
                        : Colors.grey,
                  ),
                  color: Color(0x0F1E2A78),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: periodsList.length < 24
                          ? AppColors.primary
                          : Colors.grey,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "إضافة فترة",
                      style: TextStyle(
                        color: periodsList.length < 24
                            ? AppColors.primary
                            : Colors.grey,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          if (!isEnabled) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.nights_stay,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  AppText.labelLarge(
                    'عطلة في هذا اليوم',
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class PeriodCard extends StatefulWidget {
  const PeriodCard({
    super.key,
    required this.periodIndex,
    required this.periodName,
    this.from,
    this.to,
    required this.onDelete,
    required this.onTimeChanged,
    this.isDeletable = true,
  });

  final int periodIndex;
  final String periodName;
  final String? from;
  final String? to;
  final VoidCallback onDelete;
  final void Function(String?, String?) onTimeChanged;
  final bool isDeletable;

  @override
  State<PeriodCard> createState() => _PeriodCardState();
}

class _PeriodCardState extends State<PeriodCard> {
  late TextEditingController fromController;
  late TextEditingController toController;

  @override
  void initState() {
    super.initState();
    fromController = TextEditingController(text: widget.from);
    toController = TextEditingController(text: widget.to);
  }

  @override
  void didUpdateWidget(PeriodCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.from != widget.from) {
      fromController.text = widget.from ?? '';
    }
    if (oldWidget.to != widget.to) {
      toController.text = widget.to ?? '';
    }
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xffF9FAFB),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.labelLarge(
                widget.periodName,
                fontWeight: FontWeight.bold,
              ),
              if (widget.isDeletable)
                GestureDetector(
                  onTap: widget.onDelete,
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _timeField(
                  title: "من",
                  controller: fromController,
                  onChanged: (value) => widget.onTimeChanged(
                    value,
                    toController.text.isEmpty ? null : toController.text,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _timeField(
                  title: "إلى",
                  controller: toController,
                  onChanged: (value) => widget.onTimeChanged(
                    fromController.text.isEmpty ? null : fromController.text,
                    value,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeField({
    required String title,
    required TextEditingController controller,
    required void Function(String) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText.labelLarge(title, fontWeight: FontWeight.bold),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          readOnly: true,
          textDirection: TextDirection.ltr,
          style: TextStyle(
            color: Color(0xff1F2937),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          onTap: () async {
            final pickedTime = await AppPickers.showAppTimePicker(
              context: context,
            );
            controller.text = pickedTime;
            onChanged(pickedTime);
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 14,
            ),
            prefixIcon: const Icon(
              Icons.access_time_filled,
              size: 18,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    );
  }
}
