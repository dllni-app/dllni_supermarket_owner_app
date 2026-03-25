import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_offer_codes_use_case.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_gradients.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../../core/widgets/step_details.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../data/models/add_offer_model.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/usecases/add_offer_use_case.dart';
import '../../domain/usecases/get_products_count_use_case.dart';
import '../../domain/usecases/get_products_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'products_screen.dart';

@AutoRoutePage(path: "/create_offer")
class CreateOfferScreen extends StatefulWidget {
  const CreateOfferScreen({super.key});

  @override
  State<CreateOfferScreen> createState() => _CreateOfferScreenState();
}

class _CreateOfferScreenState extends State<CreateOfferScreen> {
  String discountType = "%";
  List<GetProductsModelDataItem> selectedProducts = [];
  AddOfferModelData offer = AddOfferModelData(
    offerType: "percent",
    isActive: true,
  );

  @override
  void initState() {
    context.read<ProfileBloc>()
      ..add(GetProductsEvent(isReload: true, params: GetProductsParams()))
      ..add(GetProductsCountEvent(params: GetProductsCountParams()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إنشاء عرض جديد"),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              child: Column(
                children: [
                  StepDetails(
                    number: 1,
                    title: "المعلومات الأساسية",
                    child: AppTextField(
                      title: "اسم العرض",
                      hintText: "مثال: خصم 25% على  منتجات التنظيف بشرى",
                      onChanged: (value) {
                        offer.name = value;
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 2,
                    title: "نوع الخصم",
                    child: Column(
                      children: [
                        DiscountChooser(
                          onChanged: (discountType) {
                            print(discountType);
                            if (discountType == "نسبة مئوية") {
                              this.discountType = "%";
                              offer.offerType = "percent";
                            } else {
                              this.discountType = "ل.س";
                              offer.offerType = "value";
                            }
                            offer.discountPercent = null;
                            offer.discountValue = null;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 8),
                        AppTextField(
                          title: "قيمة الخصم ($discountType)",
                          hintText: "0",
                          keyboardType: TextInputType.number,
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              discountType,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          controller: TextEditingController(
                            text:
                                offer.discountPercent?.toString() ??
                                offer.discountValue?.toString() ??
                                "",
                          ),
                          onChanged: (value) {
                            if (offer.offerType == "percent") {
                              offer.discountPercent = int.tryParse(value);
                            } else {
                              offer.discountValue = value;
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 3,
                    title: "مدة العرض",
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Color(0x0D064E3B),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            border: Border.all(color: Color(0x33064E3B)),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.power,
                                size: 16,
                                color: Color(0xFF064E3B),
                              ),
                              SizedBox(width: 8),
                              AppText(
                                "تفعيل فوري",
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.42,
                                ),
                              ),
                              Spacer(),
                              AppSwitch(
                                onChanged: (value) {
                                  offer.isActive = value;
                                },
                                value: offer.isActive ?? false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24),
                        AppDatePicker(
                          onDateChanged: (expiredDate) {
                            offer.startsAt = expiredDate.toIso8601String();
                          },
                          title: "تاريخ البداية",
                        ),
                        SizedBox(height: 12),
                        AppDatePicker(
                          onDateChanged: (expiredDate) {
                            offer.endsAt = expiredDate.toIso8601String();
                          },
                          title: "تاريخ النهاية",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  StepDetails(
                    number: 4,
                    title: "ربط المنتجات",
                    leading: BlocBuilder<ProfileBloc, ProfileState>(
                      buildWhen: (previous, current) =>
                          previous.productsCountStatus !=
                          current.productsCountStatus,
                      builder: (context, state) {
                        return _ProductsCounterChip(
                          productsCounter: state.productsCount?.count ?? 0,
                        );
                      },
                    ),
                    child: Column(
                      children: [
                        _TextFieldWithoutTitle(onSearchChanged: (value) {}),
                        SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  FontAwesomeIcons.layerGroup,
                                  color: Color(0xFF374151),
                                  size: 14,
                                ),
                                SizedBox(width: 8),
                                AppText(
                                  "اختيار تصنيف كامل",
                                  style: TextStyle(
                                    color: Color(0xFF374151),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    height: 1.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        BlocConsumer<ProfileBloc, ProfileState>(
                          listenWhen: (previous, current) =>
                              previous.products != current.products,
                          listener: (context, state) {},
                          buildWhen: (previous, current) =>
                              previous.products != current.products,
                          builder: (context, state) {
                            return state.products!.builder(
                              loadingWidget: OfferLoading(),
                              emptyWidget: AppText.labelMedium(
                                'لا يوجد منتجات',
                                fontWeight: FontWeight.w400,
                              ),
                              successWidget: () {
                                return ListView.separated(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: EdgeInsetsDirectional.symmetric(
                                    horizontal: 0,
                                  ),
                                  itemBuilder: (context, index) {
                                    if (state.products!.length <= index) {
                                      log(index.toString());
                                      if (state.products!.length == index) {
                                        context.read<ProfileBloc>().add(
                                          GetProductsEvent(
                                            isReload: false,
                                            params: GetProductsParams(
                                              page: state.products!.pageNumber,
                                            ),
                                          ),
                                        );
                                      }
                                      return OfferLoading();
                                    }
                                    return OfferCheckbox(
                                      product: state.products!.list[index],
                                      onChanged: (value) {
                                        if (value) {
                                          selectedProducts.add(
                                            state.products!.list[index],
                                          );
                                        } else {
                                          selectedProducts.removeWhere(
                                            (element) =>
                                                element.id ==
                                                state.products!.list[index].id,
                                          );
                                        }
                                        setState(() {});
                                      },
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(height: 16),
                                  itemCount: state.products!.length <= 3
                                      ? state.products!.length
                                      : 3,
                                );
                              },
                              onTapRetry: () {
                                context.read<ProfileBloc>().add(
                                  GetProductsEvent(
                                    params: GetProductsParams(page: 1),
                                    isReload: true,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<ProfileBloc>(),
                                  child: ProductsScreen(
                                    selectedProducts: selectedProducts,
                                  ),
                                ),
                              ),
                            );

                            /// this [setState()] to get new selected products if exists
                            setState(() {});
                          },
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.all(
                                Radius.circular(16),
                              ),
                              border: Border.all(color: Color(0xFFE5E7EB)),
                            ),
                            child: AppText(
                              "عرض جميع المنتجات",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                                height: 1.333,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
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
                            AppText(
                              "المنتجات المحددة",
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                height: 1.42,
                              ),
                            ),
                            Spacer(),
                            _ProductsCounterChip(
                              productsCounter: selectedProducts.length,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        if (selectedProducts.isEmpty)
                          NoProductSelected()
                        else
                          ...List.generate(
                            selectedProducts.length,
                            (index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: index == selectedProducts.length - 1
                                    ? 0
                                    : 16.0,
                              ),
                              child: OfferCheckbox(
                                product: selectedProducts[index],
                                onChanged: (value) {
                                  if (!value) {
                                    selectedProducts.removeWhere(
                                      (element) =>
                                          element.id ==
                                          selectedProducts[index].id,
                                    );
                                    setState(() {});
                                  }
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listenWhen: (previous, current) =>
                        current.addOfferStatus != previous.addOfferStatus,
                    listener: (context, state) {
                      if (state.addOfferStatus == BlocStatus.failed) {
                        AppToast.showToast(
                          context: context,
                          message: state.errorMessage.toString(),
                          type: ToastificationType.error,
                        );
                      }
                      if (state.addOfferStatus == BlocStatus.success) {
                        AppToast.showToast(
                          context: context,
                          message: "تم إضافة العرض بنجاح",
                          type: ToastificationType.success,
                        );
                        context.read<ProfileBloc>().add(
                          GetOfferCodesEvent(
                            isReload: true,
                            params: GetOfferCodesParams(storeId: 1),
                          ),
                        );
                        context.pop();
                      }
                    },
                    buildWhen: (previous, current) =>
                        current.addOfferStatus != previous.addOfferStatus,
                    builder: (context, state) {
                      if (state.addOfferStatus == BlocStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              title: "حفظ وتفعيل",
                              onTap: () {
                                print(
                                  selectedProducts
                                      .map<int>((product) => product.id ?? -1)
                                      .toList(),
                                );
                                if (_validateAndSubmit()) {
                                  context.read<ProfileBloc>().add(
                                    AddOfferEvent(
                                      params: AddOfferParams(
                                        storeId: 1,
                                        offer: offer,
                                        selectedProducts: selectedProducts
                                            .map<int>(
                                              (product) => product.id ?? -1,
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  );
                                }
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
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _validateAndSubmit() {
    if (offer.name == null || offer.name!.trim().isEmpty) {
      AppToast.showToast(
        context: context,
        message: "يرجى إدخال اسم العرض",
        type: ToastificationType.error,
      );
      return false;
    }

    if (offer.name!.trim().length < 3) {
      AppToast.showToast(
        context: context,
        message: "اسم العرض قصير جداً",
        type: ToastificationType.error,
      );
      return false;
    }

    if (offer.offerType == "percent") {
      if (offer.discountPercent == null) {
        AppToast.showToast(
          context: context,
          message: "يرجى إدخال نسبة الخصم",
          type: ToastificationType.error,
        );
        return false;
      }

      if (offer.discountPercent! <= 0) {
        AppToast.showToast(
          context: context,
          message: "النسبة يجب أن تكون أكبر من 0",
          type: ToastificationType.error,
        );
        return false;
      }

      if (offer.discountPercent! > 100) {
        AppToast.showToast(
          context: context,
          message: "النسبة يجب أن تكون ≤ 100%",
          type: ToastificationType.error,
        );
        return false;
      }
    } else {
      if (offer.discountValue == null || offer.discountValue!.isEmpty) {
        AppToast.showToast(
          context: context,
          message: "يرجى إدخال قيمة الخصم",
          type: ToastificationType.error,
        );
        return false;
      }

      final value = double.tryParse(offer.discountValue!);
      if (value == null) {
        AppToast.showToast(
          context: context,
          message: "قيمة الخصم غير صالحة",
          type: ToastificationType.error,
        );
        return false;
      }

      if (value <= 0) {
        AppToast.showToast(
          context: context,
          message: "يجب أن تكون القيمة أكبر من 0",
          type: ToastificationType.error,
        );
        return false;
      }
    }

    if (offer.startsAt == null || offer.startsAt!.isEmpty) {
      AppToast.showToast(
        context: context,
        message: "يرجى اختيار تاريخ البداية",
        type: ToastificationType.error,
      );
      return false;
    }

    if (offer.endsAt == null || offer.endsAt!.isEmpty) {
      AppToast.showToast(
        context: context,
        message: "يرجى اختيار تاريخ النهاية",
        type: ToastificationType.error,
      );
      return false;
    }

    final start = DateTime.tryParse(offer.startsAt!);
    final end = DateTime.tryParse(offer.endsAt!);

    if (start == null || end == null) {
      AppToast.showToast(
        context: context,
        message: "تاريخ غير صالح",
        type: ToastificationType.error,
      );
      return false;
    }

    if (end.isBefore(start)) {
      AppToast.showToast(
        context: context,
        message: "تاريخ النهاية يجب أن يكون بعد البداية",
        type: ToastificationType.error,
      );
      return false;
    }

    if (selectedProducts.isEmpty) {
      AppToast.showToast(
        context: context,
        message: "يرجى اختيار منتج واحد على الأقل",
        type: ToastificationType.error,
      );
      return false;
    }

    return true;
  }
}

class NoProductSelected extends StatelessWidget {
  const NoProductSelected({super.key});

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(16)),
                boxShadow: [AppShadows.shadow],
              ),
              child: Icon(
                FontAwesomeIcons.boxOpen,
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
    );
  }
}

class OfferLoading extends StatelessWidget {
  const OfferLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: OfferCheckbox(
        onChanged: (value) {},
        product: GetProductsModelDataItem.fromJson({
          "id": 1,
          "storeId": 1,
          "store": {
            "id": 1,
            "ownerUserId": 5,
            "name": "Seller Supermarket",
            "slug": "seller-supermarket-ef2d127d",
            "description": "Supermarket owned by seller user for API testing.",
            "address": "789 Store St",
            "city": null,
            "neighborhood": null,
            "latitude": "31.97000000",
            "longitude": "35.94000000",
            "phone": "+962 6 555 0001",
            "email": "seller@supermarket.example.com",
            "cover": null,
            "logo": null,
            "averageRating": "4.00",
            "totalReviews": 0,
            "trustScore": 85,
            "warningCount": 0,
            "isActive": true,
            "isFeatured": false,
            "suspensionUntil": null,
            "createdAt": "2026-03-15 22:21:55",
            "updatedAt": "2026-03-15 22:21:55",
          },
          "categoryId": 1,
          "category": {
            "id": 1,
            "storeId": 1,
            "name": "الألبان",
            "slug": "dairy",
            "description": null,
            "sortOrder": 1,
            "imagePath": null,
            "isActive": true,
            "productsCount": 0,
            "createdAt": "2026-03-15 22:22:00",
            "updatedAt": "2026-03-15 22:22:00",
          },
          "masterProductId": 1,
          "name": "حليب كامل الدسم 1 لتر",
          "barcode": null,
          "sourceType": "manual",
          "description": null,
          "price": "6.00",
          "discountedPrice": null,
          "image": null,
          "imageUrl": null,
          "images": [],
          "imageUrls": [],
          "stockQuantity": 200,
          "lowStockThreshold": 10,
          "expiresAt": null,
          "isAvailable": true,
          "createdAt": "2026-03-15 22:22:00",
          "updatedAt": "2026-03-15 22:22:00",
        }),
      ),
    );
  }
}

class OfferCheckbox extends StatefulWidget {
  const OfferCheckbox({
    super.key,
    required this.product,
    required this.onChanged,
  });
  final GetProductsModelDataItem product;
  final void Function(bool value) onChanged;

  @override
  State<OfferCheckbox> createState() => _OfferCheckboxState();
}

class _OfferCheckboxState extends State<OfferCheckbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        spacing: 12,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: AppColors.white,
            ),
            child: Icon(
              FontAwesomeIcons.pizzaSlice,
              size: 18,
              color: Color(0xFF064E3B),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  widget.product.name.toString(),
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                AppText(
                  widget.product.category?.name ?? "null",
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.333,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: widget.product.isSelected,
            onChanged: (value) {
              if (value == null) return;
              widget.product.isSelected = value;
              widget.onChanged(widget.product.isSelected);
              setState(() {});
            },
            side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            ),
          ),
        ],
      ),
    );
  }
}

class DiscountChooser extends StatefulWidget {
  const DiscountChooser({super.key, required this.onChanged});
  final void Function(String discountType) onChanged;

  @override
  State<DiscountChooser> createState() => _DiscountChooserState();
}

class _DiscountChooserState extends State<DiscountChooser> {
  int selectedChip = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 8,
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (selectedChip == 0) return;
              selectedChip = 0;
              setState(() {});
              widget.onChanged("نسبة مئوية");
            },
            child: _DiscountChooserChip(
              isSelected: selectedChip == 0,
              label: "نسبة مئوية",
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              if (selectedChip == 1) return;
              selectedChip = 1;
              setState(() {});
              widget.onChanged("مبلغ ثابت");
            },
            child: _DiscountChooserChip(
              isSelected: selectedChip == 1,
              label: "مبلغ ثابت",
            ),
          ),
        ),
      ],
    );
  }
}

class _DiscountChooserChip extends StatelessWidget {
  const _DiscountChooserChip({required this.label, required this.isSelected});
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 9, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: isSelected ? null : AppColors.white,
        gradient: isSelected ? AppGradients.gradient : null,
        border: isSelected ? Border.all(color: Color(0xFFE5E7EB)) : null,
        boxShadow: [AppShadows.shadow],
      ),
      child: AppText(
        label,
        style: TextStyle(
          color: isSelected ? AppColors.white : Color(0xFF4B5563),
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          height: 1.42,
        ),
      ),
    );
  }
}

class _ProductsCounterChip extends StatelessWidget {
  const _ProductsCounterChip({required this.productsCounter});
  final int productsCounter;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Color(0x1A064E3B),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Text(
        "$productsCounter منتج",
        style: TextStyle(
          color: Color(0xFF064E3B),
          fontSize: 12,
          fontWeight: FontWeight.w700,
          height: 1.33,
        ),
      ),
    );
  }
}

class _TextFieldWithoutTitle extends StatelessWidget {
  const _TextFieldWithoutTitle({required this.onSearchChanged});
  final void Function(String value) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: TextStyle(
        color: Color(0xFF111287),
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      onChanged: onSearchChanged,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        filled: true,
        fillColor: Color(0xFFF9FAFB),
        hintText: "ابحث عن منتج...",
        hintStyle: TextStyle(
          color: Color(0xFF9CA3AF),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }
}
