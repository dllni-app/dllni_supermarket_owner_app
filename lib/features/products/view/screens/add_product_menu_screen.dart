import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/products/domain/usecases/import_products_file_use_case.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/gradient_button.dart';
import '../widgets/product_text_field.dart';

enum UploadFileType { image, file }

@AutoRoutePage(path: "/products/new_product/menu")
class AddProductMenuScreen extends StatefulWidget {
  const AddProductMenuScreen({super.key, this.type = UploadFileType.image});
  final UploadFileType? type;

  @override
  State<AddProductMenuScreen> createState() => _AddProductMenuScreenState();
}

class _AddProductMenuScreenState extends State<AddProductMenuScreen> {
  String? imagePath;
  File? file;
  int? categoryId;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            getIt<ProductsBloc>()
              ..add(GetCategoriesEvent(params: GetCategoriesParams())),
        child: Column(
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
                              "رفع ${widget.type == UploadFileType.image ? "صورة المنيو" : "ملف الـ Excel"}",
                              style: TextStyle(
                                color: const Color(0xFF111827),
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.5,
                              ),
                            ),
                            SizedBox(height: 4),
                            AppText(
                              "قم برفع ${widget.type == UploadFileType.image ? "صورة" : "ملف"} المنيو ليتم استخراج المنتجات تلقائياً",
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
                                if (imagePath != null &&
                                    widget.type == UploadFileType.image)
                                  Expanded(
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
                                if (file != null &&
                                    widget.type == UploadFileType.file)
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: AppColors.white,
                                            shape: BoxShape.circle,
                                            boxShadow: [AppShadows.shadow],
                                          ),
                                          child: Icon(
                                            FontAwesomeIcons.solidFileExcel,
                                            size: 18,
                                            color: Colors.green,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        AppText(
                                          file!.path.split("/").last,
                                          color: Color(0xFF111827),
                                        ),
                                      ],
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
                                        radius: const Radius.circular(24),
                                      ),
                                      child: Container(
                                        width: double.infinity,
                                        height: 190,
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF9FAFB),
                                          borderRadius: BorderRadius.circular(
                                            24,
                                          ),
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
                                                widget.type ==
                                                        UploadFileType.image
                                                    ? FontAwesomeIcons
                                                          .solidCamera
                                                    : FontAwesomeIcons
                                                          .solidFileExcel,
                                                size: 18,
                                                color: const Color(0xFF9CA3AF),
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            AppText(
                                              "اضغط لرفع ${widget.type == UploadFileType.image ? "صورة" : "ملف"}",
                                              style: TextStyle(
                                                color: const Color(0xE52F2B3D),
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                height: 1.333,
                                              ),
                                            ),
                                            SizedBox(height: 4),
                                            AppText(
                                              "CSV, Excel حتى 5MB",
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
                            SizedBox(height: 20),
                            BlocBuilder<ProductsBloc, ProductsState>(
                              buildWhen: (previous, current) =>
                                  previous.categoriesStatus !=
                                  current.categoriesStatus,
                              builder: (context, state) {
                                return switch (state.categoriesStatus) {
                                  BlocStatus.loading => Center(
                                    child: CircularProgressIndicator.adaptive(),
                                  ),
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
                                          categoryId != value) {
                                        categoryId = value;
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
                            SizedBox(height: 16),
                            BlocConsumer<ProductsBloc, ProductsState>(
                              listener: (context, state) {
                                if (state.importProductsFileStatus ==
                                    BlocStatus.success) {
                                  context.pushRouteAndRemoveUntil(
                                    "/",
                                    arguments: 2,
                                  );
                                }
                                if (state.importProductsFileStatus ==
                                    BlocStatus.failed) {
                                  AppToast.showToast(
                                    context: context,
                                    message: state.errorMessage.toString(),
                                    type: ToastificationType.error,
                                  );
                                }
                              },
                              buildWhen: (previous, current) =>
                                  previous.importProductsFileStatus !=
                                  current.importProductsFileStatus,
                              builder: (context, state) {
                                if (state.importProductsFileStatus ==
                                    BlocStatus.loading) {
                                  return SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GradientButton(
                                  title:
                                      "تحليل ${widget.type == UploadFileType.image ? "الصورة" : "الملف"}",
                                  icon: Icon(
                                    FontAwesomeIcons.wandMagicSparkles,
                                    size: 17,
                                    color: AppColors.white,
                                  ),
                                  onTap: () {
                                    if (!validateForm()) return;
                                    print("submit");
                                    context.read<ProductsBloc>().add(
                                      ImportProductsFileEvent(
                                        params: ImportProductsFileParams(
                                          categoryId: categoryId!,
                                          storeId: 1,
                                          filePath: file!.path,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      // ListView.separated(
                      //   physics: const NeverScrollableScrollPhysics(),
                      //   shrinkWrap: true,
                      //   padding: EdgeInsets.zero,
                      //   itemCount: 5,
                      //   separatorBuilder: (context, index) =>
                      //       SizedBox(height: 16),
                      //   itemBuilder: (context, index) => _NewProductCard(),
                      // ),
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

  bool validateForm() {
    if (file == null) {
      AppToast.showToast(
        context: context,
        message: "يجب أولا اختيار ملف excel او csv",
        type: ToastificationType.error,
      );
      return false;
    } else if (categoryId == null) {
      AppToast.showToast(
        context: context,
        message: "يجب أولا تحديد التصنيف",
        type: ToastificationType.error,
      );
      return false;
    }

    return true;
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
                child: AppTextField(
                  title: "اسم المنتج ",
                  hintText: "برجر دجاج كلاسيك",
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          AppTextField(
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

Future<File?> pickDocument(BuildContext context) async {
  var status = await Permission.storage.request();

  if (status.isPermanentlyDenied) {
    openAppSettings();
    return null;
  }

  if (status.isGranted || status.isLimited || Platform.isIOS) {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv', 'txt', 'xlsx', 'xls'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        int sizeInBytes = await file.length();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        if (!context.mounted) return null;
        if (sizeInMb > 10) {
          AppToast.showToast(
            context: context,
            message: "حجم الملف كبير جداً (الحد الأقصى 10 ميجا)",
            type: ToastificationType.error,
          );
          return null;
        }
        return file;
      }
      return null;
    } catch (e) {
      print("Error picking file: $e");
      return null;
    }
  } else {
    if (!context.mounted) return null;
    AppToast.showToast(
      context: context,
      message: "يجب منح صلاحية الوصول للملفات للمتابعة",
      type: ToastificationType.error,
    );
    return null;
  }
}
