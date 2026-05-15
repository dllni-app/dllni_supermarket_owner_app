import 'dart:ui';

import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../data/models/get_products_model.dart';
import '../../domain/usecases/update_product_use_case.dart';
import '../manager/bloc/products_bloc.dart';

class ProductCard extends StatefulWidget {
  final GetProductsModelDataItem product;
  final Future<void> Function(GetProductsModelDataItem product)? onEdit;
  final void Function(GetProductsModelDataItem product)? onDelete;

  const ProductCard({
    super.key,
    required this.product,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _AvailabilityChip extends StatelessWidget {
  final bool isAvailable;
  const _AvailabilityChip({required this.isAvailable});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isAvailable ? Color(0x2928C76F) : Color(0x662F2B3D),
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Text(
        isAvailable ? "متوفر" : "غير متوفر",
        style: TextStyle(
          color: isAvailable ? Color(0xFF24B364) : Color(0xE52F2B3D),
          fontSize: 10,
          fontWeight: FontWeight.w700,
          height: 1.5,
        ),
      ),
    );
  }
}

class _ProductCardState extends State<ProductCard> {
  late bool enabled;

  @override
  Widget build(BuildContext context) {
    final bool unavailable = widget.product.stockQuantity == 0;
    final bool limited =
        (widget.product.stockQuantity ?? 0) <=
            (widget.product.lowStockThreshold ?? 0) &&
        widget.product.stockQuantity != 0;
    final bool available = !unavailable && !limited;
    return BlocProvider(
      create: (context) => getIt<ProductsBloc>(),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Opacity(
            opacity: unavailable ? .6 : 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.all(Radius.circular(24)),
                border: Border.all(
                  color: limited ? Color(0xFFFF4C51) : Color(0xFFF9FAFB),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset.zero,
                    blurRadius: 15,
                    color: Color(0x08000000),
                  ),
                ],
              ),
              child: SizedBox(
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadiusGeometry.all(
                        Radius.circular(unavailable ? 24 : 12),
                      ),
                      child: Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          widget.product.imageUrls?.isEmpty == true
                              ? AppImage.asset(AppImages.image1, size: 96)
                              : AppImage.network(
                                  widget.product.imageUrls?[0] ?? "",
                                  size: 96,
                                  fit: BoxFit.cover,
                                ),
                          if (unavailable)
                            Container(
                              height: 96,
                              width: 96,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0x66000000),
                              ),
                              child: AppImage.asset(AppSvgs.cross, size: 24),
                            ),
                          if (limited)
                            ClipRRect(
                              borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(12),
                              ),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                child: Container(
                                  width: 96,
                                  padding: EdgeInsets.symmetric(vertical: 2),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xB2FF4C51),
                                  ),
                                  child: Text(
                                    "باقي ${widget.product.stockQuantity} فقط",
                                    style: TextStyle(
                                      color: AppColors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      height: 1.5,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: SizedBox(
                        height: 105,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: AppText(
                                      widget.product.name ?? "",
                                      // scrollText: true,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        height: 1.25,
                                        color: Color(0xFF202020),
                                      ),
                                    ),
                                  ),
                                  if (widget.onEdit != null ||
                                      widget.onDelete != null)
                                    Theme(
                                      data: Theme.of(context).copyWith(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                      ),
                                      child: PopupMenuButton<String>(
                                        icon: Icon(
                                          Icons.more_vert,
                                          size: 20,
                                          color: Colors.grey,
                                        ),
                                        onSelected: (value) async {
                                          if (value == 'edit' &&
                                              widget.onEdit != null) {
                                            await widget.onEdit!(
                                              widget.product,
                                            );
                                          } else if (value == 'delete' &&
                                              widget.onDelete != null) {
                                            widget.onDelete!(widget.product);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          if (widget.onEdit != null)
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text(
                                                "تعديل",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          if (widget.onDelete != null)
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text(
                                                "حذف",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Color(0xFFEF4444),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    )
                                  else
                                    Icon(
                                      Icons.more_vert,
                                      size: 16,
                                      color: Colors.grey,
                                    ),
                                ],
                              ),
                              if (!limited)
                                _AvailabilityChip(isAvailable: available),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      AppText(
                                        widget.product.price ?? "",
                                        style: TextStyle(
                                          color: Color(0xFFFF660E),
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700,
                                          height: 1.555,
                                        ),
                                      ),
                                      SizedBox(width: 4),
                                      AppText(
                                        "ل.س",
                                        style: TextStyle(
                                          color: Color(0xFF9CA3AF),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 1.333,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Builder(
                                    builder: (context) {
                                      return AppSwitch(
                                        value: enabled,
                                        onChanged: (value) {
                                          enabled = !enabled;
                                          context.read<ProductsBloc>().add(
                                            UpdateProductEvent(
                                              params:
                                                  UpdateProductParams.toggle(
                                                    productId:
                                                        widget.product.id!,
                                                    isActive: enabled,
                                                  ),
                                            ),
                                          );
                                          setState(() {});
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          BlocConsumer<ProductsBloc, ProductsState>(
            listener: (context, state) {
              if (state.productStatus == BlocStatus.failed) {
                enabled = !enabled;
                setState(() {});
                AppToast.showToast(
                  context: context,
                  message: state.errorMessage.toString(),
                  type: ToastificationType.error,
                );
              }
            },
            buildWhen: (previous, current) =>
                previous.productStatus != current.productStatus,
            builder: (context, state) {
              if (state.productStatus == BlocStatus.loading) {
                return Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(24)),
                      color: Colors.grey.withAlpha(75),
                    ),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              return SizedBox();
            },
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    enabled = widget.product.isAvailable ?? true;
  }
}
