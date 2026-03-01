import 'package:common_package/common_package.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class OrdersHourStatisticsCard extends StatelessWidget {
  const OrdersHourStatisticsCard({
    super.key,
    required this.hours,
    required this.values,
  });
  final List<int> hours; //= [10, 11, 12, 13, 14, 15];
  final List<double> values; //= [23, 11, 43, 37, 16, 26];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: context.onPrimary,
        border: Border.all(color: Color(0xffF3F4F6), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(4),
            offset: Offset(0, 2),
            blurRadius: 10,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bodyLarge(
                'نشاط الطلبات (ساعات)',
                fontWeight: FontWeight.bold,
              ),
              // AppImage.asset(
              //   Assets.imagesStatisticsIcon,
              //   width: 18,
              //   height: 18,
              // ),
            ],
          ),
          SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              BarChartData(
                maxY: 50,
                minY: 0,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < hours.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: AppText.labelMedium(
                              '${hours[index]}',
                              color: Color(0xff6B7280),
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                        return Text('');
                      },
                      reservedSize: 30,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        if (value == meta.min || value == meta.max) {
                          return Text('');
                        }
                        return AppText.labelSmall(
                          value.toInt().toString(),
                          color: Color(0xff9CA3AF),
                          fontWeight: FontWeight.w400,
                        );
                      },
                      interval: 10,
                    ),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Color(0xffF3F4F6), strokeWidth: 1);
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  hours.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: values[index],
                        color: hours[index] == 12
                            ? context.secondary
                            : context.primary,
                        width: 24,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                    barsSpace: 8,
                  ),
                ),
                alignment: BarChartAlignment.spaceAround,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
