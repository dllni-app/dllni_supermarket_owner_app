import 'dart:convert';
import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImage extends StatefulWidget {
  const PickImage({
    super.key,
    required this.title,
    this.height,
    this.direction = Axis.horizontal,
    required this.isRequired,
    this.imageBytes,
    required this.onChanged,
  });
  final String title;
  final double? height;
  final bool isRequired;
  final String? imageBytes;
  final Axis direction;
  final void Function(String imagePath) onChanged;

  @override
  State<PickImage> createState() => _PickImageState();
}

class _PickImageState extends State<PickImage> {
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: [
            Row(
              children: [
                AppText.bodyMedium(widget.title, fontWeight: FontWeight.w500),
                if (widget.isRequired)
                  AppText.bodyMedium(
                    '*',
                    fontWeight: FontWeight.w500,
                    color: context.error,
                  ),
              ],
            ),
            SizedBox(height: 8),
            if (widget.direction == Axis.horizontal)
              SizedBox(
                height: widget.height ?? 150,
                child: Row(
                  spacing: 12,
                  children: [
                    if (widget.imageBytes != null || imagePath != null)
                      Container(
                        width: (widget.height ?? 150),
                        height: (widget.height ?? 150),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          errorBuilder: (context, error, stackTrace) =>
                              Text("صورة غير صالحة"),
                          image: imagePath != null
                              ? FileImage(File(imagePath!))
                              : MemoryImage(base64Decode(widget.imageBytes!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          XFile? pickedImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedImage == null) return;
                          imagePath = pickedImage.path;
                          setState(() {});
                          widget.onChanged(pickedImage.path);
                        },
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(24),
                            strokeWidth: 2,
                            dashPattern: [8, 4],
                            color: context.surface,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffF9FAFB),
                            ),
                            width: context.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  color: Color(0xff064E3B),
                                ),
                                SizedBox(height: 8),
                                AppText.labelLarge(
                                  'اضغط لرفع صورة',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2F2B3D),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            else
              SizedBox(
                height: widget.height ?? 200,
                child: Column(
                  spacing: 8,
                  children: [
                    if (widget.imageBytes != null || imagePath != null)
                      Container(
                        width: context.width,
                        height: (widget.height ?? 200) * .6,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image(
                          image: imagePath != null
                              ? FileImage(File(imagePath!))
                              : MemoryImage(base64Decode(widget.imageBytes!)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          XFile? pickedImage = await ImagePicker().pickImage(
                            source: ImageSource.gallery,
                          );
                          if (pickedImage == null) return;
                          imagePath = pickedImage.path;
                          setState(() {});
                          widget.onChanged(pickedImage.path);
                        },
                        child: DottedBorder(
                          options: RoundedRectDottedBorderOptions(
                            radius: Radius.circular(24),
                            strokeWidth: 2,
                            dashPattern: [8, 4],
                            color: context.surface,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              color: Color(0xffF9FAFB),
                            ),
                            width: context.width,
                            height: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload,
                                  color: Color(0xff064E3B),
                                ),
                                SizedBox(width: 8),
                                AppText.labelLarge(
                                  'اضغط لرفع صورة',
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff2F2B3D),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.info_rounded, color: Color(0xff064E3B), size: 20),
            SizedBox(width: 8),
            AppText.labelLarge(
              'الحد الأقصى: 5 ميجابايت',
              fontWeight: FontWeight.w500,
              color: Color(0xff6B7280),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.info_rounded, color: Color(0xff064E3B), size: 20),
            SizedBox(width: 8),
            AppText.labelLarge(
              'الصيغ المدعومة: JPG, PNG',
              fontWeight: FontWeight.w500,
              color: Color(0xff6B7280),
            ),
          ],
        ),
      ],
    );
  }
}
