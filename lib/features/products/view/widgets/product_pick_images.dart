import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';

class ProductPickMainImage extends StatefulWidget {
  const ProductPickMainImage({
    super.key,
    required this.onPickImage,
    required this.title,
    required this.icon,
    required this.isRequired,
    this.networkImageUrl,
    this.initialImagePath,
    this.emptyChild,
  });
  final void Function(String imagePath) onPickImage;
  final String title;
  final IconData icon;
  final bool isRequired;
  final String? networkImageUrl;
  final String? initialImagePath;
  final Widget? emptyChild;
  @override
  State<ProductPickMainImage> createState() => _ProductPickMainImageState();
}

class _ProductPickMainImageState extends State<ProductPickMainImage> {
  String? imagePath;

  @override
  void initState() {
    super.initState();
    imagePath = widget.initialImagePath;
  }

  @override
  void didUpdateWidget(covariant ProductPickMainImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialImagePath != widget.initialImagePath &&
        widget.initialImagePath != null &&
        widget.initialImagePath!.isNotEmpty) {
      imagePath = widget.initialImagePath;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        Text.rich(
          TextSpan(
            text: widget.title,
            children: [
              if (widget.isRequired)
                TextSpan(
                  text: "*",
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                  ),
                ),
            ],
          ),

          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        if (imagePath != null)
          InkWell(
            onTap: pickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: Image(
                width: context.width,
                height: 195,
                image: FileImage(File(imagePath!)),
                fit: BoxFit.cover,
              ),
            ),
          )
        else if (widget.networkImageUrl != null &&
            widget.networkImageUrl!.isNotEmpty)
          InkWell(
            onTap: pickImage,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              child: AppImage.network(
                widget.networkImageUrl!,
                width: context.width,
                height: 195,
                fit: BoxFit.cover,
              ),
            ),
          )
        else
          InkWell(
            onTap: pickImage,
            child: widget.emptyChild ??
                DottedBorder(
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
                            borderRadius: BorderRadius.all(Radius.circular(24)),
                            boxShadow: [AppShadows.shadow],
                          ),
                          child: Icon(
                            widget.icon,
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
      ],
    );
  }

  void pickImage() async {
    XFile? pickedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedImage == null) return;
    imagePath = pickedImage.path;
    setState(() {});
    widget.onPickImage(pickedImage.path);
  }
}

class ProductPickAdditionalImages extends StatefulWidget {
  const ProductPickAdditionalImages({
    super.key,
    required this.onPickImage,
    required this.numOfImages,
  });
  final void Function(List<String> imagesPath) onPickImage;
  final int numOfImages;

  @override
  State<ProductPickAdditionalImages> createState() =>
      _ProductPickAdditionalImagesState();
}

class _ProductPickAdditionalImagesState
    extends State<ProductPickAdditionalImages> {
  List<String> imagesPath = [];
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          "معرض صور إضافية",
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        SizedBox(height: 8),
        GridView.builder(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          itemCount: widget.numOfImages,
          itemBuilder: (_, index) {
            if (index < imagesPath.length) {
              return InkWell(
                onTap: () async {
                  XFile? pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage == null) return;
                  imagesPath[index] = pickedImage.path;
                  setState(() {});
                  widget.onPickImage(imagesPath);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                  child: Image(
                    image: FileImage(File(imagesPath[index])),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }
            if (index == imagesPath.length) {
              return InkWell(
                onTap: () async {
                  XFile? pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage == null) return;
                  imagesPath.add(pickedImage.path);
                  setState(() {});
                  widget.onPickImage(imagesPath);
                },
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: const [8, 8],
                    strokeWidth: 1,
                    color: const Color(0x1F2F2B3D),
                    radius: const Radius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0x1F2F2B3D),

                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      FontAwesomeIcons.plus,
                      size: 14,
                      color: Color(0xE52F2B3D),
                    ),
                  ),
                ),
              );
            }

            return DecoratedBox(
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            );
          },
        ),
      ],
    );
  }
}
