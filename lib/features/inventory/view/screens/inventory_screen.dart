import 'dart:math';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/domain/usecases/get_hourly_count_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/domain/usecases/get_products_use_case.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../data/models/get_hourly_count_model.dart';
import '../../domain/usecases/update_product_amount_use_case.dart';
import '../manager/bloc/inventory_bloc.dart';
import '../widgets/inventory_tab_bar.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  int selectedTab = 0;
  @override
  Widget build(BuildContext context) {
    final Color darkPurple = const Color(0xFF2D3FB4);
    final Color pink = const Color(0xFFF26CA5);
    final Color lightPurple = const Color(0xFFC2C8F0);
    return BlocProvider(
      create: (context) => getIt<InventoryBloc>()
        ..add(GetHourlyCountEvent(params: GetHourlyCountParams()))
        ..add(GetProductsEvent(params: GetProductsParams())),
      child: Scaffold(
        body: Column(
          children: [
            AppSimpleAppBarWithSearch(title: "المخزون"),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    Container(
                      height: 378,
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 4),
                            blurRadius: 4,
                            color: Color(0x1F5E6695),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 24),
                          Expanded(
                            child: BlocBuilder<InventoryBloc, InventoryState>(
                              buildWhen: (previous, current) =>
                                  previous.hourlyCountStatus !=
                                  current.hourlyCountStatus,
                              builder: (context, state) {
                                if (state.hourlyCountStatus ==
                                    BlocStatus.loading)
                                  return Shimmer.fromColors(
                                    baseColor: Colors.grey.shade100,
                                    highlightColor: Colors.grey.shade300,
                                    child: SizedBox(),
                                  );
                                else if (state.hourlyCountStatus ==
                                    BlocStatus.failed) {
                                  return Center(
                                    child: FailureWidget(
                                      message: state.errorMessage.toString(),
                                      onRetry: () {
                                        context.read<InventoryBloc>().add(
                                          GetHourlyCountEvent(
                                            params: GetHourlyCountParams(),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                                if (state.hourlyCountStatus ==
                                    BlocStatus.success) {
                                  final maxOrdersEachDay = [
                                    state.hourlyCount!.data!.saturday!.pending!,
                                    state.hourlyCount!.data!.sunday!.pending!,
                                    state.hourlyCount!.data!.monday!.pending!,
                                    state.hourlyCount!.data!.tuesday!.pending!,
                                    state
                                        .hourlyCount!
                                        .data!
                                        .wednesday!
                                        .pending!,
                                    state.hourlyCount!.data!.thursday!.pending!,
                                    state.hourlyCount!.data!.friday!.pending!,
                                  ];
                                  return BarChart(
                                    BarChartData(
                                      alignment: BarChartAlignment.spaceAround,
                                      maxY: maxOrdersEachDay
                                          .reduce(max)
                                          .toDouble(),
                                      barTouchData: BarTouchData(
                                        enabled: false,
                                      ),
                                      borderData: FlBorderData(show: false),
                                      gridData: FlGridData(
                                        getDrawingHorizontalLine: (value) =>
                                            FlLine(
                                              color: Color(0xFFF1F1F1),
                                              strokeWidth: 1,
                                              dashArray: [2, 2],
                                            ),
                                        drawVerticalLine: false,
                                      ),
                                      titlesData: FlTitlesData(
                                        topTitles: const AxisTitles(
                                          sideTitles: SideTitles(),
                                        ),
                                        leftTitles: const AxisTitles(
                                          sideTitles: SideTitles(),
                                        ),
                                        rightTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 30,
                                            // interval: 5,
                                            getTitlesWidget: (value, meta) {
                                              if (value % 10 != 0 &&
                                                  value !=
                                                      maxOrdersEachDay
                                                          .reduce(max)
                                                          .toDouble()) {
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
                                                  value.toInt() >=
                                                      days.length) {
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
                                        GetHourlyCountModelDataItem
                                        selectedDay = switch (index + 1) {
                                          1 => state.hourlyCount!.data!.friday!,
                                          2 =>
                                            state.hourlyCount!.data!.thursday!,
                                          3 =>
                                            state.hourlyCount!.data!.wednesday!,
                                          4 =>
                                            state.hourlyCount!.data!.tuesday!,
                                          5 => state.hourlyCount!.data!.monday!,
                                          6 => state.hourlyCount!.data!.sunday!,
                                          7 =>
                                            state.hourlyCount!.data!.saturday!,
                                          _ => throw ArgumentError(
                                            "incorrect day (out of [1 -> 7] days)",
                                          ),
                                        };
                                        return BarChartGroupData(
                                          x: index,
                                          barRods: [
                                            BarChartRodData(
                                              toY: selectedDay.pending!
                                                  .toDouble(),
                                              width: 20,
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                    top: Radius.circular(6),
                                                  ),
                                              rodStackItems: [
                                                BarChartRodStackItem(
                                                  0,
                                                  selectedDay.completed!
                                                      .toDouble(),
                                                  darkPurple,
                                                ),
                                                BarChartRodStackItem(
                                                  selectedDay.completed!
                                                      .toDouble(),
                                                  selectedDay.completed!
                                                          .toDouble() +
                                                      selectedDay.preparing!
                                                          .toDouble(),
                                                  pink,
                                                ),
                                                BarChartRodStackItem(
                                                  selectedDay.completed!
                                                          .toDouble() +
                                                      selectedDay.preparing!
                                                          .toDouble(),
                                                  selectedDay.completed!
                                                          .toDouble() +
                                                      selectedDay.preparing!
                                                          .toDouble() +
                                                      selectedDay.pending!
                                                          .toDouble() +
                                                      20,
                                                  lightPurple,
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 8,
                            children: [
                              SizedBox(width: 2),
                              Row(
                                children: [
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: pink,
                                  ),
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
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: lightPurple,
                                  ),
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
                                  CircleAvatar(
                                    radius: 4,
                                    backgroundColor: darkPurple,
                                  ),
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
                          SizedBox(height: 16),
                          BlocBuilder<InventoryBloc, InventoryState>(
                            buildWhen: (previous, current) =>
                                previous.productsStatus !=
                                current.productsStatus,
                            builder: (context, state) {
                              num budget = 0;
                              if (state.products?.data != null) {
                                for (final product in state.products!.data!) {
                                  budget +=
                                      (double.tryParse(product.price ?? "") ??
                                          0.0) *
                                      (product.stockQuantity ?? 0);
                                }
                              }
                              return Container(
                                padding: EdgeInsets.fromLTRB(12, 22, 16, 21),
                                decoration: BoxDecoration(
                                  color: Color(0x1F8591E0),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    AppText(
                                      "قيمة المخزون",
                                      style: TextStyle(
                                        color: Color(0xB22F2B3D),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Spacer(),
                                    AppText(
                                      budget.formatWithComma(),
                                      style: TextStyle(
                                        color: context.primary,
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        height: 1.333,
                                      ),
                                    ),
                                    SizedBox(width: 22),
                                    AppText(
                                      "ل.س",
                                      style: TextStyle(
                                        color: context.primary,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    BlocConsumer<InventoryBloc, InventoryState>(
                      listener: (context, state) {},
                      buildWhen: (previous, current) =>
                          previous.productsStatus != current.productsStatus,
                      builder: (context, state) {
                        if (state.productsStatus == BlocStatus.loading) {
                          return ProductsLoading();
                        } else if (state.productsStatus == BlocStatus.failed) {
                          return FailureWidget(
                            message: state.errorMessage.toString(),
                            onRetry: () {
                              context.read<InventoryBloc>().add(
                                GetProductsEvent(params: GetProductsParams()),
                              );
                            },
                          );
                        } else if (state.productsStatus == BlocStatus.success) {
                          return Column(
                            children: [
                              InventoryTabBar(
                                items: [
                                  InventoryTabBarItem(
                                    title: "الكل",
                                    count: state.products?.data?.length ?? 0,
                                  ),
                                  InventoryTabBarItem(
                                    title: "طبيعي",
                                    count:
                                        state.products?.data
                                            ?.where(
                                              (item) =>
                                                  item.stockQuantity! >=
                                                  item.lowStockThreshold!,
                                            )
                                            .length ??
                                        0,
                                  ),
                                  InventoryTabBarItem(
                                    title: "منخفض",
                                    count:
                                        state.products?.data
                                            ?.where(
                                              (item) =>
                                                  item.stockQuantity! <
                                                  item.lowStockThreshold!,
                                            )
                                            .length ??
                                        0,
                                  ),
                                ],
                                onChanged: (index) {
                                  print(index);
                                  if (index == selectedTab) return;
                                  selectedTab = index;
                                  setState(() {});
                                },
                              ),
                              // products
                              ...List.generate(
                                selectedTab == 0
                                    ? state.products?.data?.length ?? 0
                                    : selectedTab == 1
                                    ? state.products?.data
                                              ?.where(
                                                (item) =>
                                                    item.stockQuantity! >=
                                                    item.lowStockThreshold!,
                                              )
                                              .length ??
                                          0
                                    : state.products?.data
                                              ?.where(
                                                (item) =>
                                                    item.stockQuantity! <
                                                    item.lowStockThreshold!,
                                              )
                                              .length ??
                                          0,
                                (index) => InventoryCard(
                                  amount: state
                                      .products!
                                      .data![index]
                                      .stockQuantity!,
                                  lowStock: state
                                      .products!
                                      .data![index]
                                      .lowStockThreshold!,
                                  companyName: state
                                      .products!
                                      .data![index]
                                      .category!
                                      .name!,
                                  name: state.products!.data![index].name!,
                                  unit: "كغ",
                                  onIncreaseTap: () async {
                                    int? incrementQuantity = await showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<InventoryBloc>(),
                                        child: EditProductAmount(
                                          type: EditingType.increment,
                                          productId:
                                              state.products!.data![index].id!,
                                        ),
                                      ),
                                    );
                                    if (incrementQuantity == null) return;
                                    state.products!.data![index].stockQuantity =
                                        state
                                            .products!
                                            .data![index]
                                            .stockQuantity! +
                                        incrementQuantity;
                                    setState(() {});
                                  },
                                  onDecreaseTap: () async {
                                    int? decrementQuantity = await showDialog(
                                      context: context,
                                      builder: (_) => BlocProvider.value(
                                        value: context.read<InventoryBloc>(),
                                        child: EditProductAmount(
                                          type: EditingType.decrement,
                                          productId:
                                              state.products!.data![index].id!,
                                        ),
                                      ),
                                    );
                                    if (decrementQuantity == null) return;
                                    state.products!.data![index].stockQuantity =
                                        state
                                            .products!
                                            .data![index]
                                            .stockQuantity! -
                                        decrementQuantity;
                                    setState(() {});
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                        return SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum EditingType { increment, decrement, set }

class EditProductAmount extends StatefulWidget {
  const EditProductAmount({
    super.key,
    required this.type,
    required this.productId,
  });
  final EditingType type;
  final int productId;

  @override
  State<EditProductAmount> createState() => _EditProductAmountState();
}

class _EditProductAmountState extends State<EditProductAmount> {
  int quantity = 0;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData.light(),
      child: SizedBox(
        height: 200,
        child: AlertDialog(
          backgroundColor: AppColors.white,
          title: Text(
            widget.type == EditingType.increment
                ? "زيادة كمية المنتج"
                : "نقص كمية المنتج",
          ),
          content: AppTextField(
            title:
                "مقدار ${widget.type == EditingType.increment ? "الزيادة" : "النقصان"}",
            hintText: "0",
            keyboardType: TextInputType.number,
            onChanged: (value) {
              if (int.tryParse(value) != null) {
                quantity = int.parse(value);
              }
            },
          ),
          actions: [
            BlocConsumer<InventoryBloc, InventoryState>(
              buildWhen: (previous, current) =>
                  previous.productAmountStatus != current.productAmountStatus,
              listener: (context, state) {
                if (state.productAmountStatus == BlocStatus.success) {
                  Navigator.of(context).pop(quantity);
                }
              },
              builder: (context, state) {
                if (state.productAmountStatus == BlocStatus.loading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        context.read<InventoryBloc>().add(
                          UpdateProductAmountEvent(
                            params: UpdateProductAmountParams(
                              operation: widget.type,
                              productId: widget.productId,
                              quantity: quantity,
                            ),
                          ),
                        );
                      },
                      child: Text("تحديث"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("إلغاء"),
                    ),
                  ],
                );
              },
            ),
            // TextButton()
          ],
        ),
      ),
    );
  }
}

class ProductsLoading extends StatelessWidget {
  const ProductsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          InventoryTabBar(
            items: [
              InventoryTabBarItem(title: "الكل", count: 158),
              InventoryTabBarItem(title: "طبيعي", count: 34),
              InventoryTabBarItem(title: "منخفض", count: 12),
            ],
            onChanged: (index) {
              print(index);
            },
          ),
          // products
          ...List.generate(
            2,
            (index) => InventoryCard(
              amount: 4.5,
              lowStock: 5,
              companyName: "شركة كرزة",
              name: "زيت مازولا",
              unit: "لتر",
            ),
          ),
        ],
      ),
    );
  }
}

class InventoryCard extends StatelessWidget {
  const InventoryCard({
    super.key,
    required this.name,
    required this.companyName,
    required this.amount,
    required this.lowStock,
    required this.unit,
    this.onIncreaseTap,
    this.onDecreaseTap,
  });
  final String name;
  final String companyName;
  final num amount;
  final num lowStock;
  final String unit;
  final void Function()? onIncreaseTap;
  final void Function()? onDecreaseTap;

  @override
  Widget build(BuildContext context) {
    final color = lowStock >= amount ? Color(0xFFE64449) : Color(0xFF24B364);
    return Container(
      padding: EdgeInsets.only(right: 8),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
        border: Border(right: BorderSide(color: color, width: 4)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: AppImage.asset(
                  AppImages.burgerImage,
                  width: 70,
                  height: 87,
                  fit: BoxFit.cover,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 14),
                    AppText(
                      name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                        height: 1.42,
                      ),
                    ),
                    SizedBox(height: 10),
                    AppText(
                      companyName,
                      style: TextStyle(
                        fontSize: 10,
                        color: Color(0xFF111827),
                        height: 2,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    SizedBox(height: 11),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "$amount $unit",
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: color,
                            ),
                          ),
                          WidgetSpan(
                            child: CircleAvatar(
                              radius: 2,
                              backgroundColor: Color(0xFFD1D5DB),
                            ),
                          ),
                          TextSpan(text: "الحد الأدنى: $lowStock $unit"),
                        ],
                      ),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .08),
                  border: Border(
                    bottom: BorderSide(color: color.withValues(alpha: .16)),
                    right: BorderSide(color: color.withValues(alpha: .16)),
                  ),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: color),
                    SizedBox(width: 4),
                    AppText.labelSmall(
                      lowStock >= amount ? "منخفض" : "طبيعي",
                      style: TextStyle(
                        color: color,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: InventoryCardButton(
                  color: AppColors.accent,
                  label: "إضافة الكمية",
                  icon: FontAwesomeIcons.plus,
                  onTap: onIncreaseTap,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: InventoryCardButton(
                  color: Color(0xFF9CA3AF),
                  label: "تقليل الكمية",
                  icon: FontAwesomeIcons.minus,
                  onTap: onDecreaseTap,
                ),
              ),
              SizedBox(width: 8),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}

class InventoryCardButton extends StatelessWidget {
  const InventoryCardButton({
    super.key,
    required this.color,
    required this.label,
    required this.icon,
    this.onTap,
  });
  final Color color;
  final String label;
  final IconData icon;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: AppColors.white),
            SizedBox(width: 15),
            AppText(
              label,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.333,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
