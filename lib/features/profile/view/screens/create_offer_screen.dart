import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_gradients.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/step_details.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../data/models/add_offer_model.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/usecases/add_offer_use_case.dart';
import '../../domain/usecases/get_offer_codes_use_case.dart';
import '../../domain/usecases/get_products_count_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'products_screen.dart';

@AutoRoutePage(path: '/create_offer')
class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final List<GetProductsModelDataItem> selectedProducts = [];

  final AddOfferModelData offer = AddOfferModelData(
    offerType: 'percent',
    isActive: true,
  );

  String discountUnit = '%';
  DateTime? _startsAt;
  DateTime? _endsAt;

  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>()
      ..add(GetProductsEvent(isReload: true, params: GetProductsParams()))
      ..add(GetProductsCountEvent(params: GetProductsCountParams()));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppSimpleAppBar(title: 'إنشاء عرض جديد'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 16),
              child: Column(
                children: [
                  StepDetails(
                    number: 1,
                    title: 'المعلومات الأساسية',
                    child: AppTextField(
                      title: 'اسم العرض',
                      hintText: 'مثال: خصم 25% على منتجات التنظيف',
                      controller: _nameController,
                      onChanged: (value) => offer.name = value,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 2,
                    title: 'نوع الخصم',
                    child: Column(
                      children: [
                        DiscountChooser(
                          onChanged: (type) {
                            setState(() {
                              if (type == 'percent') {
                                offer.offerType = 'percent';
                                discountUnit = '%';
                              } else {
                                offer.offerType = 'value';
                                discountUnit = 'ل.س';
                              }
                              offer.discountPercent = null;
                              offer.discountValue = null;
                              _discountController.clear();
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        AppTextField(
                          title: 'قيمة الخصم ($discountUnit)',
                          hintText: '0',
                          controller: _discountController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              discountUnit,
                              style: const TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          onChanged: (value) {
                            if (offer.offerType == 'percent') {
                              offer.discountPercent = int.tryParse(value);
                            } else {
                              offer.discountValue = value;
                            }
                          },
                        ),
                        if (offer.offerType == 'percent') ...[
                          const SizedBox(height: 6),
                          const Align(
                            alignment: AlignmentDirectional.centerStart,
                            child: AppText(
                              'يمكن استخدام 100% لجعل المنتج مجانيًا خلال مدة العرض.',
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 3,
                    title: 'مدة العرض',
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0x0D064E3B),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0x33064E3B)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.power, size: 16, color: Color(0xFF064E3B)),
                              const SizedBox(width: 8),
                              const AppText(
                                'تفعيل العرض',
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              AppSwitch(
                                onChanged: (value) => setState(() => offer.isActive = value),
                                value: offer.isActive ?? false,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        OfferDateTimeField(
                          title: 'بداية العرض',
                          value: _startsAt,
                          onChanged: (value) {
                            setState(() => _startsAt = value);
                            offer.startsAt = value.toIso8601String();
                          },
                        ),
                        const SizedBox(height: 12),
                        OfferDateTimeField(
                          title: 'نهاية العرض',
                          value: _endsAt,
                          minimumDateTime: _startsAt,
                          onChanged: (value) {
                            setState(() => _endsAt = value);
                            offer.endsAt = value.toIso8601String();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 4,
                    title: 'ربط المنتجات',
                    leading: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (p, c) => p.productsCountStatus != c.productsCountStatus,
                      builder: (context, state) => _ProductsCounterChip(
                        productsCounter: state.productsCount?.count ?? 0,
                      ),
                    ),
                    child: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (p, c) => p.products != c.products,
                      builder: (context, state) {
                        final products = state.products;
                        if (products == null || products.status == BlocStatus.loading) {
                          return const Center(child: CircularProgressIndicator.adaptive());
                        }
                        if (products.status == BlocStatus.failed) {
                          return Column(
                            children: [
                              AppText.labelMedium(state.errorMessage ?? 'تعذر تحميل المنتجات'),
                              TextButton(
                                onPressed: () => context.read<ProfileBloc>().add(
                                      GetProductsEvent(
                                        params: GetProductsParams(page: 1),
                                        isReload: true,
                                      ),
                                    ),
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          );
                        }

                        final visible = products.list.take(3).toList();
                        return Column(
                          children: [
                            if (visible.isEmpty)
                              const AppText('لا يوجد منتجات حالياً')
                            else
                              ...visible.map(
                                (product) => Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: OfferCheckbox(
                                    product: product,
                                    selected: _isSelected(product),
                                    onChanged: (selected) => _setProductSelected(product, selected),
                                  ),
                                ),
                              ),
                            const SizedBox(height: 4),
                            InkWell(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: context.read<ProfileBloc>(),
                                      child: ProductsScreen(selectedProducts: selectedProducts),
                                    ),
                                  ),
                                );
                                if (mounted) setState(() {});
                              },
                              borderRadius: BorderRadius.circular(14),
                              child: Container(
                                width: double.infinity,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF9FAFB),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: const Color(0xFFE5E7EB)),
                                ),
                                child: const AppText(
                                  'عرض جميع المنتجات',
                                  style: TextStyle(
                                    color: Color(0xFF6B7280),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                            if (selectedProducts.isNotEmpty) ...[
                              const SizedBox(height: 14),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: _ProductsCounterChip(
                                  productsCounter: selectedProducts.length,
                                ),
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listenWhen: (p, c) => p.addOfferStatus != c.addOfferStatus,
                    listener: (context, state) {
                      if (state.addOfferStatus == BlocStatus.failed) {
                        AppToast.showToast(
                          context: context,
                          message: state.errorMessage ?? 'تعذر إنشاء العرض',
                          type: ToastificationType.error,
                        );
                      } else if (state.addOfferStatus == BlocStatus.success) {
                        AppToast.showToast(
                          context: context,
                          message: 'تم إضافة العرض بنجاح',
                          type: ToastificationType.success,
                        );
                        context.read<ProfileBloc>().add(
                              GetOfferCodesEvent(
                                isReload: true,
                                params: GetOfferCodesParams(storeId: 1),
                              ),
                            );
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      if (state.addOfferStatus == BlocStatus.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              title: 'حفظ وتفعيل',
                              onTap: () => _submit(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          AppOutlinedButton(
                            title: 'إلغاء',
                            color: const Color(0xFFFF4C51),
                            onTap: () => context.pop(),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 70),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _isSelected(GetProductsModelDataItem product) =>
      selectedProducts.any((item) => item.id == product.id);

  void _setProductSelected(GetProductsModelDataItem product, bool selected) {
    setState(() {
      selectedProducts.removeWhere((item) => item.id == product.id);
      if (selected) selectedProducts.add(product);
      product.isSelected = selected;
    });
  }

  void _submit(BuildContext blocContext) {
    offer.name = _nameController.text.trim();
    if (!_validate()) return;

    blocContext.read<ProfileBloc>().add(
          AddOfferEvent(
            params: AddOfferParams(
              storeId: 1,
              offer: offer,
              selectedProducts: selectedProducts
                  .map((product) => product.id)
                  .whereType<int>()
                  .toList(),
            ),
          ),
        );
  }

  bool _validate() {
    if (offer.name == null || offer.name!.trim().length < 3) {
      return _error('يرجى إدخال اسم عرض من 3 أحرف على الأقل');
    }

    if (offer.offerType == 'percent') {
      final percent = offer.discountPercent;
      if (percent == null || percent <= 0 || percent > 100) {
        return _error('نسبة الخصم يجب أن تكون بين 1% و100%');
      }
    } else {
      final value = double.tryParse(offer.discountValue ?? '');
      if (value == null || value <= 0) {
        return _error('يرجى إدخال قيمة خصم صحيحة');
      }
    }

    if (_startsAt == null) return _error('يرجى تحديد تاريخ ووقت بداية العرض');
    if (_endsAt == null) return _error('يرجى تحديد تاريخ ووقت نهاية العرض');
    if (!_endsAt!.isAfter(_startsAt!)) {
      return _error('وقت نهاية العرض يجب أن يكون بعد وقت البداية');
    }
    if (selectedProducts.isEmpty) {
      return _error('يرجى اختيار منتج واحد على الأقل');
    }
    return true;
  }

  bool _error(String message) {
    AppToast.showToast(
      context: context,
      message: message,
      type: ToastificationType.error,
    );
    return false;
  }
}

class OfferDateTimeField extends StatelessWidget {
  const OfferDateTimeField({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.minimumDateTime,
  });

  final String title;
  final DateTime? value;
  final ValueChanged<DateTime> onChanged;
  final DateTime? minimumDateTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _pick(context),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_month_outlined, size: 19, color: Color(0xFF6B7280)),
                const SizedBox(width: 8),
                Expanded(
                  child: AppText(
                    value == null ? 'اختر التاريخ والوقت' : _format(value!),
                    style: TextStyle(
                      color: value == null ? const Color(0xFF9CA3AF) : const Color(0xFF111827),
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(Icons.access_time_rounded, size: 19, color: Color(0xFF6B7280)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final minimum = minimumDateTime ?? now;
    final initial = value ?? (minimum.isAfter(now) ? minimum : now);
    final firstDate = DateTime(minimum.year, minimum.month, minimum.day);
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate) ? firstDate : initial,
      firstDate: firstDate,
      lastDate: DateTime(now.year + 5, 12, 31),
    );
    if (selectedDate == null || !context.mounted) return;

    final selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(value ?? initial),
    );
    if (selectedTime == null) return;

    final result = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      selectedTime.hour,
      selectedTime.minute,
    );

    if (minimumDateTime != null && result.isBefore(minimumDateTime!)) {
      if (!context.mounted) return;
      AppToast.showToast(
        context: context,
        message: 'يجب اختيار وقت بعد بداية العرض',
        type: ToastificationType.error,
      );
      return;
    }
    onChanged(result);
  }

  String _format(DateTime date) {
    final d = date.day.toString().padLeft(2, '0');
    final m = date.month.toString().padLeft(2, '0');
    final h = date.hour.toString().padLeft(2, '0');
    final min = date.minute.toString().padLeft(2, '0');
    return '$d/${date.year.toString().padLeft(4, '0')}/$m - $h:$min';
  }
}

class DiscountChooser extends StatefulWidget {
  const DiscountChooser({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<DiscountChooser> createState() => _DiscountChooserState();
}

class _DiscountChooserState extends State<DiscountChooser> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _DiscountChip(
            label: 'نسبة مئوية',
            selected: selected == 0,
            onTap: () {
              if (selected == 0) return;
              setState(() => selected = 0);
              widget.onChanged('percent');
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _DiscountChip(
            label: 'مبلغ ثابت',
            selected: selected == 1,
            onTap: () {
              if (selected == 1) return;
              setState(() => selected = 1);
              widget.onChanged('value');
            },
          ),
        ),
      ],
    );
  }
}

class _DiscountChip extends StatelessWidget {
  const _DiscountChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: selected ? null : AppColors.white,
          gradient: selected ? AppGradients.gradient : null,
          border: Border.all(color: const Color(0xFFE5E7EB)),
          boxShadow: [AppShadows.shadow],
        ),
        child: AppText(
          label,
          style: TextStyle(
            color: selected ? AppColors.white : const Color(0xFF4B5563),
            fontSize: 14,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class OfferCheckbox extends StatelessWidget {
  const OfferCheckbox({
    super.key,
    required this.product,
    required this.selected,
    required this.onChanged,
  });

  final GetProductsModelDataItem product;
  final bool selected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.white,
            ),
            child: Icon(
              FontAwesomeIcons.basketShopping.data,
              size: 16,
              color: const Color(0xFF064E3B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  product.name ?? '-',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                AppText(
                  product.category?.name ?? '',
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: selected,
            onChanged: (value) => onChanged(value ?? false),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ],
      ),
    );
  }
}

class _ProductsCounterChip extends StatelessWidget {
  const _ProductsCounterChip({required this.productsCounter});

  final int productsCounter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x1A064E3B),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$productsCounter منتج',
        style: const TextStyle(
          color: Color(0xFF064E3B),
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
