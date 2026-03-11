import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../widgets/expanded_product_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/product_image_field.dart';
import '../widgets/product_text_field.dart';

@AutoRoutePage(path: "/products/new_product/ai")
class AddProductAIScreen extends StatefulWidget {
  const AddProductAIScreen({super.key});

  @override
  State<AddProductAIScreen> createState() => _AddProductAIScreenState();
}

class _AddProductAIScreenState extends State<AddProductAIScreen> {
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
  void dispose() {
    super.dispose();
    productDescriptionController.dispose();
    productNameController.dispose();
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
                                borderRadius: BorderRadius.all(
                                  Radius.circular(16),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  spacing: 8,
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppOutlinedButton(
                                        color: const Color(0xFF00A7BC),
                                        title: "عرض الصورة",
                                        onTap: () {
                                          print("show image");
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: double.infinity,
                                      child: AppButton(
                                        withShadow: false,
                                        title: "الموافقة والاستمرار",
                                        onTap: () {
                                          context.pushRoute(
                                            "/products/new_product/details",
                                          );

                                          print("continue");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
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
                          ProductImageField(onPickImage: (imagePath) {}),
                          SizedBox(height: 16),
                          GradientButton(
                            title: "توليد الاقتراحات",
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
                          ProductTextField(
                            title: "اسم المنتج",
                            controller: TextEditingController(
                              text: "برجر دجاج كلاسيك",
                            ),
                          ),
                          SizedBox(height: 8),
                          ProductTextField(
                            title: "وصف المنتج",
                            maxLines: 5,
                            controller: TextEditingController(
                              text:
                                  "شريحة دجاج طازجة متبلة بخلطتنا الخاصة، مقلية  حتى القرمشة الذهبية، تقدم مع الخس الطازج، الطماطم، وجبنة الشيدر الذائبة في خبز البريوش الطري.",
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              withShadow: false,
                              title: "الموافقة والاستمرار",
                              onTap: () {
                                context.pushRoute(
                                  "/products/new_product/details",
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
            ),
          ),
        ],
      ),
    );
  }
}
