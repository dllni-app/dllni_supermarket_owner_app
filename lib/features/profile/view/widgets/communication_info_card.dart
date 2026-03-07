import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_images.dart';

class CommunicationInfoCard extends StatelessWidget {
  const CommunicationInfoCard({super.key});

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
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: context.primaryContainer,
                radius: 16,
                child: AppText.labelLarge(
                  '3',
                  color: context.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 12),
              AppText.titleLarge(
                'معلومات التواصل',
                color: context.primaryContainer,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          SizedBox(height: 24),
          Row(
            children: [
              AppText.bodyMedium(
                'رقم الهاتف الأساسي',
                fontWeight: FontWeight.w500,
              ),
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
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.phone, color: Color(0xff064E3B)),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bodyMedium('رقم الواتساب', fontWeight: FontWeight.w500),
              AppText.labelLarge(
                '(اختياري)',
                fontWeight: FontWeight.w400,
                color: Color(0xff2F2B3D).withAlpha(175),
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
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Transform.scale(
                scale: .5,
                child: AppImage.asset(AppImages.whatsapp),
              ),
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
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.info_rounded, color: Color(0xff064E3B), size: 15),
              SizedBox(width: 8),
              Expanded(
                child: AppText.labelLarge(
                  'يمكن للعملاء التواصل معك مباشرة عبر واتساب',
                  fontWeight: FontWeight.w500,
                  color: Color(0xff6B7280),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText.bodyMedium(
                'حسابات التواصل الاجتماعي',
                fontWeight: FontWeight.w500,
              ),
              AppText.labelLarge(
                '(اختياري)',
                fontWeight: FontWeight.w400,
                color: Color(0xff2F2B3D).withAlpha(175),
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
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: 'اسم المستخدم في انستغرام',
              hintStyle: TextStyle(
                color: Color(0xff9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              filled: true,
              prefixIcon: Transform.scale(
                scale: .3,
                child: AppImage.asset(AppImages.instagram),
              ),
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
          SizedBox(height: 8),
          TextFormField(
            style: TextStyle(
              color: Color(0xff2F2B3D),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              filled: true,
              hintText: 'اسم الصفحة في فيسبوك',
              hintStyle: TextStyle(
                color: Color(0xff9CA3AF),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              prefixIcon: Transform.scale(
                scale: .3,
                child: AppImage.asset(AppImages.facebook),
              ),
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
