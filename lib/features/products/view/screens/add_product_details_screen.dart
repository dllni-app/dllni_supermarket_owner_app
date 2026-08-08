import 'dart:io';
import 'dart:typed_data';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../../core/widgets/step_details.dart';
import '../../data/models/get_categories_model.dart';
import '../../data/models/get_products_model.dart';
import '../../data/models/search_master_products_model.dart';
import '../../domain/usecases/add_product_use_case.dart';
import '../../domain/usecases/get_categories_use_case.dart';
import '../../domain/usecases/search_master_products_use_case.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../manager/bloc/products_bloc.dart';
import '../widgets/product_pick_images.dart';
import '../widgets/product_text_field.dart';
import '../widgets/product_typeahead_field.dart';

@AutoRoutePage(path: "/products/new_product/details")
class AddProductDetailsScreen extends StatefulWidget {
  const AddProductDetailsScreen({super.key, this.params});

  final AddProductDetailsParams? params;

  @override
  State<AddProductDetailsScreen> createState() =>
      _AddProductDetailsScreenState();
}

class _AddProductDetailsScreenState extends State<AddProductDetailsScreen> {
  late AddProductDetailsParams params;
  bool get isEdit => params.editingProductId != null;

  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _quantityController;
  late final TextEditingController _lowStockController;
  late final TextEditingController _priceController;
  late final TextEditingController _discountedController;
  late final TextEditingController _categoryController;
  late final TextEditingController _masterProductController;

  String? _selectedCategoryName;
  String? _selectedMasterProductName;

  @override
  void initState() {
    super.initState();
    if (widget.params != null) {
      params = widget.params!;
    } else {
      params = AddProductDetailsParams();
    }
    _titleController = TextEditingController(text: params.title ?? '');
    _descriptionController = TextEditingController(
      text: params.description ?? '',
    );
    _quantityController = TextEditingController(
      text: params.quantity == null ? '' : '${params.quantity}',
    );
    _lowStockController = TextEditingController(
      text: params.lowStockQuantity == null ? '' : '${params.lowStockQuantity}',
    );
    _priceController = TextEditingController(
      text: params.price == null ? '' : '${params.price}',
    );
    _discountedController = TextEditingController(
      text: params.discountedPrice == null ? '' : '${params.discountedPrice}',
    );
    _categoryController = TextEditingController();
    _masterProductController = TextEditingController();
    _prepareMainImageFromGeneratedBytes();
  }

  Future<void> _prepareMainImageFromGeneratedBytes() async {
    if (params.mainImagePath != null || params.mainImage64Based == null) {
      return;
    }
    try {
      final filePath =
          '${Directory.systemTemp.path}/generated_product_${DateTime.now().microsecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(params.mainImage64Based!, flush: true);
      if (!mounted) return;
      setState(() {
        params.mainImagePath = file.path;
      });
    } catch (_) {
      // Keep form usable even if temp write fails; user can still pick manually.
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _lowStockController.dispose();
    _priceController.dispose();
    _discountedController.dispose();
    _categoryController.dispose();
    _masterProductController.dispose();
    super.dispose();
  }

  void _syncParamsFromControllers() {
    params.title = _titleController.text.trim();
    params.description = _descriptionController.text.trim();
    params.quantity = int.tryParse(_quantityController.text.trim());
    params.lowStockQuantity = int.tryParse(_lowStockController.text.trim());
    params.price = num.tryParse(_priceController.text.trim());
    final d = _discountedController.text.trim();
    params.discountedPrice = d.isEmpty ? null : num.tryParse(d);
  }

  List<GetCategoriesModelDataItem> _categorySuggestions(
    GetCategoriesModel? categories,
    String search,
  ) {
    final items = categories?.data ?? const <GetCategoriesModelDataItem>[];
    final query = search.trim().toLowerCase();
    if (query.isEmpty) {
      return items;
    }
    return items.where((category) {
      final name = (category.name ?? '').toLowerCase();
      final slug = (category.slug ?? '').toLowerCase();
      return name.contains(query) || slug.contains(query);
    }).toList();
  }

  Future<List<SearchMasterProductsDataItem>> _masterProductSuggestions(
    String search,
  ) async {
    final query = search.trim();
    final response = await getIt<SearchMasterProductsUseCase>()(
      SearchMasterProductsParams(
        page: 1,
        index: query.isEmpty ? null : query,
      ),
    );

    return response.fold(
      (failure) => throw Exception(failure.message),
      (model) => (model.data ?? const <SearchMasterProductsDataItem>[])
          .where((item) => item.masterProductId != null)
          .toList(),
    );
  }

  String? _categoryImageUrl(dynamic imageData) {
    if (imageData == null) return null;
    if (imageData is String) {
      final value = imageData.trim();
      return value.isEmpty ? null : value;
    }
    if (imageData is Map) {
      const keys = ['url', 'imageUrl', 'image_url', 'path', 'image'];
      for (final key in keys) {
        final value = imageData[key];
        if (value is String && value.trim().isNotEmpty) {
          return value.trim();
        }
      }
    }
    return null;
  }

  String? _masterProductSubtitle(SearchMasterProductsDataItem item) {
    final parts = <String>[];
    if (item.brand != null && item.brand!.trim().isNotEmpty) {
      parts.add(item.brand!.trim());
    }
    if (item.masterProductId != null) {
      parts.add('#${item.masterProductId}');
    }
    return parts.isEmpty ? null : parts.join(' • ');
  }

  GetCategoriesModelDataItem? _selectedCategory(
    GetCategoriesModel? categories,
  ) {
    final categoryId = params.categoryId;
    if (categoryId == null) return null;
    for (final category in categories?.data ?? const <GetCategoriesModelDataItem>[]) {
      if (category.id == categoryId) return category;
    }
    return null;
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
            AppSimpleAppBar(title: isEdit ? "تعديل المنتج" : "إضافة منتج جديد"),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      StepDetails(
                        number: 1,
                        title: "المعلومات الأساسية",
                        child: Column(
                          children: [
                            AppTextField(
                              title: "اسم المنتج",
                              hintText: "مثال: برجر دجاج كلاسيك",
                              isRequired: true,
                              controller: _titleController,
                              onChanged: (value) {
                                params.title = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            AppTextField(
                              title: "وصف المنتج",
                              hintText: "وصف مكونات المنتج ومميزاته...",
                              controller: _descriptionController,
                              maxLines: 4,
                              onChanged: (value) {
                                params.description = value;
                              },
                            ),
                            const SizedBox(height: 20),
                            BlocBuilder<ProductsBloc, ProductsState>(
                              buildWhen: (previous, current) =>
                                  previous.categoriesStatus !=
                                      current.categoriesStatus ||
                                  previous.categories != current.categories,
                              builder: (context, state) {
                                return switch (state.categoriesStatus) {
                                  BlocStatus.loading =>
                                    const CircularProgressIndicator.adaptive(),
                                  BlocStatus.failed => FailureWidget(
                                    message:
                                        state.errorMessage ?? "Unknown Error",
                                  ),
                                  BlocStatus.success => Builder(
                                    builder: (context) {
                                      final selected = _selectedCategory(
                                        state.categories,
                                      );
                                      if (_categoryController.text.isEmpty &&
                                          selected != null &&
                                          (selected.name ?? '').isNotEmpty) {
                                        _selectedCategoryName = selected.name;
                                        _categoryController.text =
                                            selected.name ?? '';
                                      }
                                      return ProductTypeAheadField<
                                        GetCategoriesModelDataItem
                                      >(
                                        title: "التصنيف",
                                        isRequired: true,
                                        hintText: "ابحث واختر تصنيف...",
                                        controller: _categoryController,
                                        suggestionsCallback: (search) =>
                                            _categorySuggestions(
                                              state.categories,
                                              search,
                                            ),
                                        titleBuilder: (category) =>
                                            category.name ?? 'بدون اسم',
                                        imageUrlBuilder: (category) =>
                                            _categoryImageUrl(
                                              category.imagePath,
                                            ),
                                        subtitleBuilder: (category) {
                                          final count = category.productsCount;
                                          return count == null
                                              ? null
                                              : '$count منتج';
                                        },
                                        onTextChanged: (value) {
                                          if (_selectedCategoryName != null &&
                                              value != _selectedCategoryName) {
                                            params.categoryId = null;
                                            _selectedCategoryName = null;
                                          }
                                        },
                                        onSelected: (category) {
                                          params.categoryId = category.id;
                                          _selectedCategoryName = category.name;
                                        },
                                      );
                                    },
                                  ),
                                  _ => const SizedBox(),
                                };
                              },
                            ),
                            const SizedBox(height: 20),
                            ProductTypeAheadField<
                              SearchMasterProductsDataItem
                            >(
                              title: "المنتج الرئيسي",
                              hintText: params.masterProductId == null
                                  ? "ابحث واختر المنتج الرئيسي..."
                                  : "المنتج الحالي #${params.masterProductId} - ابحث للتغيير",
                              controller: _masterProductController,
                              suggestionsCallback: _masterProductSuggestions,
                              titleBuilder: (product) =>
                                  product.name ?? 'بدون اسم',
                              subtitleBuilder: _masterProductSubtitle,
                              imageUrlBuilder: (product) =>
                                  product.primaryImage,
                              onTextChanged: (value) {
                                if (_selectedMasterProductName != null &&
                                    value != _selectedMasterProductName) {
                                  params.masterProductId = null;
                                  _selectedMasterProductName = null;
                                } else if (_selectedMasterProductName == null &&
                                    params.masterProductId != null &&
                                    value.trim().isNotEmpty) {
                                  params.masterProductId = null;
                                }
                              },
                              onSelected: (product) {
                                params.masterProductId =
                                    product.masterProductId;
                                _selectedMasterProductName = product.name;
                              },
                            ),
                            const SizedBox(height: 20),
                            ProductPickMainImage(
                              title: "صورة رئيسية",
                              isRequired: !isEdit,
                              initialImagePath: params.mainImagePath,
                              networkImageUrl: params.initialMainImageUrl,
                              icon: FontAwesomeIcons.solidCamera.data,
                              onPickImage: (imagePath) {
                                params.mainImagePath = imagePath;
                              },
                            ),
                            const SizedBox(height: 16),
                            ProductPickAdditionalImages(
                              numOfImages: 6,
                              onPickImage: (imagesPath) {
                                params.additionalImagesPath = imagesPath;
                              },
                            ),
                            const SizedBox(height: 24),
                            ProductUnit(
                              initialUnit:
                                  (params.unit != null &&
                                      params.unit!.trim().isNotEmpty)
                                  ? params.unit
                                  : null,
                              onChanged: (unit) {
                                params.unit = unit;
                              },
                            ),
                            const SizedBox(height: 24),
                            Row(
                              spacing: 10,
                              children: [
                                Expanded(
                                  child: AppTextField(
                                    title: "الكمية الأولية",
                                    isRequired: true,
                                    hintText: "0",
                                    controller: _quantityController,
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
                                    controller: _lowStockController,
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
                            const SizedBox(height: 24),
                            AppDatePicker(
                              title: "صلاحية المنتج",
                              initialDate: params.expiredAt,
                              onDateChanged: (expiredDate) {
                                params.expiredAt = expiredDate;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      StepDetails(
                        number: 2,
                        title: "التسعير",
                        child: Column(
                          children: [
                            AppTextField(
                              title: "السعر الأساسي",
                              isRequired: true,
                              hintText: "0.00",
                              controller: _priceController,
                              onChanged: (value) {
                                if (num.tryParse(value) == null) return;
                                params.price = num.parse(value);
                              },
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(top: 12),
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
                            const SizedBox(height: 20),
                            AppTextField(
                              title: "السعر بعد الحسم",
                              hintText: "0.00",
                              isRequired: !isEdit,
                              controller: _discountedController,
                              onChanged: (value) {
                                if (value.isEmpty) {
                                  params.discountedPrice = null;
                                  return;
                                }
                                if (num.tryParse(value) == null) return;
                                params.discountedPrice = num.parse(value);
                              },
                              suffixIcon: const Padding(
                                padding: EdgeInsets.only(top: 12),
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
                      const SizedBox(height: 32),
                      BlocConsumer<ProductsBloc, ProductsState>(
                        listenWhen: (p, c) {
                          if (isEdit) {
                            return p.productStatus != c.productStatus;
                          }
                          return p.addProductStatus != c.addProductStatus;
                        },
                        listener: (context, state) {
                          if (isEdit) {
                            if (state.productStatus == BlocStatus.success) {
                              context.pop(true);
                            }
                            if (state.productStatus == BlocStatus.failed) {
                              AppToast.showToast(
                                context: context,
                                message: state.errorMessage.toString(),
                                type: ToastificationType.error,
                              );
                            }
                          } else {
                            if (state.addProductStatus == BlocStatus.success) {
                              context.pushRouteAndRemoveUntil(
                                "/",
                                arguments: 2,
                              );
                            }
                            if (state.addProductStatus == BlocStatus.failed) {
                              AppToast.showToast(
                                context: context,
                                message: state.errorMessage.toString(),
                                type: ToastificationType.error,
                              );
                            }
                          }
                        },
                        buildWhen: (previous, current) =>
                            previous.addProductStatus !=
                                current.addProductStatus ||
                            previous.productStatus != current.productStatus,
                        builder: (context, state) {
                          final busy =
                              (!isEdit &&
                                  state.addProductStatus ==
                                      BlocStatus.loading) ||
                              (isEdit &&
                                  state.productStatus == BlocStatus.loading);
                          if (busy) {
                            return const CircularProgressIndicator();
                          }
                          return Row(
                            children: [
                              Expanded(
                                child: AppButton(
                                  title: isEdit
                                      ? "حفظ التغييرات"
                                      : "نشر المنتج",
                                  onTap: () {
                                    _syncParamsFromControllers();
                                    if (isEdit) {
                                      if (!validateProductFields(
                                        context,
                                        params,
                                      )) {
                                        return;
                                      }
                                      context.read<ProductsBloc>().add(
                                        UpdateProductEvent(
                                          params: UpdateProductParams.form(
                                            productId: params.editingProductId!,
                                            body: buildUpdateStoreProductBody(
                                              params,
                                            ),
                                          ),
                                        ),
                                      );
                                    } else {
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
                                    }
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              AppOutlinedButton(
                                title: "إلغاء",
                                color: const Color(0xFFFF4C51),
                                onTap: () => context.pop(),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 170),
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

UpdateStoreProductBody buildUpdateStoreProductBody(
  AddProductDetailsParams params,
) {
  final Object? image;
  if (params.mainImagePath != null) {
    image = File(params.mainImagePath!);
  } else if (params.initialMainImageUrl != null &&
      params.initialMainImageUrl!.isNotEmpty) {
    image = params.initialMainImageUrl;
  } else {
    image = null;
  }
  final images = <dynamic>[
    ...params.existingAdditionalImageUrls,
    if (params.additionalImagesPath != null)
      for (final path in params.additionalImagesPath!) File(path),
  ];
  String? expiresAtStr;
  final e = params.expiredAt;
  if (e != null) {
    expiresAtStr = e.toIso8601String();
  }
  return UpdateStoreProductBody(
    categoryId: params.categoryId!,
    masterProductId: params.masterProductId,
    name: params.title!.trim(),
    description: (params.description == null || params.description!.isEmpty)
        ? null
        : params.description,
    price: params.price!,
    discountedPrice: params.discountedPrice,
    stockQuantity: params.quantity!,
    lowStockThreshold: params.lowStockQuantity!,
    expiresAt: expiresAtStr,
    isAvailable: true,
    image: image,
    images: images,
  );
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

  final hasMainImage =
      params.mainImagePath != null ||
      params.mainImage64Based != null ||
      (params.editingProductId != null &&
          (params.initialMainImageUrl != null &&
              params.initialMainImageUrl!.isNotEmpty));

  if (!hasMainImage) {
    AppToast.showToast(
      context: context,
      message: "يجب إضافة صورة أساسية للمنتج",
      type: ToastificationType.error,
    );
    return false;
  }

  if (params.editingProductId == null) {
    if (params.unit == null || params.unit!.trim().isEmpty) {
      AppToast.showToast(
        context: context,
        message: "يرجى إدخال وحدة القياس",
        type: ToastificationType.error,
      );
      return false;
    }
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
  int? editingProductId;
  int? masterProductId;
  String? initialMainImageUrl;
  List<String> existingAdditionalImageUrls;
  List<String>? additionalImagesPath;
  String? unit;
  int? quantity, lowStockQuantity;
  DateTime? expiredAt;
  num? price, discountedPrice;

  AddProductDetailsParams({
    this.title,
    this.description,
    this.categoryId,
    this.mainImage64Based,
    this.mainImagePath,
    this.editingProductId,
    this.masterProductId,
    this.initialMainImageUrl,
    this.existingAdditionalImageUrls = const [],
    this.additionalImagesPath,
    this.unit,
    this.quantity,
    this.lowStockQuantity,
    this.expiredAt,
    this.price,
    this.discountedPrice,
  });

  static AddProductDetailsParams fromProduct(GetProductsModelDataItem p) {
    String? desc;
    final d = p.description;
    if (d is String) {
      desc = d;
    } else if (d != null) {
      desc = d.toString();
    }
    num? pr;
    if (p.price != null && p.price!.isNotEmpty) {
      pr = num.tryParse(p.price!);
    }
    num? dpr;
    if (p.discountedPrice != null && p.discountedPrice!.isNotEmpty) {
      dpr = num.tryParse(p.discountedPrice!);
    }
    DateTime? ex;
    if (p.expiresAt != null) {
      if (p.expiresAt is DateTime) {
        ex = p.expiresAt as DateTime;
      } else {
        ex = DateTime.tryParse(p.expiresAt.toString());
      }
    }
    final urlList =
        p.imageUrls
            ?.map((e) => e?.toString() ?? '')
            .where((s) => s.isNotEmpty)
            .toList() ??
        <String>[];
    String? mainU;
    final rest = <String>[];
    if (urlList.isNotEmpty) {
      mainU = urlList.first;
      if (urlList.length > 1) {
        rest.addAll(urlList.sublist(1));
      }
    }
    return AddProductDetailsParams(
      editingProductId: p.id,
      masterProductId: p.masterProductId,
      title: p.name,
      description: desc,
      categoryId: p.categoryId,
      mainImagePath: null,
      initialMainImageUrl: mainU,
      existingAdditionalImageUrls: rest,
      quantity: p.stockQuantity,
      lowStockQuantity: p.lowStockThreshold,
      price: pr,
      discountedPrice: dpr,
      expiredAt: ex,
    );
  }
}
