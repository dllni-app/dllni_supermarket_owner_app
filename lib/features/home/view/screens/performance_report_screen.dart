import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../domain/usecases/get_performance_report_use_case.dart';
import '../manager/bloc/home_bloc.dart';

@AutoRoutePage(path: "/performance_report")
class PerformanceReportScreen extends StatefulWidget {
  const PerformanceReportScreen({super.key});

  @override
  State<PerformanceReportScreen> createState() =>
      _PerformanceReportScreenState();
}

class _PerformanceReportScreenState extends State<PerformanceReportScreen> {
  int selectedPeriod = 0;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<HomeBloc>()
        ..add(GetPerformanceReportEvent(params: GetPerformanceReportParams())),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            AppSimpleAppBar(title: "تقارير الأداء"),
            SizedBox(height: 24),
            Builder(
              builder: (context) {
                return _SimpleTabBar(
                  tabsTitles: [
                    "اليوم",
                    "هذا الأسبوع",
                    "هذا الشهر",
                    "آخر 3 أشهر",
                    "آخر 6 أشهر",
                    "هذا العام",
                  ],
                  onChanged: (index) {
                    if (index != selectedPeriod) {
                      selectedPeriod = index;
                      context.read<HomeBloc>().add(
                        GetPerformanceReportEvent(
                          params: GetPerformanceReportParams(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: BlocConsumer<HomeBloc, HomeState>(
                  listener: (context, state) {
                    if (state.performanceReportStatus == BlocStatus.failed) {
                      AppToast.showToast(
                        context: context,
                        message: state.errorMessage.toString(),
                        type: ToastificationType.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state.performanceReportStatus == BlocStatus.loading) {
                      return PerformanceReportLoading();
                    } else if (state.performanceReportStatus ==
                        BlocStatus.failed) {
                      return SizedBox(
                        height: 240,
                        width: context.width,
                        child: Center(
                          child: FailureWidget(
                            message: state.errorMessage.toString(),
                            onRetry: () {
                              context.read<HomeBloc>().add(
                                GetPerformanceReportEvent(
                                  params: GetPerformanceReportParams(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state.performanceReportStatus ==
                        BlocStatus.success) {
                      return Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              border: Border.all(color: Color(0xFFF3F4F6)),
                              boxShadow: [AppShadows.shadow],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: AppText(
                                        "أكثر المنتجات مبيعاً",
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5,
                                        ),
                                      ),
                                    ),
                                    // InkWell(
                                    //   onTap: () {},
                                    //   borderRadius: BorderRadius.all(
                                    //     Radius.circular(16),
                                    //   ),
                                    //   child: Row(
                                    //     spacing: 4,
                                    //     mainAxisSize: MainAxisSize.min,
                                    //     children: [
                                    //       AppText(
                                    //         "عرض الكل",
                                    //         style: TextStyle(
                                    //           color: Color(0xFF064E3B),
                                    //           fontSize: 12,
                                    //           fontWeight: FontWeight.w700,
                                    //           height: 1.333,
                                    //         ),
                                    //       ),
                                    //       Icon(
                                    //         Icons.arrow_forward_ios,
                                    //         size: 12,
                                    //         color: Color(0xFF064E3B),
                                    //       ),
                                    //     ],
                                    //   ),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 32),
                                Center(
                                  child: AppText(
                                    "لا يوجد منتجات للعرض",
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xFF4B5563),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 1.333,
                                    ),
                                  ),
                                ),
                                // ListView.separated(
                                //   physics: const NeverScrollableScrollPhysics(),
                                //   padding: EdgeInsets.zero,
                                //   shrinkWrap: true,
                                //   itemBuilder: (_, index) =>
                                //       _ProductPerformanceCard(),
                                //   separatorBuilder: (_, _) =>
                                //       SizedBox(height: 12),
                                //   itemCount: 3,
                                // ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: _StatisticCard(
                                  label: "إجمالي المبيعات",
                                  icon: FontAwesomeIcons.solidMoneyBill1,
                                  value: state
                                      .performanceReport!
                                      .operationalMetrics!
                                      .completionRate!
                                      .formatWithComma(),
                                  color: Color(0xFF064E3B),
                                ),
                              ),
                              Expanded(
                                child: _StatisticCard(
                                  label: "عدد الطلبات",
                                  icon: FontAwesomeIcons.receipt,
                                  value: state
                                      .performanceReport!
                                      .operationalMetrics!
                                      .totalOrders!
                                      .formatWithComma(),
                                  color: Color(0xFFD97706),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: _StatisticCard(
                                  label: "متوسط قيمة الطلب",
                                  icon: FontAwesomeIcons.calculator,
                                  value: state
                                      .performanceReport!
                                      .operationalMetrics!
                                      .averageBasketValue!
                                      .formatWithComma(),
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              Expanded(
                                child: _StatisticCard(
                                  label: "معدل إلغاء الطلبات",
                                  icon: FontAwesomeIcons.x,
                                  value:
                                      "${state.performanceReport!.operationalMetrics!.cancellationRate!}%",
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              border: Border.all(color: Color(0xFFF3F4F6)),
                              boxShadow: [AppShadows.shadow],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AppText(
                                  "أكثر المنتجات مبيعاً",
                                  style: TextStyle(
                                    color: Color(0xFF111827),
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    height: 1.5,
                                  ),
                                ),
                                SizedBox(height: 16),
                                _ProductsProgressIndicator(
                                  label: "طلبات استخدمت عروض",
                                  value: "0 طلب",
                                  icon: FontAwesomeIcons.tags,
                                  color: Color(0xFF064E3B),
                                  percent: 0,
                                ),
                                SizedBox(height: 16),
                                _ProductsProgressIndicator(
                                  label: "إيرادات من العروض",
                                  value: "0 ل.س",
                                  icon: FontAwesomeIcons.moneyBillWave,
                                  color: Color(0xFF10B981),
                                ),
                                SizedBox(height: 16),
                                BestOfferCard(),
                              ],
                            ),
                          ),
                          SizedBox(height: 24),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PerformanceReportLoading extends StatelessWidget {
  const PerformanceReportLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: Color(0xFFF3F4F6)),
              boxShadow: [AppShadows.shadow],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      "أكثر المنتجات مبيعاً",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      child: Row(
                        spacing: 4,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            "عرض الكل",
                            style: TextStyle(
                              color: Color(0xFF064E3B),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              height: 1.333,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 12,
                            color: Color(0xFF064E3B),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemBuilder: (_, index) => _ProductPerformanceCard(),
                  separatorBuilder: (_, _) => SizedBox(height: 12),
                  itemCount: 3,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: _StatisticCard(
                  label: "إجمالي المبيعات",
                  icon: FontAwesomeIcons.solidMoneyBill1,
                  value: 45765.formatWithComma(),
                  color: Color(0xFF064E3B),
                ),
              ),
              Expanded(
                child: _StatisticCard(
                  label: "عدد الطلبات",
                  icon: FontAwesomeIcons.receipt,
                  value: 328.formatWithComma(),
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: _StatisticCard(
                  label: "متوسط قيمة الطلب",
                  icon: FontAwesomeIcons.calculator,
                  value: 340.formatWithComma(),
                  color: Color(0xFF10B981),
                ),
              ),
              Expanded(
                child: _StatisticCard(
                  label: "معدل إلغاء الطلبات",
                  icon: FontAwesomeIcons.x,
                  value: "5.2%",
                  color: Color(0xFFEF4444),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.all(Radius.circular(16)),
              border: Border.all(color: Color(0xFFF3F4F6)),
              boxShadow: [AppShadows.shadow],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "أكثر المنتجات مبيعاً",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 16),
                _ProductsProgressIndicator(
                  label: "طلبات استخدمت عروض",
                  value: "142 طلب",
                  icon: FontAwesomeIcons.tags,
                  color: Color(0xFF064E3B),
                  percent: 43.3,
                ),
                SizedBox(height: 16),
                _ProductsProgressIndicator(
                  label: "إيرادات من العروض",
                  value: "19,880 ل.س",
                  icon: FontAwesomeIcons.moneyBillWave,
                  color: Color(0xFF10B981),
                ),
                SizedBox(height: 16),
                BestOfferCard(),
              ],
            ),
          ),
          SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SimpleTabBar extends StatefulWidget {
  const _SimpleTabBar({required this.tabsTitles, required this.onChanged});
  final List<String> tabsTitles;
  final void Function(int index) onChanged;
  @override
  State<_SimpleTabBar> createState() => _SimpleTabBarState();
}

class _SimpleTabBarState extends State<_SimpleTabBar> {
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 18),
        scrollDirection: Axis.horizontal,
        itemBuilder: (_, index) => InkWell(
          onTap: () {
            if (index == selectedIndex) return;
            selectedIndex = index;
            setState(() {});
            widget.onChanged(selectedIndex);
          },
          borderRadius: BorderRadius.all(Radius.circular(100)),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: selectedIndex == index
                  ? Color(0xFF064E3B)
                  : Color(0xFFF3F4F6),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
            child: AppText(
              widget.tabsTitles[index],
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: selectedIndex == index
                    ? Color(0xFFFFFFFF)
                    : Color(0xFF374151),
                height: 1.333,
              ),
            ),
          ),
        ),
        separatorBuilder: (_, _) => SizedBox(width: 8),
        itemCount: widget.tabsTitles.length,
      ),
    );
  }
}

class _ProductPerformanceCard extends StatelessWidget {
  const _ProductPerformanceCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Row(
        spacing: 12,
        children: [
          AppImage.asset(
            AppImages.burgerImage,
            size: 64,
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "أرابيكا نكهة الخل",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    AppText(
                      "112 طلب",
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                      ),
                    ),
                    Text(
                      "•",
                      style: TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 12,
                        height: 1.333,
                      ),
                    ),
                    AppText(
                      "5,000 ل.س",
                      style: TextStyle(
                        color: Color(0xFF064E3B),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.333,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Color(0x1A10B981),
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
            child: Text(
              "3",
              style: TextStyle(
                color: Color(0xFF10B981),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                height: 1.333,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatisticCard extends StatelessWidget {
  const _StatisticCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 7,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: color.withValues(alpha: .2),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: AppText(
                  label,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.333,
                  ),
                ),
              ),
            ],
          ),
          AppText(
            value,
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsProgressIndicator extends StatelessWidget {
  const _ProductsProgressIndicator({
    this.percent,
    required this.color,
    required this.label,
    required this.value,
    required this.icon,
  });
  final double? percent;
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: color.withValues(alpha: .2),
                ),
                child: Icon(icon, size: 18, color: color),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      label,
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                      ),
                    ),
                    AppText(
                      value,
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.556,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8),
              if (percent != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    AppText(
                      "نسبة الاستفادة",
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        height: 1.333,
                      ),
                    ),
                    AppText(
                      "$percent%",
                      style: TextStyle(
                        color: Color(0xFF064E3B),
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        height: 1.556,
                      ),
                    ),
                  ],
                ),
            ],
          ),
          SizedBox(height: 12),
          if (percent != null) _LinearProgress(percent: percent!),
        ],
      ),
    );
  }
}

class _LinearProgress extends StatefulWidget {
  const _LinearProgress({required this.percent});
  final double percent;

  @override
  State<_LinearProgress> createState() => _LinearProgressState();
}

class _LinearProgressState extends State<_LinearProgress> {
  final GlobalKey _globalKey = GlobalKey();
  double actualPercent = 0.0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BuildContext containerContext = _globalKey.currentContext!;
      RenderBox box = containerContext.findRenderObject() as RenderBox;
      actualPercent = box.size.width * (widget.percent / 100);
      setState(() {});
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant _LinearProgress oldWidget) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BuildContext containerContext = _globalKey.currentContext!;
      RenderBox box = containerContext.findRenderObject() as RenderBox;
      actualPercent = box.size.width * (widget.percent / 100);
      setState(() {});
    });
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 8,
      width: context.width,
      child: Stack(
        children: [
          Container(
            width: context.width,
            height: 8,
            key: _globalKey,
            decoration: BoxDecoration(
              color: Color(0x80FFFFFF),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
          Container(
            width: actualPercent,
            height: 8,
            decoration: BoxDecoration(
              color: Color(0xFF064E3B),
              borderRadius: BorderRadius.all(Radius.circular(100)),
            ),
          ),
        ],
      ),
    );
  }
}

class BestOfferCard extends StatelessWidget {
  const BestOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0x1AD97706),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: Color(0x33D97706)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    "أفضل عرض أداءً",
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.333,
                    ),
                  ),
                  AppText(
                    "خصم 25% على الوجبات العائلية",
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  color: Color(0x33D97706),
                ),
                child: Icon(
                  FontAwesomeIcons.trophy,
                  size: 18,
                  color: Color(0xFFD97706),
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "استخدامات",
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.333,
                    ),
                  ),
                  AppText(
                    "68 مرة",
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "إيرادات",
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.333,
                    ),
                  ),
                  AppText(
                    "9,850 ل.س",
                    style: TextStyle(
                      color: Color(0xFFD97706),
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
