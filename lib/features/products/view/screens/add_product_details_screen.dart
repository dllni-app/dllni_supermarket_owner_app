import 'dart:developer' show log;
import 'dart:typed_data';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/step_details.dart';
import '../../domain/usecases/add_product_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../manager/bloc/products_bloc.dart';
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
  late BarcodeScanner _barcodeScanner;
  late AddProductDetailsParams params;
  @override
  void initState() {
    _barcodeScanner = BarcodeScanner();
    if (widget.params != null) {
      params = widget.params!;
    } else {
      params = AddProductDetailsParams();
    }
    super.initState();
  }

  @override
  void dispose() {
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          getIt<ProductsBloc>()
            ..add(GetCategoriesEvent(params: GetCategoriesParams())),
      child: Scaffold(
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
                      StepDetails(
                        number: 1,
                        title: "المعلومات الأساسية",
                        child: Column(
                          children: [
                            AppTextField(
                              title: "اسم المنتج",
                              hintText: "مثال: برجر دجاج كلاسيك",
                              isRequired: true,
                              controller: TextEditingController(
                                text: params.title,
                              ),
                              onChanged: (value) {
                                params.title = value;
                              },
                            ),
                            SizedBox(height: 20),
                            AppTextField(
                              title: "وصف المنتج",
                              hintText: "وصف مكونات المنتج ومميزاته...",
                              controller: TextEditingController(
                                text: params.description,
                              ),
                              maxLines: 4,
                              onChanged: (value) {
                                params.description = value;
                              },
                            ),
                            SizedBox(height: 20),
                            BlocBuilder<ProductsBloc, ProductsState>(
                              buildWhen: (previous, current) =>
                                  previous.categoriesStatus !=
                                  current.categoriesStatus,
                              builder: (context, state) {
                                return switch (state.categoriesStatus) {
                                  BlocStatus.loading =>
                                    CircularProgressIndicator.adaptive(),
                                  BlocStatus.failed => FailureWidget(
                                    message:
                                        state.errorMessage ?? "Unknown Error",
                                  ),
                                  BlocStatus.success => ProductMenuField(
                                    title: "التصنيف",
                                    isRequired: true,
                                    hintText: "اختر تصنيف...",
                                    onChanged: (value) {
                                      if (value != null &&
                                          params.categoryId != value) {
                                        params.categoryId = value;
                                      }
                                    },
                                    items: List.generate(
                                      state.categories!.data!.length,
                                      (index) => DropdownMenuItem(
                                        value:
                                            state.categories!.data![index].id,
                                        child: AppText(
                                          state.categories!.data![index].name ??
                                              "null",
                                          style: TextStyle(fontFamily: "Cairo"),
                                        ),
                                      ),
                                    ),
                                  ),
                                  _ => SizedBox(),
                                };
                              },
                            ),
                            SizedBox(height: 20),
                            ProductPickMainImage(
                              title: "صورة رئيسية",
                              isRequired: true,
                              icon: FontAwesomeIcons.solidCamera,
                              onPickImage: (imagePath) {
                                print(imagePath);
                                params.mainImagePath = imagePath;
                                // params.mainImage64Based = File(
                                //   params.mainImagePath!,
                                // ).readAsBytesSync();
                              },
                            ),
                            SizedBox(height: 16),
                            ProductPickAdditionalImages(
                              numOfImages: 6,
                              onPickImage: (imagesPath) {
                                print(imagesPath);
                                params.additionalImagesPath = imagesPath;
                              },
                            ),
                            SizedBox(height: 24),
                            ProductPickMainImage(
                              title: "صورة  الباركود",
                              isRequired: true,
                              icon: FontAwesomeIcons.barcode,
                              onPickImage: (imagePath) async {
                                List<Barcode> barcodes = await _barcodeScanner
                                    .processImage(
                                      InputImage.fromFilePath(imagePath),
                                    );
                                if (!context.mounted) return;
                                if (barcodes.isEmpty) {
                                  AppToast.showToast(
                                    context: context,
                                    message: "الصورة ليست barcode",
                                    type: ToastificationType.error,
                                  );
                                  return;
                                }
                                params.barcode = barcodes.first.rawValue;
                                log(
                                  'Detected Barcode: ${barcodes.first.rawValue}',
                                );
                                log('Barcode Type: ${barcodes.first.type}');
                              },
                            ),
                            SizedBox(height: 24),
                            ProductUnit(
                              onChanged: (unit) {
                                print(unit);
                                params.unit = unit;
                              },
                            ),
                            SizedBox(height: 24),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    title: "الكمية الأولية",
                                    isRequired: true,
                                    hintText: "0",
                                    onChanged: (value) {
                                      if (int.tryParse(value) == null) return;
                                      params.quantity = int.parse(value);
                                    },
                                  ),
                                ),
                                Expanded(
                                  child: AppTextField(
                                    title: "الحد الأدنى",
                                    isRequired: true,
                                    hintText: "0",
                                    onChanged: (value) {
                                      if (int.tryParse(value) == null) return;
                                      params.lowStockQuantity = int.parse(
                                        value,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24),
                            AppDatePicker(
                              title: "صلاحية المنتج",
                              onDateChanged: (expiredDate) {
                                print(expiredDate);
                                params.expiredAt = expiredDate;
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      StepDetails(
                        number: 2,
                        title: "التسعير",
                        child: Column(
                          children: [
                            AppTextField(
                              title: "السعر الأساسي",
                              isRequired: true,
                              hintText: "0.00",
                              onChanged: (value) {
                                if (num.tryParse(value) == null) return;
                                params.price = num.parse(value);
                              },
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
                            AppTextField(
                              title: "السعر بعد الحسم",
                              hintText: "0.00",
                              isRequired: true,
                              onChanged: (value) {
                                if (num.tryParse(value) == null) return;
                                params.discountedPrice = num.parse(value);
                              },
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
                      BlocConsumer<ProductsBloc, ProductsState>(
                        listener: (context, state) {
                          if (state.addProductStatus == BlocStatus.success) {
                            context.pushRouteAndRemoveUntil("/", arguments: 2);
                          }
                          if (state.addProductStatus == BlocStatus.failed) {
                            AppToast.showToast(
                              context: context,
                              message: state.errorMessage.toString(),
                              type: ToastificationType.error,
                            );
                          }
                        },
                        buildWhen: (previous, current) =>
                            previous.addProductStatus !=
                            current.addProductStatus,
                        builder: (context, state) {
                          if (state.addProductStatus == BlocStatus.loading) {
                            return CircularProgressIndicator();
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: "نشر المنتج",
                                  onTap: () {
                                    if (!validateProductFields(
                                      context,
                                      params,
                                    )) {
                                      return;
                                    }
                                    context.read<ProductsBloc>().add(
                                      AddProductEvent(
                                        params: AddProductParams(
                                          params: params,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: 16),
                              AppOutlinedButton(
                                title: "إلغاء",
                                color: const Color(0xFFFF4C51),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 170),
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

bool validateProductFields(
  BuildContext context,
  AddProductDetailsParams params,
) {
  if (params.title == null || params.title!.trim().isEmpty) {
    AppToast.showToast(
      context: context,
      message: "يرجى إدخال اسم المنتج",
      type: ToastificationType.error,
    );
    return false;
  } else if (params.title!.length < 3) {
    AppToast.showToast(
      context: context,
      message: "اسم المنتج قصير جداً (3 أحرف على الأقل)",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.categoryId == null) {
    AppToast.showToast(
      context: context,
      message: "يرجى اختيار تصنيف للمنتج",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.mainImagePath == null && params.mainImage64Based == null) {
    AppToast.showToast(
      context: context,
      message: "يجب إضافة صورة أساسية للمنتج",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.barcode == null || params.barcode!.isEmpty) {
    AppToast.showToast(
      context: context,
      message: "يرجى إدخال رمز الباركود",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.unit == null || params.unit!.trim().isEmpty) {
    AppToast.showToast(
      context: context,
      message: "يرجى إدخال وحدة القياس",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.quantity == null || params.quantity! < 0) {
    AppToast.showToast(
      context: context,
      message: "الكمية الحالية غير منطقية",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.lowStockQuantity != null &&
      params.lowStockQuantity! > params.quantity!) {
    AppToast.showToast(
      context: context,
      message: "حد التنبيه لا يمكن أن يكون أكبر من الكمية الحالية",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.price == null || params.price! <= 0) {
    AppToast.showToast(
      context: context,
      message: "يرجى تحديد سعر صالح للمنتج",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.discountedPrice != null) {
    if (params.discountedPrice! >= params.price!) {
      AppToast.showToast(
        context: context,
        message: "سعر الخصم يجب أن يكون أقل من السعر الأساسي",
        type: ToastificationType.error,
      );
      return false;
    }
  }

  return true;
}

class AddProductDetailsParams {
  String? title;
  String? description;
  int? categoryId;
  Uint8List? mainImage64Based;
  String? mainImagePath;
  List<String>? additionalImagesPath;
  String? barcode;
  String? unit;
  int? quantity, lowStockQuantity;
  DateTime? expiredAt;
  num? price, discountedPrice;

  AddProductDetailsParams({
    this.title,
    this.description,
    this.mainImage64Based,
    this.mainImagePath,
    this.additionalImagesPath,
    this.barcode,
    this.unit,
    this.quantity,
    this.lowStockQuantity,
    this.expiredAt,
    this.price,
    this.discountedPrice,
  });
}
