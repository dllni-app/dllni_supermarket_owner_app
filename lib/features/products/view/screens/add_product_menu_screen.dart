import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/get_product_from_image_use_case.dart';
import '../../domain/usecases/import_products_file_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/gradient_button.dart';
import '../widgets/product_text_field.dart';
import 'add_product_details_screen.dart';

enum UploadFileType { image, file }

@AutoRoutePage(path: '/products/new_product/menu')
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

  bool get _isFileImport => widget.type == UploadFileType.file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => getIt<ProductsBloc>()
          ..add(GetCategoriesEvent(params: GetCategoriesParams())),
        child: Builder(
          builder: (context) {
            return Column(
              children: [
                const AppSimpleAppBar(title: 'إضافة منتج جديد'),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            border: Border.all(color: const Color(0xFFF3F4F6)),
                            borderRadius: const BorderRadius.all(Radius.circular(16)),
                            boxShadow: [AppShadows.shadow],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(
                                _isFileImport ? 'رفع ملف Excel أو CSV' : 'رفع صورة المنتج',
                                style: const TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              AppText(
                                _isFileImport
                                    ? 'اختر ملف CSV أو Excel لاستيراد عدة منتجات دفعة واحدة.'
                                    : 'اختر صورة ليتم تحليل بيانات المنتج ثم مراجعتها قبل الحفظ.',
                                style: const TextStyle(
                                  color: Color(0xFF6B7280),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  height: 1.625,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _SelectedSourcePreview(
                                isFileImport: _isFileImport,
                                file: file,
                                imagePath: imagePath,
                              ),
                              const SizedBox(height: 10),
                              InkWell(
                                onTap: _pickSource,
                                borderRadius: BorderRadius.circular(24),
                                child: DottedBorder(
                                  options: const RoundedRectDottedBorderOptions(
                                    dashPattern: [8, 8],
                                    strokeWidth: 2,
                                    color: Color(0x1F2F2B3D),
                                    radius: Radius.circular(24),
                                  ),
                                  child: Container(
                                    width: double.infinity,
                                    height: 150,
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
                                            shape: BoxShape.circle,
                                            boxShadow: [AppShadows.shadow],
                                          ),
                                          child: Icon(
                                            _isFileImport
                                                ? FontAwesomeIcons.solidFileExcel.data
                                                : FontAwesomeIcons.solidCamera.data,
                                            size: 18,
                                            color: const Color(0xFF9CA3AF),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        AppText(
                                          _isFileImport
                                              ? 'اضغط لاختيار ملف Excel أو CSV'
                                              : 'اضغط لاختيار صورة',
                                          style: const TextStyle(
                                            color: Color(0xE52F2B3D),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        AppText(
                                          _isFileImport
                                              ? 'CSV, XLSX, XLS حتى 10MB'
                                              : 'PNG, JPG',
                                          style: const TextStyle(
                                            color: Color(0x662F2B3D),
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              BlocBuilder<ProductsBloc, ProductsState>(
                                buildWhen: (previous, current) =>
                                    previous.categoriesStatus != current.categoriesStatus ||
                                    previous.categories != current.categories,
                                builder: (context, state) {
                                  return switch (state.categoriesStatus) {
                                    BlocStatus.loading => const Center(
                                        child: CircularProgressIndicator.adaptive(),
                                      ),
                                    BlocStatus.failed => FailureWidget(
                                        message: state.errorMessage ?? 'تعذر تحميل التصنيفات',
                                        onRetry: () => context.read<ProductsBloc>().add(
                                              GetCategoriesEvent(params: GetCategoriesParams()),
                                            ),
                                      ),
                                    BlocStatus.success => ProductMenuField<int>(
                                        title: 'التصنيف',
                                        isRequired: true,
                                        hintText: 'اختر تصنيف...',
                                        value: categoryId,
                                        onChanged: (value) => setState(() => categoryId = value),
                                        items: (state.categories?.data ?? const [])
                                            .where((item) => item.id != null)
                                            .map(
                                              (item) => DropdownMenuItem<int>(
                                                value: item.id!,
                                                child: AppText(
                                                  item.name ?? '-',
                                                  style: const TextStyle(fontFamily: 'Cairo'),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    _ => const SizedBox.shrink(),
                                  };
                                },
                              ),
                              const SizedBox(height: 16),
                              BlocConsumer<ProductsBloc, ProductsState>(
                                listenWhen: (previous, current) =>
                                    previous.importProductsFileStatus != current.importProductsFileStatus ||
                                    previous.productFromImageStatus != current.productFromImageStatus,
                                listener: (context, state) {
                                  if (_isFileImport &&
                                      state.importProductsFileStatus == BlocStatus.success) {
                                    AppToast.showToast(
                                      context: context,
                                      message: 'تم استيراد المنتجات بنجاح',
                                      type: ToastificationType.success,
                                    );
                                    context.pushRouteAndRemoveUntil('/', arguments: 2);
                                    return;
                                  }

                                  if (!_isFileImport &&
                                      state.productFromImageStatus == BlocStatus.success) {
                                    final extracted = state.productFromImage?.data;
                                    context.pushRoute(
                                      '/products/new_product/details',
                                      arguments: AddProductDetailsParams(
                                        title: extracted?.title,
                                        description: extracted?.description,
                                        categoryId: categoryId,
                                        mainImagePath: imagePath,
                                      ),
                                    );
                                    return;
                                  }

                                  final failed = _isFileImport
                                      ? state.importProductsFileStatus == BlocStatus.failed
                                      : state.productFromImageStatus == BlocStatus.failed;
                                  if (failed) {
                                    AppToast.showToast(
                                      context: context,
                                      message: state.errorMessage ?? 'تعذر تحليل الملف',
                                      type: ToastificationType.error,
                                    );
                                  }
                                },
                                buildWhen: (previous, current) =>
                                    previous.importProductsFileStatus != current.importProductsFileStatus ||
                                    previous.productFromImageStatus != current.productFromImageStatus,
                                builder: (context, state) {
                                  final loading = _isFileImport
                                      ? state.importProductsFileStatus == BlocStatus.loading
                                      : state.productFromImageStatus == BlocStatus.loading;
                                  if (loading) {
                                    return const SizedBox(
                                      height: 28,
                                      width: 28,
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return GradientButton(
                                    title: _isFileImport ? 'استيراد المنتجات' : 'تحليل الصورة',
                                    icon: Icon(
                                      FontAwesomeIcons.wandMagicSparkles.data,
                                      size: 17,
                                      color: AppColors.white,
                                    ),
                                    onTap: () => _submit(context),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickSource() async {
    if (_isFileImport) {
      final selected = await _pickDocument();
      if (!mounted || selected == null) return;
      setState(() {
        file = selected;
        imagePath = null;
      });
      return;
    }

    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (!mounted || pickedImage == null) return;
    setState(() {
      imagePath = pickedImage.path;
      file = null;
    });
  }

  Future<File?> _pickDocument() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv', 'xlsx', 'xls'],
        allowMultiple: false,
      );
      final path = result?.files.single.path;
      if (path == null) return null;

      final selected = File(path);
      final sizeInBytes = await selected.length();
      if (!mounted) return null;
      if (sizeInBytes > 10 * 1024 * 1024) {
        AppToast.showToast(
          context: context,
          message: 'حجم الملف كبير جداً (الحد الأقصى 10 ميجا)',
          type: ToastificationType.error,
        );
        return null;
      }
      return selected;
    } catch (_) {
      if (!mounted) return null;
      AppToast.showToast(
        context: context,
        message: 'تعذر فتح الملف، حاول مرة أخرى',
        type: ToastificationType.error,
      );
      return null;
    }
  }

  bool _validateForm() {
    if (_isFileImport && file == null) {
      AppToast.showToast(
        context: context,
        message: 'يجب أولاً اختيار ملف Excel أو CSV',
        type: ToastificationType.error,
      );
      return false;
    }
    if (!_isFileImport && imagePath == null) {
      AppToast.showToast(
        context: context,
        message: 'يجب أولاً اختيار صورة',
        type: ToastificationType.error,
      );
      return false;
    }
    if (categoryId == null) {
      AppToast.showToast(
        context: context,
        message: 'يجب أولاً تحديد التصنيف',
        type: ToastificationType.error,
      );
      return false;
    }
    return true;
  }

  void _submit(BuildContext blocContext) {
    if (!_validateForm()) return;

    if (_isFileImport) {
      blocContext.read<ProductsBloc>().add(
            ImportProductsFileEvent(
              params: ImportProductsFileParams(
                categoryId: categoryId!,
                filePath: file!.path,
              ),
            ),
          );
      return;
    }

    blocContext.read<ProductsBloc>().add(
          GetProductFromImageEvent(
            params: GetProductFromImageParams(imagePath: imagePath!),
          ),
        );
  }
}

class _SelectedSourcePreview extends StatelessWidget {
  const _SelectedSourcePreview({
    required this.isFileImport,
    required this.file,
    required this.imagePath,
  });

  final bool isFileImport;
  final File? file;
  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    if (isFileImport && file != null) {
      final fileName = file!.path.split(Platform.pathSeparator).last;
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: Row(
          children: [
            const Icon(Icons.description_rounded, color: Color(0xFF15803D)),
            const SizedBox(width: 10),
            Expanded(
              child: AppText(
                fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: const Color(0xFF166534),
              ),
            ),
          ],
        ),
      );
    }

    if (!isFileImport && imagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Image.file(
          File(imagePath!),
          width: double.infinity,
          height: 180,
          fit: BoxFit.cover,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
