import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AppImageField extends StatefulWidget {
  const AppImageField({
    super.key,
    required this.onPickImage,
    required this.title,
    this.initialNetworkImage,
  });
  final void Function(String imagePath) onPickImage;
  final String title;
  final String? initialNetworkImage;
  @override
  State<AppImageField> createState() => _AppImageFieldState();
}

class _AppImageFieldState extends State<AppImageField> {
  String? imagePath;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        AppText(
          widget.title,
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        Row(
          spacing: 8,
          children: [
            if (imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(16)),
                child: Image(
                  width: 99,
                  height: 99,
                  image: FileImage(File(imagePath!)),
                  fit: BoxFit.cover,
                ),
              )
            else if (widget.initialNetworkImage != null)
              AppImage.network(
                widget.initialNetworkImage!,
                size: 99,
                fit: BoxFit.cover,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
            Expanded(
              child: InkWell(
                onTap: () async {
                  XFile? pickedImage = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (pickedImage == null) return;
                  imagePath = pickedImage.path;
                  setState(() {});
                  widget.onPickImage(pickedImage.path);
                },
                child: DottedBorder(
                  options: RoundedRectDottedBorderOptions(
                    dashPattern: const [8, 8],
                    strokeWidth: 2,
                    color: const Color(0x1F2F2B3D),
                    radius: const Radius.circular(16),
                  ),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 8,
                      children: [
                        Icon(
                          FontAwesomeIcons.cloudArrowUp.data,
                          size: 18,
                          color: const Color(0xFF064E3B),
                        ),
                        AppText(
                          "اضغط لرفع صورة",
                          style: TextStyle(
                            color: const Color(0xE52F2B3D),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.333,
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
      ],
    );
  }
}
