import 'dart:math';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_offers_weekly_summary_use_case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:iconsax_plus/iconsax_plus.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/get_offers_weekly_summary_model.dart';
import '../manager/bloc/profile_bloc.dart';

class OffersStatisticsGrid extends StatefulWidget {
  const OffersStatisticsGrid({super.key});

  @override
  State<OffersStatisticsGrid> createState() => _OffersStatisticsGridState();
}

class _OffersStatisticsGridState extends State<OffersStatisticsGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _sizeAnimation;
  late Animation<double> _rotationAnimation;
  bool _isExpanded = false;

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

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF0DB458);
    const Color grey = Color(0xFFA3AEED);
    const Color yellow = Color(0xFFF3C9A2);
    List<String> titles = ['عروض مجدولة', 'طلبات مستفيدة', 'عروض نشطة'];
    List<Color> colors = [
      Color(0xFFF3C9A2),
      Color(0xFFA3AEED),
      Color(0xFF0DB458),
    ];

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
                  previous.offersWeeklySummaryStatus !=
                  current.offersWeeklySummaryStatus,
              builder: (context, state) {
                if (state.offersWeeklySummaryStatus == BlocStatus.loading) {
                  return StatisticsLoading();
                } else if (state.offersWeeklySummaryStatus ==
                    BlocStatus.failed) {
                  return Center(
                    child: FailureWidget(
                      message: state.errorMessage.toString(),
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          GetOffersWeeklySummaryEvent(
                            params: GetOffersWeeklySummaryParams(storeId: 1),
                          ),
                        );
                      },
                    ),
                  );
                } else if (state.offersWeeklySummaryStatus ==
                    BlocStatus.success) {
                  // Replace the entire SizedBox(height: 150, ...) block with this:

                  // First, compute dynamic maxY — put this ABOVE the SizedBox, inside the BlocStatus.success branch:
                  final allSeriesValues =
                      (state.offersWeeklySummary?.data?.series ?? []).expand(
                        (day) => [
                          day.scheduledOffers?.toDouble() ?? 0,
                          day.ordersUsedOffers?.toDouble() ?? 0,
                          day.activeOffers?.toDouble() ?? 0,
                        ],
                      );

                  final maxY = allSeriesValues.isEmpty
                      ? 10.0
                      : allSeriesValues.reduce(max) * 1.2;
                  return Column(
                    children: [
                      SizedBox(height: 16),
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
                                    const days = [
                                      'جمعة',
                                      'خميس',
                                      'أربعاء',
                                      'ثلاثاء',
                                      'اثنين',
                                      'أحد',
                                      'سبت',
                                    ];
                                    final index = value.toInt();
                                    if (index < 0 || index >= days.length) {
                                      return const SizedBox.shrink();
                                    }
                                    return SideTitleWidget(
                                      meta: meta,
                                      space: 8,
                                      child: Text(
                                        days[index],
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
                              final selectedDay = state
                                  .offersWeeklySummary!
                                  .data!
                                  .series![index];

                              final double scheduledOffers =
                                  selectedDay.scheduledOffers?.toDouble() ?? 0;
                              final double ordersUsedOffers =
                                  selectedDay.ordersUsedOffers?.toDouble() ?? 0;
                              final double activeOffers =
                                  selectedDay.activeOffers?.toDouble() ?? 0;

                              return BarChartGroupData(
                                x: index,
                                barsSpace: 4,
                                barRods: [
                                  BarChartRodData(
                                    toY: activeOffers,
                                    color: green,
                                    width: 8,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                  BarChartRodData(
                                    toY: ordersUsedOffers,
                                    color: grey,
                                    width: 8,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(2),
                                    ),
                                  ),
                                  BarChartRodData(
                                    toY: scheduledOffers,
                                    color: yellow,
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
                          ...List.generate(
                            3,
                            (index) => Row(
                              children: [
                                CircleAvatar(
                                  radius: 4,
                                  backgroundColor: colors[index],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  titles[index],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12),
                      StatePointer(
                        title: "عروض منتهية",
                        value:
                            state.offersWeeklySummary!.data?.totals?.endedOffers
                                ?.formatWithComma() ??
                            "",
                        containerBorderColor: Color(0xffE5E7EB),
                        containerColor: Color(0xffF3F4F6),
                        icon: FontAwesomeIcons.ban.data,
                        iconCardColor: Color(0xffE5E7EB),
                        iconColor: Color(0xff6B7280),
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
}

class StatisticsLoading extends StatelessWidget {
  const StatisticsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    const Color green = Color(0xFF0DB458);
    const Color grey = Color(0xFFA3AEED);
    List<String> titles = ['عروض مجدولة', 'طلبات مستفيدة', 'عروض نشطة'];
    List<Color> colors = [
      Color(0xFFF3C9A2),
      Color(0xFFA3AEED),
      Color(0xFF0DB458),
    ];
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          SizedBox(height: 16),
          Container(
            height: 150,
            width: context.width,
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
          ),
          const SizedBox(height: 24),
          Row(
            spacing: 8,
            children: [
              SizedBox(width: 2),
              ...List.generate(
                3,
                (index) => Row(
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: colors[index]),
                    const SizedBox(width: 4),
                    Text(
                      titles[index],
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 12),
          StatePointer(
            title: "عروض منتهية",
            value: "8",
            containerBorderColor: Color(0xffE5E7EB),
            containerColor: Color(0xffF3F4F6),
            icon: FontAwesomeIcons.ban.data,
            iconCardColor: Color(0xffE5E7EB),
            iconColor: Color(0xff6B7280),
          ),
        ],
      ),
    );
  }
}

class StatePointer extends StatelessWidget {
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

  final String title;
  final String value;
  final IconData icon;
  final Color containerColor;
  final Color containerBorderColor;
  final Color iconCardColor;
  final Color iconColor;

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
                AppText.displaySmall(
                  value.toString(),
                  fontWeight: FontWeight.bold,
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

const Map<String, String> daysMap = {
  'monday': 'الاثنين',
  'tuesday': 'الثلاثاء',
  'wednesday': 'الأربعاء',
  'thursday': 'الخميس',
  'friday': 'الجمعة',
  'saturday': 'السبت',
  'sunday': 'الأحد',
};
