import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../widgets/gradient_button.dart';
import '../widgets/product_text_field.dart';

@AutoRoutePage(path: "/products/new_product/menu")
class AddProductMenuScreen extends StatefulWidget {
  const AddProductMenuScreen({super.key});

  @override
  State<AddProductMenuScreen> createState() => _AddProductMenuScreenState();
}

class _AddProductMenuScreenState extends State<AddProductMenuScreen> {
  String? imagePath;
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
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(color: const Color(0xFFF3F4F6)),
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        boxShadow: [AppShadows.shadow],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            "رفع صورة المنيو",
                            style: TextStyle(
                              color: const Color(0xFF111827),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                            ),
                          ),
                          SizedBox(height: 4),
                          AppText(
                            "قم برفع صورة المنيو ليتم استخراج المنتجات تلقائياً",
                            style: TextStyle(
                              color: const Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.625,
                            ),
                          ),
                          SizedBox(height: 16),
                          Row(
                            children: [
                              if (imagePath != null)
                                Expanded(
                                  child: InkWell(
                                    onTap: pickImage,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(24),
                                      ),
                                      child: Image(
                                        height: 194,
                                        image: FileImage(File(imagePath!)),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              Expanded(
                                child: InkWell(
                                  onTap: pickImage,
                                  child: DottedBorder(
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: AppColors.white,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(24),
                                              ),
                                              boxShadow: [AppShadows.shadow],
                                            ),
                                            child: Icon(
                                              FontAwesomeIcons.solidCamera,
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
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          GradientButton(
                            title: "تحليل الصورة",
                            icon: Icon(
                              FontAwesomeIcons.wandMagicSparkles,
                              size: 17,
                              color: AppColors.white,
                            ),
                            onTap: () {},
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: 5,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 16),
                      itemBuilder: (context, index) => _NewProductCard(),
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

  void pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return;
    imagePath = pickedImage.path;
    setState(() {});
  }
}

class _NewProductCard extends StatelessWidget {
  const _NewProductCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFFF9FAFB)),
        borderRadius: BorderRadius.all(Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 0),
            blurRadius: 15,
            color: const Color(0x08000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              AppImage.asset(AppImages.burgerImage, size: 96),
              SizedBox(width: 16),
              Expanded(
                child: ProductTextField(
                  title: "اسم المنتج ",
                  hintText: "برجر دجاج كلاسيك",
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          ProductTextField(
            maxLines: 5,
            title: "وصف المنتج",
            hintText:
                "شريحة دجاج طازجة متبلة بخلطتنا الخاصة، مقلية  حتى القرمشة الذهبية، تقدم مع الخس الطازج، الطماطم، وجبنة الشيدر الذائبة في خبز البريوش الطري.",
          ),
        ],
      ),
    );
  }
}
