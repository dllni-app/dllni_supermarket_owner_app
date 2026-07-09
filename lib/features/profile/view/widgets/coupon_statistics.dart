import 'dart:math';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_coupon_week_analysis_use_case.dart';
import '../manager/bloc/profile_bloc.dart';

class CouponsStatistics extends StatefulWidget {
  const CouponsStatistics({super.key});

  @override
  State<CouponsStatistics> createState() => _CouponsStatisticsState();
}

class CouponStatisticsLoading extends StatelessWidget {
  const CouponStatisticsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade300,
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: context.width,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 8,
            children: [
              SizedBox(width: 2),
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: AppColors.white),
                  const SizedBox(width: 4),
                  Text(
                    "كوبونات نشطة",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  CircleAvatar(radius: 4, backgroundColor: AppColors.white),
                  const SizedBox(width: 4),
                  Text(
                    "كوبونات منتهية",
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          StatePointer(
            title: 'إجمالي الخصومات (ل.س)',
            value: 123450.formatWithComma(),
            containerBorderColor: Color(0xffF59E0B).withAlpha(51),
            containerColor: Color(0xffF59E0B).withAlpha(25),
            icon: FontAwesomeIcons.database.data,
            iconCardColor: Color(0xffF59E0B).withAlpha(51),
            iconColor: Color(0xffF59E0B),
          ),
        ],
      ),
    );
  }
}

class StatePointer extends StatelessWidget {
  final String title;

  final String value;
  final IconData icon;
  final Color containerColor;
  final Color containerBorderColor;
  final Color iconCardColor;
  final Color iconColor;
  const StatePointer({
    super.key,
    required this.title,
    required this.value,
    required this.containerColor,
    required this.containerBorderColor,
    required this.iconCardColor,
    required this.iconColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: containerBorderColor),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 15,
            color: Color(0x07000000),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: iconCardColor,
            ),
            padding: EdgeInsetsDirectional.all(11),
            child: Icon(icon, color: iconColor, size: 18),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  value.toString(),
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    height: 1.333,
                  ),
                ),
                SizedBox(height: 2),
                AppText.labelMedium(
                  title,
                  color: Color(0xff4B5563),
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CouponsStatisticsState extends State<CouponsStatistics>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF0DB458);
    const Color grey = Color(0xFF9CA3AF);
    return Container(
      decoration: BoxDecoration(
        color: context.onPrimary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.symmetric(horizontal: 17, vertical: 17),
      margin: EdgeInsetsDirectional.symmetric(horizontal: 24),
      child: Column(
        children: [
          InkWell(
            onTap: _toggleExpansion,
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xffDBEAFE),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: EdgeInsetsDirectional.all(10),
                  child: Icon(
                    IconsaxPlusBold.status_up,
                    size: 24,
                    color: context.primary,
                  ),
                ),
                SizedBox(width: 12),
                AppText.bodyMedium(
                  'الإحصائيات',
                  fontWeight: FontWeight.bold,
                  color: Color(0xff111827),
                ),
                Spacer(),
                RotationTransition(
                  turns: _rotationAnimation,
                  child: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Color(0xff9CA3AF),
                    size: 25,
                  ),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _sizeAnimation,
            axisAlignment: -1.0,
            child: BlocBuilder<ProfileBloc, ProfileState>(
              buildWhen: (previous, current) =>
                  previous.couponWeekAnalysisStatus !=
                  current.couponWeekAnalysisStatus,
              builder: (context, state) {
                if (state.couponWeekAnalysisStatus == BlocStatus.loading) {
                  return CouponStatisticsLoading();
                } else if (state.couponWeekAnalysisStatus ==
                    BlocStatus.failed) {
                  return Center(
                    child: FailureWidget(
                      message: state.errorMessage.toString(),
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          GetCouponWeekAnalysisEvent(
                            params: GetCouponWeekAnalysisParams(storeId: 1),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state.couponWeekAnalysisStatus ==
                    BlocStatus.success) {
                  final allDays = state.couponWeekAnalysis?.data?.days ?? [];

                  double getVal(String day, bool active) {
                    final d = allDays.firstWhere((e) => e.day == day);
                    return active
                        ? (d.activeCoupons?.toDouble() ?? 0)
                        : (d.inactiveCoupons?.toDouble() ?? 0);
                  }

                  final dayKeys = [
                    'Fri',
                    'Thu',
                    'Wed',
                    'Tue',
                    'Mon',
                    'Sun',
                    'Sat',
                  ];

                  final allValues = dayKeys.expand(
                    (key) => [getVal(key, true), getVal(key, false)],
                  );

                  final maxY = allValues.isEmpty
                      ? 10.0
                      : allValues.reduce(max) * 1.2;
                  return Column(
                    children: [
                      SizedBox(height: 30),
                      SizedBox(
                        height: 150,
                        child: BarChart(
                          BarChartData(
                            alignment: BarChartAlignment.spaceAround,
                            maxY: maxY == 0 ? 10 : maxY,
                            groupsSpace: 12,
                            barTouchData: BarTouchData(enabled: false),
                            borderData: FlBorderData(show: false),
                            gridData: FlGridData(
                              getDrawingHorizontalLine: (value) => const FlLine(
                                color: Color(0xFFF1F1F1),
                                strokeWidth: 1,
                                dashArray: [2, 2],
                              ),
                              drawVerticalLine: false,
                            ),
                            titlesData: FlTitlesData(
                              topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              leftTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    if (value % 10 != 0 && value != maxY) {
                                      return const SizedBox.shrink();
                                    }
                                    return SideTitleWidget(
                                      meta: meta,
                                      child: Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (value, meta) {
                                    const dayLabels = [
                                      'جمعة',
                                      'خميس',
                                      'أربعاء',
                                      'ثلاثاء',
                                      'اثنين',
                                      'أحد',
                                      'سبت',
                                    ];
                                    final index = value.toInt();
                                    if (index < 0 ||
                                        index >= dayLabels.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return SideTitleWidget(
                                      meta: meta,
                                      space: 8,
                                      child: Text(
                                        dayLabels[index],
                                        style: const TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            barGroups: List.generate(7, (index) {
                              final key = dayKeys[index];
                              final day = allDays.firstWhere(
                                (e) => e.day == key,
                              );

                              final activeY =
                                  day.activeCoupons?.toDouble() ?? 0;
                              final inactiveY =
                                  day.inactiveCoupons?.toDouble() ?? 0;

                              return BarChartGroupData(
                                x: index,
                                barsSpace: 4,
                                barRods: [
                                  BarChartRodData(
                                    toY: inactiveY,
                                    color: grey,
                                    width: 8,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                  BarChartRodData(
                                    toY: activeY,
                                    color: green,
                                    width: 8,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        spacing: 8,
                        children: [
                          SizedBox(width: 2),
                          Row(
                            children: [
                              CircleAvatar(radius: 4, backgroundColor: green),
                              const SizedBox(width: 4),
                              Text(
                                "كوبونات نشطة",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              CircleAvatar(radius: 4, backgroundColor: grey),
                              const SizedBox(width: 4),
                              Text(
                                "كوبونات منتهية",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      StatePointer(
                        title: 'إجمالي الخصومات (ل.س)',
                        value:
                            state
                                .couponWeekAnalysis
                                ?.data
                                ?.totalUsedDiscountAmount
                                ?.formatWithComma() ??
                            "0",
                        containerBorderColor: Color(0xffF59E0B).withAlpha(51),
                        containerColor: Color(0xffF59E0B).withAlpha(25),
                        icon: FontAwesomeIcons.database.data,
                        iconCardColor: Color(0xffF59E0B).withAlpha(51),
                        iconColor: Color(0xffF59E0B),
                      ),
                    ],
                  );
                }
                return SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sizeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _rotationAnimation = Tween<double>(begin: 0.5, end: 0.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.value = 0.0;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }
}
