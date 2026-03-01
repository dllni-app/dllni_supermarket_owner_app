import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/widgets/expanded_product_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import 'gradient_button.dart';
import 'product_text_field.dart';

class AddProductAIBody extends StatefulWidget {
  const AddProductAIBody({super.key});

  @override
  State<AddProductAIBody> createState() => _AddProductAIBodyState();
}

class _AddProductAIBodyState extends State<AddProductAIBody> {
  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  String? imagePath;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    productDescriptionController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 16),
            ExpandedProductCard(
              backgroundColor: Color(0x146C63FF),
              foregroundColor: Color(0xFF6C63FF),
              title: "توليد الصورة من الاسم",
              subtitle:
                  "اكتب اسم ووصف الوجبة وسيتم اقتراح الصورة والوصف تلقائياً",
              icon: FontAwesomeIcons.image,
              expandedWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductTextField(
                    title: "اسم المنتج",
                    hintText: "مثال: برجر دجاج كلاسيك",
                    controller: productNameController,
                  ),
                  SizedBox(height: 8),
                  ProductTextField(
                    title: "وصف المنتج",
                    hintText: "وصف مكونات المنتج ومميزاته...",
                    controller: productDescriptionController,
                    maxLines: 4,
                  ),
                  SizedBox(height: 16),
                  GradientButton(
                    title: "توليد الصورة",
                    icon: Icon(
                      FontAwesomeIcons.wandMagicSparkles,
                      size: 17,
                      color: AppColors.white,
                    ),
                    onTap: () {
                      print('generate image');
                    },
                  ),
                  SizedBox(height: 16),
                  Row(
                    spacing: 10,
                    children: [
                      AppImage.asset(
                        AppImages.burgerImage,
                        size: 99,
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      Column(mainAxisSize: MainAxisSize.min, children: [

                      ],),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            ExpandedProductCard(
              backgroundColor: Color(0x14FF7A00),
              foregroundColor: AppColors.accent,
              title: "توليد الاسم من الصورة",
              subtitle:
                  "قم برفع صورة لمنتجك وسيتم اقتراح اسم ووصف المنتج تلقائياً",
              icon: FontAwesomeIcons.envelopeOpenText,
              expandedWidget: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProductTextField(
                    title: "وصف المنتج",
                    hintText: "وصف مكونات المنتج ومميزاته...",
                    controller: TextEditingController(),
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.zero,
                    width: MediaQuery.sizeOf(context).width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      gradient: LinearGradient(
                        colors: [Color(0xFF4ADE80), Color(0xFF60A5FA)],
                      ),
                    ),
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.transparent,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      label: Text(
                        "توليد الاقتراحات",
                        style: TextStyle(
                          color: Color(0xFFFFEEFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                        ),
                      ),
                      icon: Icon(FontAwesomeIcons.wandMagicSparkles, size: 16),
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
}
