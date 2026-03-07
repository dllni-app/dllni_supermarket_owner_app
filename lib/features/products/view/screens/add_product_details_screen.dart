import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_simple_app_bar.dart';
import '../widgets/product_pick_images.dart';
import '../widgets/product_text_field.dart';

@AutoRoutePage(path: "/products/new_product/details")
class AddProductDetailsScreen extends StatelessWidget {
  const AddProductDetailsScreen({super.key});

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
                    ProductStepDetails(
                      number: 3,
                      title: "الربط بالمخزون",
                      child: Column(
                        children: [
                          ProductTextField(
                            title: "السعر الأساسي",
                            hintText: "بحث في المخزون...",
                            suffixIcon: AppImage.asset(
                              AppImages.search,
                              size: 16,
                            ),
                          ),
                          SizedBox(height: 20),
                          InfoAlert(),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: ProductTextField(
                                  title: "كمية الخصم",
                                  hintText: "1",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: ProductTextField(
                                  title: "الواحدة",
                                  hintText: "قطعة",
                                  keyboardType: TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ProductStepDetails(
                      number: 3,
                      title: "تفاصيل أخرى",
                      child: Column(
                        children: [
                          ProductTextField(
                            title: "الوقت المتوقع للتحضير",
                            hintText: "1",
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "دقيقة",
                                style: TextStyle(
                                  color: Color(0xFF9CA3AF),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          ProductTextField(
                            title: "الحد الأدنى للطلب",
                            hintText: "1",
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),

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
