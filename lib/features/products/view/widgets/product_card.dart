import 'dart:ui';

import 'package:common_package/widgets/app_image.dart';
import 'package:common_package/widgets/app_text.dart';
import 'package:flutter/material.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../data/models/get_products_model.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});
  final GetProductsModelDataItem product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool enabled = true;
  @override
  Widget build(BuildContext context) {
    final bool unavailable = widget.product.stockQuantity == 0;
    final bool limited =
        (widget.product.stockQuantity ?? 0) <=
            (widget.product.lowStockThreshold ?? 0) &&
        widget.product.stockQuantity != 0;
    final bool available = !unavailable && !limited;

    return Opacity(
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
                    AppImage.asset(AppImages.image1, size: 96),
                    if (unavailable)
                      Container(
                        height: 96,
                        width: 96,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Color(0x66000000)),
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
                            decoration: BoxDecoration(color: Color(0xB2FF4C51)),
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
                  height: 96,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AppText(
                              widget.product.name ?? "",
                              scrollText: true,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                height: 1.25,
                                color: Color(0xFF202020),
                              ),
                            ),
                            Icon(Icons.more_vert, size: 16, color: Colors.grey),
                          ],
                        ),
                        AvailabilityChip(isAvailable: available),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                            AppSwitch(
                              value: enabled,
                              onChanged: (value) {
                                setState(() {
                                  enabled = !enabled;
                                });
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
    );
  }
}

class AvailabilityChip extends StatelessWidget {
  const AvailabilityChip({super.key, required this.isAvailable});
  final bool isAvailable;
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
