import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/extensions/num_extensions.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/domain/usecases/get_inventory_summary_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/inventory/domain/usecases/get_products_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../products/domain/usecases/get_low_stock_use_case.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/editing_type.dart';
import '../../domain/usecases/update_product_amount_use_case.dart';
import '../manager/bloc/inventory_bloc.dart';
import '../widgets/inventory_tab_bar.dart';
import '../widgets/low_stock_alerts_section.dart';

List<GetProductsModelDataItem> _filterInventoryByTab(List<GetProductsModelDataItem> list, int tab) {
  switch (tab) {
    case 1:
      return list.where((e) => (e.stockQuantity ?? 0) >= (e.lowStockThreshold ?? 0)).toList();
    case 2:
      return list.where((e) => (e.stockQuantity ?? 0) < (e.lowStockThreshold ?? 0)).toList();
    default:
      return list;
  }
}

int _inventoryTabCount(List<GetProductsModelDataItem> list, int tab) {
  switch (tab) {
    case 1:
      return list.where((e) => (e.stockQuantity ?? 0) > (e.lowStockThreshold ?? 0)).length;
    case 2:
      return list.where((e) => (e.stockQuantity ?? 0) <= (e.lowStockThreshold ?? 0)).length;
    default:
      return list.length;
  }
}

class EditProductAmount extends StatefulWidget {
  final EditingType type;
  final int productId;

  const EditProductAmount({super.key, required this.type, required this.productId});

  @override
  State<EditProductAmount> createState() => _EditProductAmountState();
}

class InventoryCard extends StatelessWidget {
  final String name;
  final String companyName;
  final num amount;
  final num lowStock;
  final String unit;
  final void Function()? onIncreaseTap;
  final void Function()? onDecreaseTap;

  const InventoryCard({super.key, required this.name, required this.companyName, required this.amount, required this.lowStock, required this.unit, this.onIncreaseTap, this.onDecreaseTap});

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
                child: AppImage.asset(AppImages.burgerImage, width: 70, height: 87, fit: BoxFit.cover, borderRadius: BorderRadius.all(Radius.circular(12))),
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
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF111827), height: 1.42),
                    ),
                    SizedBox(height: 10),
                    AppText(
                      companyName,
                      style: TextStyle(fontSize: 10, color: Color(0xFF111827), height: 2, fontWeight: FontWeight.w300),
                    ),
                    SizedBox(height: 11),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "$amount $unit",
                            style: TextStyle(fontWeight: FontWeight.w700, color: color),
                          ),
                          WidgetSpan(child: CircleAvatar(radius: 2, backgroundColor: Color(0xFFD1D5DB))),
                          TextSpan(text: "الحد الأدنى: $lowStock $unit"),
                        ],
                      ),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, height: 1.333, color: Color(0xFF6B7280)),
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
                  borderRadius: BorderRadius.only(bottomRight: Radius.circular(8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(radius: 4, backgroundColor: color),
                    SizedBox(width: 4),
                    AppText.labelSmall(
                      lowStock >= amount ? "منخفض" : "طبيعي",
                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w700, height: 1.5),
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
                child: InventoryCardButton(color: AppColors.accent, label: "إضافة الكمية", icon: FontAwesomeIcons.plus, onTap: onIncreaseTap),
              ),
              SizedBox(width: 18),
              Expanded(
                child: InventoryCardButton(color: Color(0xFF9CA3AF), label: "تقليل الكمية", icon: FontAwesomeIcons.minus, onTap: onDecreaseTap),
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
  final Color color;
  final String label;
  final IconData icon;
  final void Function()? onTap;

  const InventoryCardButton({super.key, required this.color, required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 10, color: AppColors.white),
            SizedBox(width: 15),
            AppText(
              label,
              style: TextStyle(color: AppColors.white, fontSize: 12, fontWeight: FontWeight.w700, height: 1.333),
            ),
          ],
        ),
      ),
    );
  }
}

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
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
            onChanged: (index) {},
          ),
          // products
          ...List.generate(2, (index) => InventoryCard(amount: 4.5, lowStock: 5, companyName: "شركة كرزة", name: "زيت مازولا", unit: "لتر")),
        ],
      ),
    );
  }
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
          title: Text(widget.type == EditingType.increment ? "زيادة كمية المنتج" : "نقص كمية المنتج"),
          content: AppTextField(
            title: "مقدار ${widget.type == EditingType.increment ? "الزيادة" : "النقصان"}",
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
              buildWhen: (previous, current) => previous.productAmountStatus != current.productAmountStatus,
              listener: (context, state) {
                if (state.productAmountStatus == BlocStatus.success) {
                  if (context.canPop()) Navigator.of(context).pop(quantity);
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
                            params: UpdateProductAmountParams(operation: widget.type, productId: widget.productId, quantity: quantity),
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

class _InventoryScreenState extends State<InventoryScreen> {
  int selectedTab = 0;
  String? search;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<InventoryBloc>()
        ..add(GetProductsEvent(isReload: true, params: GetProductsParams(page: 1)))
        ..add(GetInventorySummaryEvent(params: GetInventorySummaryParams(storeId: 1)))
        ..add(GetLowStockEvent(params: GetLowStockParams())),
      child: Scaffold(
        body: Column(
          children: [
            Builder(
              builder: (context) {
                return AppSimpleAppBarWithSearch(
                  title: "المخزون",
                  onSearchChanged: (value) {
                    search = value.trim().isEmpty ? null : value.trim();
                    context.read<InventoryBloc>().add(GetProductsEvent(isReload: true, params: GetProductsParams(page: 1, search: search)));
                  },
                );
              },
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  LowStockAlertsSection(),
                  SizedBox(height: 16),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [BoxShadow(offset: Offset(0, 4), blurRadius: 4, color: Color(0x1F5E6695))],
                    ),
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      buildWhen: (previous, current) => previous.inventorySummaryStatus != current.inventorySummaryStatus || previous.inventorySummary != current.inventorySummary,
                      builder: (context, state) {
                        final status = state.inventorySummaryStatus;
                        final value = state.inventorySummary?.data?.inventoryValue;
                        final displayValue = value != null ? value.formatWithComma() : '--';
                        return Container(
                          padding: EdgeInsets.fromLTRB(12, 22, 16, 21),
                          decoration: BoxDecoration(color: Color(0x1F8591E0), borderRadius: BorderRadius.all(Radius.circular(16))),
                          child: Row(
                            children: [
                              AppText(
                                "قيمة المخزون",
                                style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14, fontWeight: FontWeight.w500),
                              ),
                              Spacer(),
                              if (status == BlocStatus.loading)
                                SizedBox(width: 28, height: 28, child: CircularProgressIndicator.adaptive(strokeWidth: 2.5))
                              else if (status == BlocStatus.failed)
                                InkWell(
                                  onTap: () {
                                    context.read<InventoryBloc>().add(GetInventorySummaryEvent(params: GetInventorySummaryParams(storeId: 1)));
                                  },
                                  child: AppText(
                                    "إعادة المحاولة",
                                    style: TextStyle(color: context.primary, fontSize: 14, fontWeight: FontWeight.w600),
                                  ),
                                )
                              else
                                AppText(
                                  displayValue,
                                  style: TextStyle(color: context.primary, fontSize: 24, fontWeight: FontWeight.w700, height: 1.333),
                                ),
                              SizedBox(width: 22),
                              AppText("ل.س", style: TextStyle(color: context.primary, fontSize: 14)),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: BlocBuilder<InventoryBloc, InventoryState>(
                      buildWhen: (previous, current) => previous.products != current.products,
                      builder: (context, state) {
                        return state.products!.builder(
                          loadingWidget: ProductsLoading(),
                          emptyWidget: AppText.labelMedium('لا يوجد منتجات', fontWeight: FontWeight.w400),
                          successWidget: () {
                            final list = state.products!.list;
                            final visible = _filterInventoryByTab(list, selectedTab);
                            final loadingMore = state.products!.status == BlocStatus.loading && state.products!.list.isNotEmpty;

                            void requestNext() {
                              context.read<InventoryBloc>().add(
                                GetProductsEvent(
                                  isReload: false,
                                  params: GetProductsParams(page: state.products!.pageNumber, search: search),
                                ),
                              );
                            }

                            final tabBar = InventoryTabBar(
                              items: [
                                InventoryTabBarItem(title: "الكل", count: _inventoryTabCount(list, 0)),
                                InventoryTabBarItem(title: "طبيعي", count: _inventoryTabCount(list, 1)),
                                InventoryTabBarItem(title: "منخفض", count: _inventoryTabCount(list, 2)),
                              ],
                              onChanged: (index) {
                                if (index == selectedTab) return;
                                selectedTab = index;
                                setState(() {});
                              },
                            );

                            if (visible.isEmpty) {
                              if (state.products!.isEndPage) {
                                return Column(
                                  children: [
                                    tabBar,
                                    Expanded(
                                      child: Center(child: AppText.labelMedium('لا يوجد منتجات', fontWeight: FontWeight.w400)),
                                    ),
                                  ],
                                );
                              }
                              if (!loadingMore) {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  if (!context.mounted) return;
                                  requestNext();
                                });
                              }
                              return Column(
                                children: [
                                  tabBar,
                                  Expanded(
                                    child: Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator.adaptive(strokeWidth: 3))),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                tabBar,
                                Expanded(
                                  child: ListView.separated(
                                    padding: EdgeInsetsDirectional.symmetric(horizontal: 0),
                                    itemBuilder: (context, index) {
                                      if (visible.length <= index) {
                                        if (visible.length == index && !state.products!.isEndPage) {
                                          if (state.products!.status != BlocStatus.loading) {
                                            requestNext();
                                          }
                                        }
                                        return SizedBox(width: 30, height: 30, child: FittedBox(child: CircularProgressIndicator.adaptive(strokeWidth: 3)));
                                      }
                                      final item = visible[index];
                                      return InventoryCard(
                                        amount: item.stockQuantity ?? 0,
                                        lowStock: item.lowStockThreshold ?? 0,
                                        companyName: item.category?.name ?? '',
                                        name: item.name ?? '',
                                        unit: "كغ",
                                        onIncreaseTap: () async {
                                          final incrementQuantity = await showDialog<int>(
                                            context: context,
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<InventoryBloc>(),
                                              child: EditProductAmount(type: EditingType.increment, productId: item.id!),
                                            ),
                                          );
                                          if (incrementQuantity == null) {
                                            return;
                                          }
                                        },
                                        onDecreaseTap: () async {
                                          final decrementQuantity = await showDialog<int>(
                                            context: context,
                                            builder: (_) => BlocProvider.value(
                                              value: context.read<InventoryBloc>(),
                                              child: EditProductAmount(type: EditingType.decrement, productId: item.id!),
                                            ),
                                          );
                                          if (decrementQuantity == null) {
                                            return;
                                          }
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) => SizedBox(height: 8),
                                    itemCount: visible.length + (state.products!.isEndPage ? 0 : 1),
                                  ),
                                ),
                              ],
                            );
                          },
                          failedWidget: Center(
                            child: FailureWidget(message: state.errorMessage.toString(), onRetry: () => _reloadProducts(context)),
                          ),
                          onTapRetry: () => _reloadProducts(context),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _reloadProducts(BuildContext context) {
    context.read<InventoryBloc>().add(GetProductsEvent(isReload: true, params: GetProductsParams(page: 1, search: search)));
  }
}
