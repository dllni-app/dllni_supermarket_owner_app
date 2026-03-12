import 'package:common_package/common_package.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../widgets/order_details_app_bar.dart';

class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          OrderDetailsAppBar(title: "تفاصيل الطلب", productId: "122345678"),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: const [
                  _OrderStatusCard(),
                  SizedBox(height: 13),
                  _CustomerCard(),
                  SizedBox(height: 13),
                  _OrderDetailsCard(),
                  SizedBox(height: 13),
                  _BillCard(price: 76.00, discount: 8.50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  const _BillCard({required this.price, this.discount = 0});
  final num price;
  final num discount;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            "ملخص الدفع",
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.42,
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "تكلفة المنتجات",
                style: TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  height: 1.42,
                ),
              ),
              AppText(
                "${price.toStringAsFixed(2)} ل.س",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          if (discount > 0) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  "الخصم",
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 14,
                    height: 1.42,
                  ),
                ),
                AppText(
                  "- ${discount.toStringAsFixed(2)} ل.س",
                  style: TextStyle(
                    color: Color(0xFF16A34A),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
          Container(
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(
                  "الإجمالي",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
                AppText(
                  "${(price - discount).toStringAsFixed(2)} ل.س",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFFF9FAFB),
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: Color(0xFFDCFCE7),
                  child: Icon(
                    FontAwesomeIcons.moneyBill,
                    size: 14,
                    color: Color(0xFF16A34A),
                  ),
                ),
                SizedBox(width: 8),
                AppText(
                  "نقداً عند الاستلام",
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderDetailsCard extends StatelessWidget {
  const _OrderDetailsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText(
                "معلومات الزبون",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
              Spacer(),
              AppText(
                "4 منتجات",
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.333,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (_, index) => [
              _ProductDetails(
                imageUrl: AppImages.burgerImage,
                name: "كرتونة مياه 1.5 لتر",
                count: 2,
                price: 5000,
              ),
              _ProductDetails(
                imageUrl: AppImages.burgerImage,
                name: "كرتونة عصير ليمون",
                count: 1,
                price: 3000,
              ),
              _ProductDetails(
                imageUrl: AppImages.burgerImage,
                name: "كرتونة عصير برتقال",
                count: 1,
                price: 3000,
              ),
              _ProductDetails(
                isLast: true,
                imageUrl: AppImages.burgerImage,
                name: "كرتونة عصير رمان",
                count: 1,
                price: 3000,
              ),
            ][index],
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemCount: 4,
          ),
        ],
      ),
    );
  }
}

class _ProductDetails extends StatelessWidget {
  const _ProductDetails({
    this.isLast = false,
    required this.imageUrl,
    required this.name,
    required this.count,
    required this.price,
  });
  final bool isLast;
  final String imageUrl;
  final String name;
  final int count;
  final num price;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: !isLast
            ? Border(bottom: BorderSide(color: Color(0xFFF3F4F6)))
            : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppImage.asset(imageUrl, size: 64),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  name,
                  style: TextStyle(
                    color: Color(0xFF111827),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  margin: EdgeInsets.only(right: 4),
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                  child: AppText(
                    "x $count",
                    style: TextStyle(
                      color: Color(0xFF4B5563),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.333,
                    ),
                  ),
                ),
              ],
            ),
          ),
          AppText(
            "$price ل.س",
            style: TextStyle(
              color: Color(0xFF111827),
              fontSize: 14,
              fontWeight: FontWeight.w700,
              height: 1.42,
            ),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AppText(
                "معلومات الزبون",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                child: AppText(
                  "توصيل",
                  style: TextStyle(
                    color: Color(0xFF2563EB),
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    height: 1.333,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage(AppImages.avatar),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      "أحمد محمد العلي",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        height: 1.42,
                      ),
                    ),
                    SizedBox(height: 1.5),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          FontAwesomeIcons.phone,
                          size: 10,
                          color: Color(0XFF6B7280),
                        ),
                        SizedBox(width: 4),
                        AppText(
                          "09501234567",
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.333,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          FontAwesomeIcons.locationDot,
                          size: 10,
                          color: Color(0XFF6B7280),
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: AppText(
                            "حي المحافظة، شارع الملك فيصل، بناية 234، الطابق الثاني",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              width: context.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.phone,
                    size: 14,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 8),
                  AppText(
                    "اتصال",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      height: 1.42,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  const _OrderStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 6,
            spreadRadius: -4,
            color: Color(0x1A000000),
          ),
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 15,
            spreadRadius: -3,
            color: Color(0x1A000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(
                  FontAwesomeIcons.solidClock,
                  size: 18,
                  color: AppColors.white,
                ),
              ),
              SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    "الحالة الحالية",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      height: 1.333,
                    ),
                  ),
                  AppText(
                    "قيد التسليم",
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      height: 1.556,
                    ),
                  ),
                ],
              ),
              Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: AppText(
                  "12 دقيقة",
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    height: 1.333,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              SizedBox(width: 2),
              Expanded(
                child: _TimeOrderOverlay(
                  title: "وقت الاستلام",
                  subtitle: "03:45 م",
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(
                  title: "الوقت المتوقع",
                  subtitle: "25 دقيقة",
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(title: "منذ", subtitle: "12 دقيقة"),
              ),
              SizedBox(width: 2),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeOrderOverlay extends StatelessWidget {
  const _TimeOrderOverlay({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0x33FFFFFF),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            title,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 10,
              fontWeight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          AppText(
            subtitle,
            style: TextStyle(
              color: AppColors.white,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              height: 1.333,
            ),
          ),
        ],
      ),
    );
  }
}
