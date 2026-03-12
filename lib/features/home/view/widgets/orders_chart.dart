import 'dart:math';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_daily_count_use_case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/models/get_daily_count_model.dart';
import '../manager/bloc/home_bloc.dart';

class OrdersChartCard extends StatelessWidget {
  const OrdersChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    final Color darkPurple = const Color(0xFF2D3FB4);
    final Color pink = const Color(0xFFF26CA5);
    final Color lightPurple = const Color(0xFFC2C8F0);
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.dailyCountStatus != current.dailyCountStatus,
      builder: (context, state) {
        if (state.dailyCountStatus == BlocStatus.loading) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              width: double.infinity,
              height: 336,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Colors.white,
              ),
            ),
          );
        } else if (state.dailyCountStatus == BlocStatus.failed) {
          return Center(
            child: FailureWidget(
              message: state.errorMessage ?? "Error an occurred",
              onRetry: () {
                context.read<HomeBloc>().add(
                  GetDailyCountEvent(params: GetDailyCountParams()),
                );
              },
            ),
          );
        } else if (state.dailyCountStatus == BlocStatus.success) {
          final maxOrdersEachDay = [
            state.dailyCount!.data!.saturday!.pending!,
            state.dailyCount!.data!.sunday!.pending!,
            state.dailyCount!.data!.monday!.pending!,
            state.dailyCount!.data!.tuesday!.pending!,
            state.dailyCount!.data!.wednesday!.pending!,
            state.dailyCount!.data!.thursday!.pending!,
            state.dailyCount!.data!.friday!.pending!,
          ];
          return Container(
            height: 336,
            padding: const EdgeInsets.fromLTRB(12, 24, 18, 11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Color(0x243F456C),
                  blurRadius: 5.3,
                  offset: const Offset(0, 4),
                ),
                BoxShadow(
                  color: Color(0x243F456C),
                  blurRadius: 3.5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      'الطلبات',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: context.primary,
                      ),
                    ),
                    AppText(
                      'هذا الأسبوع      ',
                      style: TextStyle(fontSize: 14, color: context.primary),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  '${maxOrdersEachDay.reduce((value, element) => value + element)} طلب',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: context.primary,
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: maxOrdersEachDay.reduce(max).toDouble(),
                      barTouchData: BarTouchData(enabled: false),
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: Color(0xFFF1F1F1),
                          strokeWidth: 1,
                          dashArray: [2, 2],
                        ),
                        drawVerticalLine: false,
                      ),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(sideTitles: SideTitles()),
                        leftTitles: const AxisTitles(sideTitles: SideTitles()),
                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                            // interval: 5,
                            getTitlesWidget: (value, meta) {
                              if (value % 10 != 0 &&
                                  value !=
                                      maxOrdersEachDay.reduce(max).toDouble()) {
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
                              if (value.toInt() < 0 ||
                                  value.toInt() >= days.length) {
                                return const SizedBox.shrink();
                              }
                              return SideTitleWidget(
                                meta: meta,
                                space: 8,
                                child: Text(
                                  days[value.toInt()],
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
                        // select the date
                        GetDailyCountModelDataItem selectedDay = switch (index +
                            1) {
                          1 => state.dailyCount!.data!.friday!,
                          2 => state.dailyCount!.data!.thursday!,
                          3 => state.dailyCount!.data!.wednesday!,
                          4 => state.dailyCount!.data!.tuesday!,
                          5 => state.dailyCount!.data!.monday!,
                          6 => state.dailyCount!.data!.sunday!,
                          7 => state.dailyCount!.data!.saturday!,
                          _ => throw ArgumentError(
                            "incorrect day (out of [1 -> 7] days)",
                          ),
                        };
                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            BarChartRodData(
                              toY: selectedDay.pending!.toDouble(),
                              width: 20,
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(6),
                              ),
                              rodStackItems: [
                                BarChartRodStackItem(
                                  0,
                                  selectedDay.completed!.toDouble(),
                                  darkPurple,
                                ),
                                BarChartRodStackItem(
                                  selectedDay.completed!.toDouble(),
                                  selectedDay.completed!.toDouble() +
                                      selectedDay.preparing!.toDouble(),
                                  pink,
                                ),
                                BarChartRodStackItem(
                                  selectedDay.completed!.toDouble() +
                                      selectedDay.preparing!.toDouble(),
                                  selectedDay.completed!.toDouble() +
                                      selectedDay.preparing!.toDouble() +
                                      selectedDay.pending!.toDouble() +
                                      20,
                                  lightPurple,
                                ),
                              ],
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
                        CircleAvatar(radius: 4, backgroundColor: pink),
                        const SizedBox(width: 4),
                        Text(
                          'طلبات جديدة',
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
                        CircleAvatar(radius: 4, backgroundColor: lightPurple),
                        const SizedBox(width: 4),
                        Text(
                          'طلبات قيد التحضير',
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
                        CircleAvatar(radius: 4, backgroundColor: darkPurple),
                        const SizedBox(width: 4),
                        Text(
                          'طلبات مكتملة',
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
              ],
            ),
          );
        } else {
          return SizedBox();
        }
      },
    );
  }
}
