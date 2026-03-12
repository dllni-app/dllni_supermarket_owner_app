import 'package:common_package/common_package.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class BasicInfoCard extends StatelessWidget {
  const BasicInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: context.onPrimaryContainer,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(6),
            offset: Offset(0, 4),
            blurRadius: 20,
            spreadRadius: -2,
          ),
        ],
      ),
      padding: EdgeInsetsDirectional.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.primaryContainer,
                radius: 16,
                child: AppText.labelLarge(
                  '1',
                  color: context.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              AppText.titleLarge(
                'الهوية الأساسية',
                color: context.primaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              AppText.bodyMedium('شعار المتجر', fontWeight: FontWeight.w500),
              AppText.bodyMedium(
                '*',
                fontWeight: FontWeight.w500,
                color: context.error,
              ),
            ],
          ),
          SizedBox(height: 8),
          SizedBox(
            height: 112,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Color(0xffC4C4C4),
                  ),
                  width: 112,
                  height: 112,
                ),
                SizedBox(width: 12),
                Expanded(
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
                          Icon(Icons.cloud_upload, color: Color(0xff064E3B)),
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
              ],
            ),
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
          SizedBox(height: 20),
          Row(
            children: [
              AppText.bodyMedium('غلاف المتجر', fontWeight: FontWeight.w500),
              AppText.bodyMedium(
                '*',
                fontWeight: FontWeight.w500,
                color: context.error,
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color(0xffC4C4C4),
            ),
            width: context.width,
            height: 112,
          ),
          SizedBox(height: 8),
          DottedBorder(
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
              padding: EdgeInsetsDirectional.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, color: Color(0xff064E3B)),
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
          SizedBox(height: 20),
          Row(
            children: [
              AppText.bodyMedium('اسم المتجر', fontWeight: FontWeight.w500),
              AppText.bodyMedium(
                '*',
                fontWeight: FontWeight.w500,
                color: context.error,
              ),
            ],
          ),
          SizedBox(height: 8),
          TextFormField(
            style: TextStyle(
              color: Color(0xff2F2B3D),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
            ),
          ),
          SizedBox(height: 20),
          AppText.bodyMedium('وصف المتجر', fontWeight: FontWeight.w500),
          SizedBox(height: 8),
          TextFormField(
            maxLines: 5,
            style: TextStyle(
              color: Color(0xff2F2B3D),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffF9FAFB),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Color(0xffE5E7EB), width: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
