import 'dart:convert';
import 'dart:typed_data';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/get_product_from_text_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../domain/usecases/get_product_from_image_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/expanded_product_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/product_image_field.dart';
import '../widgets/product_text_field.dart';
import 'add_product_details_screen.dart';

@AutoRoutePage(path: "/products/new_product/ai")
class AddProductAIScreen extends StatefulWidget {
  const AddProductAIScreen({super.key});

  @override
  State<AddProductAIScreen> createState() => _AddProductAIScreenState();
}

class _AddProductAIScreenState extends State<AddProductAIScreen> {
  // from Text to Image properties
  late TextEditingController productNameController;
  late TextEditingController productDescriptionController;
  Uint8List? generatedImage64Based;

  // from Image to Text properties
  String? imagePath;
  late TextEditingController generatedProductNameController;
  late TextEditingController generatedProductDescriptionController;

  @override
  void initState() {
    super.initState();
    productNameController = TextEditingController();
    productDescriptionController = TextEditingController();
    generatedProductNameController = TextEditingController();
    generatedProductDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    productNameController.dispose();
    productDescriptionController.dispose();
    generatedProductNameController.dispose();
    generatedProductDescriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProductsBloc>(),
      child: Scaffold(
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
                              isRequired: true,
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
                            BlocBuilder<ProductsBloc, ProductsState>(
                              buildWhen: (previous, current) =>
                                  previous.productFromTextStatus !=
                                  current.productFromTextStatus,
                              builder: (context, state) {
                                if (state.productFromTextStatus ==
                                    BlocStatus.loading) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GradientButton(
                                  title: "توليد الصورة",
                                  icon: Icon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    size: 17,
                                    color: AppColors.white,
                                  ),
                                  onTap: () {
                                    if (productNameController.text
                                        .trim()
                                        .isEmpty) {
                                      AppToast.showToast(
                                        context: context,
                                        message: "يجب تعبئة حقل 'اسم المنتج'",
                                        type: ToastificationType.error,
                                      );
                                      return;
                                    }
                                    context.read<ProductsBloc>().add(
                                      GetProductFromTextEvent(
                                        params: GetProductFromTextParams(
                                          title: productNameController.text
                                              .trim(),
                                          description:
                                              productDescriptionController.text
                                                  .trim(),
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            BlocConsumer<ProductsBloc, ProductsState>(
                              listener: (context, state) {
                                if (state.productFromTextStatus ==
                                        BlocStatus.success &&
                                    state.productFromText?.data?.imageBase64 !=
                                        null) {
                                  generatedImage64Based = base64Decode(
                                    state.productFromText!.data!.imageBase64!,
                                  );
                                }
                                if (state.productFromTextStatus ==
                                    BlocStatus.failed) {
                                  AppToast.showToast(
                                    context: context,
                                    message:
                                        state.errorMessage ?? "Unknown Error",
                                    type: ToastificationType.error,
                                  );
                                }
                              },
                              buildWhen: (previous, current) =>
                                  previous.productFromTextStatus !=
                                  current.productFromTextStatus,
                              builder: (context, state) {
                                switch (state.productFromTextStatus) {
                                  case BlocStatus.success:
                                    return Column(
                                      children: [
                                        SizedBox(height: 16),
                                        Row(
                                          spacing: 10,
                                          children: [
                                            if (state
                                                    .productFromText
                                                    ?.data
                                                    ?.imageBase64 !=
                                                null)
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(16),
                                                ),
                                                child: Image(
                                                  image: MemoryImage(
                                                    base64Decode(
                                                      state
                                                          .productFromText!
                                                          .data!
                                                          .imageBase64!,
                                                    ),
                                                  ),
                                                  width: 99,
                                                  height: 99,
                                                ),
                                              )
                                            else
                                              SizedBox(
                                                width: 99,
                                                height: 99,
                                                child: Center(
                                                  child: Icon(
                                                    Icons.warning_rounded,
                                                    color: Color(0xFFFF4C51),
                                                  ),
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
                                                      color: const Color(
                                                        0xFF00A7BC,
                                                      ),
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
                                                      title:
                                                          "الموافقة والاستمرار",
                                                      onTap: () {
                                                        context.pushRoute(
                                                          "/products/new_product/details",
                                                          arguments:
                                                              AddProductDetailsParams(
                                                                image64Based:
                                                                    generatedImage64Based,
                                                              ),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  default:
                                    return SizedBox();
                                }
                              },
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
                            ProductImageField(
                              onPickImage: (imagePath) {
                                this.imagePath = imagePath;
                              },
                            ),
                            SizedBox(height: 16),
                            BlocConsumer<ProductsBloc, ProductsState>(
                              listener: (context, state) {
                                if (state.productFromImageStatus ==
                                    BlocStatus.success) {
                                  generatedProductNameController =
                                      TextEditingController(
                                        text:
                                            state.productFromImage?.data?.title,
                                      );
                                  generatedProductDescriptionController =
                                      TextEditingController(
                                        text: state
                                            .productFromImage
                                            ?.data
                                            ?.description,
                                      );
                                }
                              },
                              builder: (context, state) {
                                if (state.productFromImageStatus ==
                                    BlocStatus.loading) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GradientButton(
                                  title: "توليد الاقتراحات",
                                  icon: Icon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    size: 17,
                                    color: AppColors.white,
                                  ),
                                  onTap: () {
                                    if (imagePath == null) {
                                      AppToast.showToast(
                                        context: context,
                                        message: "يجب اختيار صورة أولاً",
                                        type: ToastificationType.error,
                                      );
                                      return;
                                    }
                                    context.read<ProductsBloc>().add(
                                      GetProductFromImageEvent(
                                        params: GetProductFromImageParams(
                                          imagePath: imagePath!,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                            BlocBuilder<ProductsBloc, ProductsState>(
                              buildWhen: (previous, current) =>
                                  previous.productFromImageStatus !=
                                  current.productFromImageStatus,
                              builder: (context, state) {
                                if (state.productFromImageStatus ==
                                    BlocStatus.success) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 16),
                                      ProductTextField(
                                        title: "اسم المنتج",
                                        controller:
                                            generatedProductNameController,
                                      ),
                                      SizedBox(height: 8),
                                      ProductTextField(
                                        title: "وصف المنتج",
                                        maxLines: null,
                                        controller:
                                            generatedProductDescriptionController,
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
                                              arguments: AddProductDetailsParams(
                                                title:
                                                    generatedProductNameController
                                                        .text,
                                                description:
                                                    generatedProductDescriptionController
                                                        .text,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return SizedBox();
                              },
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
      ),
    );
  }
}
