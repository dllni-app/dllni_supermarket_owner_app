import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../data/models/search_master_products_model.dart';
import '../../domain/usecases/import_products_from_master_use_case.dart';
import '../manager/bloc/products_bloc.dart';

@AutoRoutePage(path: "/products/new_product/catalog")
class SearchFromCatalogScreen extends StatefulWidget {
  const SearchFromCatalogScreen({super.key});

  @override
  State<SearchFromCatalogScreen> createState() =>
      _SearchFromCatalogScreenState();
}

class _CatalogProductCard extends StatelessWidget {
  final SearchMasterProductsDataItem product;

  final bool selected;
  final VoidCallback onToggle;
  const _CatalogProductCard({
    required this.product,
    required this.selected,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary.withValues(alpha: .08)
              : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [AppShadows.shadow],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: (product.primaryImage ?? '').isEmpty
                  ? Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: const Icon(
                        Icons.image_outlined,
                        color: Color(0xFF9CA3AF),
                        size: 32,
                      ),
                    )
                  : Image.network(
                      product.primaryImage ?? '',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: const Icon(
                          Icons.image_outlined,
                          color: Color(0xFF9CA3AF),
                          size: 32,
                        ),
                      ),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  AppText(
                    product.name ?? '',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    product.brand ?? 'غير معروف',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    product.description ?? 'لا يوجد وصف',
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Checkbox(
              value: selected,
              onChanged: (_) => onToggle(),
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              side: const BorderSide(color: Color(0xFFD1D5DB)),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;

  final void Function(String) onSubmitted;
  const _SearchField({required this.controller, required this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onSubmitted: onSubmitted,
      textDirection: TextDirection.rtl,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 14,
        fontFamily: 'Cairo',
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'ابحث عن منتج...',
        hintStyle: const TextStyle(
          color: Color(0xFF9CA3AF),
          fontSize: 14,
          fontFamily: 'Cairo',
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        prefixIconConstraints: const BoxConstraints(maxWidth: 48),
        prefixIcon: const Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 18),
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
    );
  }
}

class _SearchFromCatalogScreenState extends State<SearchFromCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();

  /// Selected catalog rows keyed by [SearchMasterProductsDataItem.masterProductId] only.
  final Set<int> _selectedIds = {};

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProductsBloc>(),
      child: Builder(
        builder: (context) {
          return Scaffold(
            body: Column(
              children: [
                AppSimpleAppBar(title: 'إضافة منتج جديد'),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    border: Border.all(color: const Color(0xFFF3F4F6)),
                    borderRadius: const BorderRadius.all(Radius.circular(16)),
                    boxShadow: [AppShadows.shadow],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(
                        'قم بالبحث عن منتج معين',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      AppText(
                        'قم باختيار المنتجات التي تود بإضافتها لديك',
                        style: const TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          height: 1.625,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _SearchField(
                        controller: _searchController,
                        onSubmitted: (value) {
                          if (context.mounted) {
                            context.read<ProductsBloc>().add(
                              SearchMasterProductsSubmitted(value),
                            );
                          }
                          setState(() {});
                        },
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
                Expanded(
                  child: _searchController.text.trim().isEmpty
                      ? Center(
                          child: AppText.labelMedium(
                            'ابحث عن منتج...',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      : BlocBuilder<ProductsBloc, ProductsState>(
                          buildWhen: (previous, current) =>
                              previous.catalogMasterProducts !=
                              current.catalogMasterProducts,
                          builder: (context, state) {
                            return state.catalogMasterProducts!.builder(
                              loadingWidget: const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: CircularProgressIndicator.adaptive(),
                                ),
                              ),
                              emptyWidget: Center(
                                child: AppText.labelMedium(
                                  'لا يوجد منتجات',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              successWidget: () {
                                return ListView.separated(
                                  padding: const EdgeInsets.all(20),
                                  itemBuilder: (context, index) {
                                    if (state.catalogMasterProducts!.length <=
                                        index) {
                                      if (state.catalogMasterProducts!.length ==
                                          index) {
                                        context.read<ProductsBloc>().add(
                                          FetchMasterProductsSearchEvent(
                                            isReload: false,
                                          ),
                                        );
                                      }
                                      return const SizedBox(
                                        width: 30,
                                        height: 30,
                                        child: FittedBox(
                                          child:
                                              CircularProgressIndicator.adaptive(
                                                strokeWidth: 3,
                                              ),
                                        ),
                                      );
                                    }
                                    final product = state
                                        .catalogMasterProducts!
                                        .list[index];
                                    final masterProductId =
                                        product.masterProductId;
                                    final selected =
                                        masterProductId != null &&
                                        _selectedIds.contains(masterProductId);
                                    return _CatalogProductCard(
                                      product: product,
                                      selected: selected,
                                      onToggle: () {
                                        if (masterProductId == null) return;
                                        setState(() {
                                          if (selected) {
                                            _selectedIds.remove(
                                              masterProductId,
                                            );
                                          } else {
                                            _selectedIds.add(masterProductId);
                                          }
                                        });
                                      },
                                    );
                                  },
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemCount: state.catalogMasterProducts!
                                      .listLength(1),
                                );
                              },
                              failedWidget: Center(
                                child: FailureWidget(
                                  message:
                                      state.errorMessage ?? 'Unknown Error',
                                  onRetry: () {
                                    context.read<ProductsBloc>().add(
                                      FetchMasterProductsSearchEvent(
                                        isReload: true,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              onTapRetry: () {
                                context.read<ProductsBloc>().add(
                                  FetchMasterProductsSearchEvent(
                                    isReload: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                const SizedBox(height: 16),
                if (_selectedIds.isNotEmpty)
                  BlocBuilder<ProductsBloc, ProductsState>(
                    buildWhen: (previous, current) =>
                        previous.importProductsFromMasterStatus !=
                        current.importProductsFromMasterStatus,
                    builder: (context, state) {
                      if (state.importProductsFromMasterStatus ==
                          BlocStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          24,
                          0,
                          24,
                          MediaQuery.paddingOf(context).bottom + 24,
                        ),
                        child: Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: AppButton(
                                title: "تأكيد",
                                onTap: () => _showSelectedSheet(context),
                              ),
                            ),
                            AppOutlinedButton(
                              title: "إلغاء",
                              color: const Color(0xFFFF4C51),
                              onTap: () => setState(_selectedIds.clear),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSelectedSheet(BuildContext context) {
    final bloc = context.read<ProductsBloc>();
    final list = bloc.state.catalogMasterProducts!.list;
    final selected = list
        .where(
          (p) =>
              p.masterProductId != null &&
              _selectedIds.contains(p.masterProductId!),
        )
        .toList();
    final masterProductIds = selected
        .map((e) => e.masterProductId)
        .whereType<int>()
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => BlocProvider.value(
        value: bloc,
        child: _SelectedProductsSheet(
          products: selected,
          masterProductIds: masterProductIds,
          sheetContext: sheetContext,
          onImportSuccess: () {
            context.pushRouteAndRemoveUntil('/', arguments: 2);
          },
        ),
      ),
    );
  }
}

class _SelectedProductsSheet extends StatelessWidget {
  final List<SearchMasterProductsDataItem> products;
  final List<int> masterProductIds;
  final BuildContext sheetContext;
  final VoidCallback onImportSuccess;

  const _SelectedProductsSheet({
    required this.products,
    required this.masterProductIds,
    required this.sheetContext,
    required this.onImportSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductsBloc, ProductsState>(
      listenWhen: (previous, current) =>
          previous.importProductsFromMasterStatus == BlocStatus.loading &&
          (current.importProductsFromMasterStatus == BlocStatus.success ||
              current.importProductsFromMasterStatus == BlocStatus.failed),
      listener: (context, state) {
        if (state.importProductsFromMasterStatus == BlocStatus.success) {
          Navigator.pop(sheetContext);
          onImportSuccess();
        } else if (state.importProductsFromMasterStatus == BlocStatus.failed) {
          AppToast.showToast(
            context: sheetContext,
            message: state.errorMessage ?? 'Unknown Error',
            type: ToastificationType.error,
          );
        }
      },
      buildWhen: (previous, current) =>
          previous.importProductsFromMasterStatus !=
          current.importProductsFromMasterStatus,
      builder: (context, state) {
        final importing =
            state.importProductsFromMasterStatus == BlocStatus.loading;
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'المنتجات المختارة',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: AppColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.5,
                          ),
                        ),
                        Text(
                          'قائمة المنتجات التي تم اختيارها',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            color: Color(0xFF6B7280),
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () => Navigator.pop(sheetContext),
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                    child: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 28,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 180,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: products.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) =>
                      _SheetProductCard(product: products[index]),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  title: 'تأكيد إضافة المنتجات',
                  onTap: importing
                      ? null
                      : () {
                          context.read<ProductsBloc>().add(
                            ImportProductsFromMasterEvent(
                              params: ImportProductsFromMasterParams(
                                masterProductIds: masterProductIds,
                              ),
                            ),
                          );
                        },
                ),
              ),
              SizedBox(height: MediaQuery.paddingOf(sheetContext).bottom + 16),
            ],
          ),
        );
      },
    );
  }
}

class _SheetProductCard extends StatelessWidget {
  final SearchMasterProductsDataItem product;

  const _SheetProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final imageUrl = product.primaryImage ?? '';
    return Container(
      width: 130,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFFE5E7EB)),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: [AppShadows.shadow],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: imageUrl.isEmpty
                ? Container(
                    color: const Color(0xFFF3F4F6),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Color(0xFF9CA3AF),
                      size: 40,
                    ),
                  )
                : Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF3F4F6),
                      child: const Icon(
                        Icons.image_outlined,
                        color: Color(0xFF9CA3AF),
                        size: 40,
                      ),
                    ),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'العلامة : ${product.brand}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'الوحدة : ${product.unit ?? ''}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
