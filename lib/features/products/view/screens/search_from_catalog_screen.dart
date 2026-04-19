import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';

@AutoRoutePage(path: "/products/new_product/catalog")
class SearchFromCatalogScreen extends StatefulWidget {
  const SearchFromCatalogScreen({super.key});

  @override
  State<SearchFromCatalogScreen> createState() =>
      _SearchFromCatalogScreenState();
}

class _SearchFromCatalogScreenState extends State<SearchFromCatalogScreen> {
  final TextEditingController _searchController = TextEditingController();
  final Set<int> _selectedIds = {};
  String _query = '';

  final List<_CatalogProduct> _results = const [
    _CatalogProduct(
      id: 1,
      name: 'لبنة نيو بارك',
      unit: '250 كغ',
      price: '32 ل.س',
      imageUrl: 'https://via.placeholder.com/80',
    ),
  ];

  List<_CatalogProduct> get _filtered => _query.isEmpty
      ? _results
      : _results.where((p) => p.name.contains(_query)).toList();

  void _showSelectedSheet() {
    final selected = _results
        .where((p) => _selectedIds.contains(p.id))
        .toList();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Directionality(
        textDirection: TextDirection.rtl,
        child: _SelectedProductsSheet(
          products: selected,
          onConfirm: () {
            Navigator.pop(context);
            // TODO: dispatch add products event
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          children: [
            AppSimpleAppBar(title: 'إضافة منتج جديد'),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                child: Container(
                  padding: const EdgeInsets.all(20),
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
                        onChanged: (v) => setState(() => _query = v),
                      ),
                      const SizedBox(height: 12),
                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final product = _filtered[index];
                          final selected = _selectedIds.contains(product.id);
                          return _CatalogProductCard(
                            product: product,
                            selected: selected,
                            onToggle: () => setState(() {
                              if (selected) {
                                _selectedIds.remove(product.id);
                              } else {
                                _selectedIds.add(product.id);
                              }
                            }),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_selectedIds.isNotEmpty)
              Padding(
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
                        onTap: () {
                          _showSelectedSheet();
                        },
                      ),
                    ),
                    AppOutlinedButton(
                      title: "إلغاء",
                      color: const Color(0xFFFF4C51),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({required this.controller, required this.onChanged});

  final TextEditingController controller;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      textDirection: TextDirection.rtl,
      onTapOutside: (_) => FocusScope.of(context).unfocus(),
      style: const TextStyle(
        color: Color(0xFF111827),
        fontSize: 14,
        fontFamily: 'Cairo',
      ),
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
        prefixIcon: const Padding(
          padding: EdgeInsets.only(left: 12),
          child: Icon(Icons.search_rounded, color: Color(0xFF9CA3AF), size: 22),
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

class _CatalogProductCard extends StatelessWidget {
  const _CatalogProductCard({
    required this.product,
    required this.selected,
    required this.onToggle,
  });

  final _CatalogProduct product;
  final bool selected;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFFFF7F0) : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.accent : const Color(0xFFE5E7EB),
            width: selected ? 1.5 : 1,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          boxShadow: [AppShadows.shadow],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: Image.network(
                product.imageUrl,
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
                children: [
                  AppText(
                    product.name,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    product.unit,
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  AppText(
                    product.price,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
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
              activeColor: AppColors.accent,
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

class _CatalogProduct {
  const _CatalogProduct({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,
    required this.imageUrl,
  });

  final int id;
  final String name;
  final String unit;
  final String price;
  final String imageUrl;
}

class _SelectedProductsSheet extends StatelessWidget {
  const _SelectedProductsSheet({
    required this.products,
    required this.onConfirm,
  });

  final List<_CatalogProduct> products;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
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
                onTap: () => Navigator.pop(context),
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
            child: AppButton(title: 'تأكيد إضافة المنتجات', onTap: onConfirm),
          ),
          SizedBox(height: MediaQuery.paddingOf(context).bottom + 16),
        ],
      ),
    );
  }
}

class _SheetProductCard extends StatelessWidget {
  const _SheetProductCard({required this.product});

  final _CatalogProduct product;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 118,
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
            child: Image.network(
              product.imageUrl,
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
                  product.name,
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
                  'الوزن : ${product.unit}',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'السعر : ${product.price}',
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
