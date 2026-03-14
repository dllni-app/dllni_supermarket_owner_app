import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_gradients.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/step_details.dart';
import '../../../products/view/widgets/product_text_field.dart';

@AutoRoutePage(path: "/create_offer")
class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  String discountType = "%";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إنشاء عرض جديد"),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  StepDetails(
                    number: 1,
                    title: "المعلومات الأساسية",
                    child: Column(
                      children: [
                        AppTextField(
                          title: "اسم العرض",
                          hintText: "مثال: خصم 25% على  منتجات التنظيف بشرى",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 2,
                    title: "نوع الخصم",
                    child: Column(
                      children: [
                        _DiscountChooser(
                          onChanged: (discountType) {
                            print(discountType);
                            if (discountType == "نسبة مئوية")
                              this.discountType = "%";
                            else
                              this.discountType = "ل.س";
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 8),
                        AppTextField(
                          title: "قيمة الخصم ($discountType)",
                          hintText: "0",
                          keyboardType: TextInputType.number,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              discountType,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 3,
                    title: "مدة العرض",
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0x0D064E3B),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Color(0x33064E3B)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.power,
                                size: 16,
                                color: Color(0xFF064E3B),
                              ),
                              SizedBox(width: 8),
                              AppText(
                                "تفعيل فوري",
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.42,
                                ),
                              ),
                              Spacer(),
                              AppSwitch(onChanged: (value) {}, value: true),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        AppDatePicker(
                          onDateChanged: (expiredDate) {},
                          title: "تاريخ البداية",
                        ),
                        SizedBox(height: 12),
                        AppDatePicker(
                          onDateChanged: (expiredDate) {},
                          title: "تاريخ البداية",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 4,
                    title: "ربط المنتجات",
                    leading: _ProductsCounterChip(productsCounter: 0),
                    child: Column(
                      children: [
                        _TextFieldWithoutTitle(onSearchChanged: (value) {}),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.layerGroup,
                                  color: Color(0xFF374151),
                                  size: 14,
                                ),
                                SizedBox(width: 8),
                                AppText(
                                  "اختيار تصنيف كامل",
                                  style: TextStyle(
                                    color: Color(0xFF374151),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        _OfferCheckbox(),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: AppText(
                              "اختيار تصنيف كامل",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                height: 1.333,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      border: Border.all(color: const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.all(Radius.circular(32)),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 4),
                          blurRadius: 20,
                          spreadRadius: -2,
                          color: const Color(0x0D000000),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            AppText(
                              "المنتجات المحددة",
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.42,
                              ),
                            ),
                            Spacer(),
                            _ProductsCounterChip(productsCounter: 0),
                          ],
                        ),
                        SizedBox(height: 16),
                        DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            dashPattern: const [8, 8],
                            strokeWidth: 2,
                            color: const Color(0x1F2F2B3D),
                            radius: const Radius.circular(16),
                          ),
                          child: Container(
                            width: double.infinity,
                            height: 190,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    color: AppColors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(16),
                                    ),
                                    boxShadow: [AppShadows.shadow],
                                  ),
                                  child: Icon(
                                    FontAwesomeIcons.boxOpen,
                                    size: 18,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ),
                                SizedBox(height: 8),
                                AppText(
                                  "اضغط لرفع صورة",
                                  style: TextStyle(
                                    color: const Color(0xE52F2B3D),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    height: 1.333,
                                  ),
                                ),
                                SizedBox(height: 4),
                                AppText(
                                  "PNG, JPG حتى 5MB",
                                  style: TextStyle(
                                    color: const Color(0x662F2B3D),
                                    fontSize: 10,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(title: "حفظ وتفعيل", onTap: () {}),
                      ),
                      SizedBox(width: 16),
                      AppOutlinedButton(
                        title: "إلغاء",
                        color: const Color(0xFFFF4C51),
                      ),
                    ],
                  ),
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OfferCheckbox extends StatelessWidget {
  const _OfferCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.white,
            ),
            child: Icon(
              FontAwesomeIcons.pizzaSlice,
              size: 18,
              color: Color(0xFF064E3B),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  "مسحوق الغسيل (بشرى)",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                AppText(
                  "تنظيف",
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.333,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: true,
            onChanged: (value) {},
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            ),
          ),
        ],
      ),
    );
  }
}

class _DiscountChooser extends StatefulWidget {
  const _DiscountChooser({super.key, required this.onChanged});
  final void Function(String discountType) onChanged;

  @override
  State<_DiscountChooser> createState() => _DiscountChooserState();
}

class _DiscountChooserState extends State<_DiscountChooser> {
  int selectedChip = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (selectedChip == 0) return;
              selectedChip = 0;
              setState(() {});
              widget.onChanged("نسبة مئوية");
            },
            child: _DiscountChooserChip(
              isSelected: selectedChip == 0,
              label: "نسبة مئوية",
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (selectedChip == 1) return;
              selectedChip = 1;
              setState(() {});
              widget.onChanged("مبلغ ثابت");
            },
            child: _DiscountChooserChip(
              isSelected: selectedChip == 1,
              label: "مبلغ ثابت",
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscountChooserChip extends StatelessWidget {
  const _DiscountChooserChip({
    super.key,
    required this.label,
    required this.isSelected,
  });
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: isSelected ? null : AppColors.white,
        gradient: isSelected ? AppGradients.gradient : null,
        border: isSelected ? Border.all(color: Color(0xFFE5E7EB)) : null,
        boxShadow: [AppShadows.shadow],
      ),
      child: AppText(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : Color(0xFF4B5563),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          height: 1.42,
        ),
      ),
    );
  }
}

class _ProductsCounterChip extends StatelessWidget {
  const _ProductsCounterChip({super.key, required this.productsCounter});
  final int productsCounter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0x1A064E3B),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        "$productsCounter منتج",
        style: TextStyle(
          color: Color(0xFF064E3B),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.33,
        ),
      ),
    );
  }
}

class _TextFieldWithoutTitle extends StatelessWidget {
  const _TextFieldWithoutTitle({super.key, required this.onSearchChanged});
  final void Function(String value) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Color(0xFF111287),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        filled: true,
        fillColor: Color(0xFFF9FAFB),
        hintText: "ابحث عن منتج...",
        hintStyle: TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }
}
