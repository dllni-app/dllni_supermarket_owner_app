import 'dart:typed_data';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_gradients.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../widgets/product_pick_images.dart';
import '../widgets/product_text_field.dart';

@AutoRoutePage(path: "/products/new_product/details")
class AddProductDetailsScreen extends StatefulWidget {
  const AddProductDetailsScreen({super.key, this.params});

  final AddProductDetailsParams? params;

  @override
  State<AddProductDetailsScreen> createState() =>
      _AddProductDetailsScreenState();
}

class _AddProductDetailsScreenState extends State<AddProductDetailsScreen> {
  late TextEditingController unitController;
  @override
  void initState() {
    unitController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إضافة منتج جديد"),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    ProductStepDetails(
                      number: 1,
                      title: "المعلومات الأساسية",
                      child: Column(
                        children: [
                          ProductTextField(
                            title: "اسم المنتج",
                            hintText: "مثال: برجر دجاج كلاسيك",
                          ),
                          SizedBox(height: 20),
                          ProductTextField(
                            title: "وصف المنتج",
                            hintText: "وصف مكونات المنتج ومميزاته...",
                            maxLines: 4,
                          ),
                          SizedBox(height: 20),
                          ProductMenuField(
                            title: "التصنيف",
                            hintText: "اختر تصنيف...",
                            onChanged: (value) {
                              print(value);
                            },
                            items: [
                              DropdownMenuItem(
                                value: "التصنيف 1",
                                child: AppText(
                                  "التصنيف 1",
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                              ),
                              DropdownMenuItem(
                                value: "التصنيف 2",
                                child: AppText(
                                  "التصنيف 2",
                                  style: TextStyle(fontFamily: "Cairo"),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          ProductPickMainImage(
                            title: "صورة رئيسية",
                            isRequired: true,
                            icon: FontAwesomeIcons.solidCamera,
                            onPickImage: (imagePath) {
                              print(imagePath);
                            },
                          ),
                          SizedBox(height: 16),
                          ProductPickAdditionalImages(
                            numOfImages: 6,
                            onPickImage: (imagesPath) {
                              print(imagesPath);
                            },
                          ),
                          SizedBox(height: 24),
                          ProductPickMainImage(
                            title: "صورة  الباركود",
                            isRequired: true,
                            icon: FontAwesomeIcons.barcode,
                            onPickImage: (imagePath) {
                              print(imagePath);
                            },
                          ),
                          SizedBox(height: 24),
                          ProductUnit(
                            onChanged: (unit) {
                              print(unit);
                            },
                            controller: unitController,
                          ),
                          SizedBox(height: 24),
                          Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: ProductTextField(
                                  title: "الكمية الأولية",
                                  isRequired: true,
                                  hintText: "0",
                                ),
                              ),
                              Expanded(
                                child: ProductTextField(
                                  title: "الحد الأدنى",
                                  isRequired: true,
                                  hintText: "0",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24),
                          ProductDatePicker(
                            title: "صلاحية المنتج",
                            onDateChanged: (expiredDate) {
                              print(expiredDate);
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ProductStepDetails(
                      number: 2,
                      title: "التسعير",
                      child: Column(
                        children: [
                          ProductTextField(
                            title: "السعر الأساسي",
                            isRequired: true,
                            hintText: "0.00",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "ل.س",
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          SizedBox(height: 20),
                          ProductTextField(
                            title: "السعر بعد الحسم",
                            hintText: "0.00",
                            isRequired: true,
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "ل.س",
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            title: "نشر المنتج",
                            onTap: () {
                              print("publish");
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        AppOutlinedButton(
                          title: "إلغاء",
                          color: const Color(0xFFFF4C51),
                        ),
                      ],
                    ),
                    SizedBox(height: 170),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProductUnit extends StatefulWidget {
  const ProductUnit({
    super.key,
    required this.onChanged,
    required this.controller,
  });
  final void Function(String unit) onChanged;
  final TextEditingController controller;
  @override
  State<ProductUnit> createState() => _ProductUnitState();
}

class _ProductUnitState extends State<ProductUnit> {
  String? unit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: "وحدة القياس",
            children: [
              TextSpan(
                text: "*",
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  height: 1.42,
                ),
              ),
            ],
          ),
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        SizedBox(height: 8),
        Row(
          spacing: 8,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (unit == "كغ") return;
                  unit = "كغ";
                  widget.controller.clear();
                  setState(() {});
                },
                child: _ProductUnitChip(unit: unit, value: "كغ"),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (unit == "لتر") return;
                  unit = "لتر";
                  widget.controller.clear();
                  setState(() {});
                },
                child: _ProductUnitChip(unit: unit, value: "لتر"),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (unit == "قطعة") return;
                  unit = "قطعة";
                  widget.controller.clear();
                  setState(() {});
                },
                child: _ProductUnitChip(unit: unit, value: "قطعة"),
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          controller: widget.controller,
          onChanged: (value) {
            unit = value;
            setState(() {});
          },
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF9FAFB),
            hintText: "أو اكتب وحدة مخصصة",
            hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductUnitChip extends StatelessWidget {
  const _ProductUnitChip({required this.unit, required this.value});
  final String? unit;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: unit == value ? null : AppColors.white,
        gradient: unit == value ? AppGradients.gradient : null,
        border: unit != value ? Border.all(color: Color(0xFFE5E7EB)) : null,
        boxShadow: [AppShadows.shadow],
      ),
      child: AppText(
        value,
        style: TextStyle(
          color: unit == value ? AppColors.white : Color(0xFF4B5563),
          fontSize: 14,
          fontWeight: unit == value ? FontWeight.w700 : FontWeight.w500,
          height: 1.42,
        ),
      ),
    );
  }
}

class ProductStepDetails extends StatelessWidget {
  const ProductStepDetails({
    super.key,
    required this.number,
    required this.title,
    required this.child,
  });
  final int number;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
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
              CircleAvatar(
                radius: 16,
                backgroundColor: context.primaryContainer,
                child: AppText(
                  number.toString(),
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    height: 1.42,
                  ),
                ),
              ),
              SizedBox(width: 12),
              AppText(
                title,
                style: TextStyle(
                  color: context.primaryContainer,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  height: 1.555,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class InfoAlert extends StatelessWidget {
  const InfoAlert({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x1400BAD1),
        border: Border.all(color: const Color(0x2900BAD1)),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              FontAwesomeIcons.circleInfo,
              size: 16,
              color: const Color(0xFF00A7BC),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  "نظام الخصم التلقائي",
                  style: TextStyle(
                    color: const Color(0xFF00A7BC),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 4),
                AppText(
                  "سيتم خصم الكمية المحددة من المخزون تلقائياً عند كل عملية بيع لهذا المنتج.",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: const Color(0xFF00BAD1),
                    fontSize: 12,
                    height: 1.333,
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

class AddProductDetailsParams {
  final Uint8List? image64Based;
  final String? title;
  final String? description;

  AddProductDetailsParams({this.image64Based, this.title, this.description});
}
