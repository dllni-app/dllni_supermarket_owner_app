import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_images.dart';
import '../../data/models/get_order_details_model.dart';
import '../../domain/usecases/get_order_details_use_case.dart';
import '../manager/bloc/orders_bloc.dart';
import '../widgets/order_details_app_bar.dart';

class OrderDetailsLoading extends StatelessWidget {
  const OrderDetailsLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        children: [
          _OrderStatusCard(
            minutes: 12,
            createdAt: "2021",
            expectedTime: "25 دقيقة",
          ),
          SizedBox(height: 13),
          _CustomerCard(customer: GetOrderDetailsModelDataCustomer()),
          SizedBox(height: 13),
          _OrderDetailsCard(
            orderItems: List.generate(
              2,
              (_) => GetOrderDetailsModelDataItemsItem.fromJson({
                "id": 29,
                "orderId": 10,
                "productId": 3,
                "quantity": 2,
                "unitPrice": "0.00",
                "totalPrice": "0.00",
                "productName": "دجاج طازج كامل",
                "createdAt": "2026-03-13 11:51:36",
                "updatedAt": "2026-03-13 11:51:36",
              }),
            ),
          ),
          SizedBox(height: 13),
          _BillCard(
            price: "76.00",
            discount: "8.50",
            fees: "8.50",
            totalPrice: "10.35",
          ),
        ],
      ),
    );
  }
}

@AutoRoutePage(path: "/orders/order_details")
class OrderDetailsScreen extends StatelessWidget {
  final int orderId;
  const OrderDetailsScreen({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OrdersBloc>()
        ..add(
          GetOrderDetailsEvent(params: GetOrderDetailsParams(orderId: orderId)),
        ),
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            OrderDetailsAppBar(title: "تفاصيل الطلب", productId: "122345678"),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: BlocConsumer<OrdersBloc, OrdersState>(
                  listener: (context, state) {},
                  buildWhen: (previous, current) =>
                      previous.orderDetailsStatus != current.orderDetailsStatus,
                  builder: (context, state) {
                    if (state.orderDetailsStatus == BlocStatus.loading) {
                      return OrderDetailsLoading();
                    } else if (state.orderDetailsStatus == BlocStatus.failed) {
                      return SizedBox(
                        width: context.width,
                        height: 250,
                        child: Center(
                          child: FailureWidget(
                            message: state.errorMessage.toString(),
                            onRetry: () {
                              context.read<OrdersBloc>().add(
                                GetOrderDetailsEvent(
                                  params: GetOrderDetailsParams(
                                    orderId: orderId,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    } else if (state.orderDetailsStatus == BlocStatus.success) {
                      DateTime dateTime = DateTime.parse(
                        state.orderDetails!.data!.createdAt!,
                      );
                      String formattedTime = DateFormat.jm('ar_DZ')
                          .format(dateTime)
                          .replaceAll('مساءً', 'م')
                          .replaceAll('صباحاً', 'ص');
                      return Column(
                        children: [
                          _OrderStatusCard(
                            minutes:
                                state
                                    .orderDetails!
                                    .data!
                                    .orderDetails
                                    ?.statusElapsedMinutes ??
                                0,
                            createdAt: formattedTime,
                            expectedTime:
                                state
                                    .orderDetails!
                                    .data!
                                    .orderDetails
                                    ?.expectedDeliveryTime ??
                                'غير محدد',
                          ),
                          SizedBox(height: 13),
                          _CustomerCard(
                            customer: state.orderDetails!.data!.customer!,
                          ),
                          SizedBox(height: 13),
                          _OrderDetailsCard(
                            orderItems: List.generate(
                              state.orderDetails?.data?.items?.length ?? 0,
                              (index) =>
                                  state.orderDetails!.data!.items![index],
                            ),
                          ),
                          SizedBox(height: 13),
                          _BillCard(
                            price: state.orderDetails!.data!.subtotal
                                .toString(),
                            discount: state.orderDetails!.data!.discountAmount
                                .toString(),
                            fees: state.orderDetails!.data!.serviceFee
                                .toString(),
                            totalPrice: state.orderDetails!.data!.totalAmount
                                .toString(),
                          ),
                        ],
                      );
                    }
                    return SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BillCard extends StatelessWidget {
  final String price;
  final String discount;
  final String fees;
  final String totalPrice;
  const _BillCard({
    required this.price,
    required this.discount,
    required this.fees,
    required this.totalPrice,
  });
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
          SizedBox(height: 10),
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
                "- $discount ل.س",
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppText(
                "تكلفة الخدمة",
                style: TextStyle(
                  color: Color(0xFF4B5563),
                  fontSize: 14,
                  height: 1.42,
                ),
              ),
              AppText(
                "+ $fees ل.س",
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),

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
                  "$totalPrice ل.س",
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

class _CustomerCard extends StatelessWidget {
  final GetOrderDetailsModelDataCustomer customer;
  const _CustomerCard({required this.customer});

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
                      customer.name.toString(), //"أحمد محمد العلي",
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
                          customer.phone.toString().formatAsPhoneNumber, //"09501234567",
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
            onTap: () async {
              print(customer.phone);
              if (await canLaunchUrlString("tel:${customer.phone}") &&
                  context.mounted) {

                launchUrlString("tel:${customer.phone}");
                Clipboard.setData(ClipboardData(text: customer.phone));
                return;
              }
              AppToast.showToast(
                context: context,
                message: "رقم الهاتف غير صالح",
                type: ToastificationType.warning,
              );
            },
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

class _OrderDetailsCard extends StatelessWidget {
  final List<GetOrderDetailsModelDataItemsItem> orderItems;
  const _OrderDetailsCard({required this.orderItems});

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
                "تفاصيل الطلب",
                style: TextStyle(
                  color: Color(0xFF111827),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  height: 1.42,
                ),
              ),
              Spacer(),
              AppText(
                "${orderItems.length} منتجات",
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
            itemBuilder: (_, index) => orderItems
                .map(
                  (orderItem) => _ProductDetails(
                    imageUrl: AppImages.burgerImage,
                    name: orderItem.productName.toString(),
                    count: orderItem.quantity ?? 0,
                    price: orderItem.totalPrice.toString(),
                    isLast: index == orderItems.length - 1,
                  ),
                )
                .toList()[index],
            // [
            //   _ProductDetails(
            //     imageUrl: AppImages.burgerImage,
            //     name: "كرتونة مياه 1.5 لتر",
            //     count: 2,
            //     price: 5000,
            //   ),
            //   _ProductDetails(
            //     imageUrl: AppImages.burgerImage,
            //     name: "كرتونة عصير ليمون",
            //     count: 1,
            //     price: 3000,
            //   ),
            //   _ProductDetails(
            //     imageUrl: AppImages.burgerImage,
            //     name: "كرتونة عصير برتقال",
            //     count: 1,
            //     price: 3000,
            //   ),
            //   _ProductDetails(
            //     isLast: true,
            //     imageUrl: AppImages.burgerImage,
            //     name: "كرتونة عصير رمان",
            //     count: 1,
            //     price: 3000,
            //   ),
            // ][index],
            separatorBuilder: (_, _) => SizedBox(height: 12),
            itemCount: orderItems.length,
          ),
        ],
      ),
    );
  }
}

class _OrderStatusCard extends StatelessWidget {
  final int minutes;
  final String createdAt;
  final String expectedTime;
  const _OrderStatusCard({
    required this.minutes,
    required this.createdAt,
    required this.expectedTime,
  });

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
                    "قيد التحضير",
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
                  formatDurationArabic(minutes),
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
                  subtitle: createdAt,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(
                  title: "الوقت المتوقع",
                  subtitle: expectedTime,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: _TimeOrderOverlay(
                  title: "منذ",
                  subtitle: formatDurationArabic(minutes),
                ),
              ),
              SizedBox(width: 2),
            ],
          ),
        ],
      ),
    );
  }

  String formatDurationArabic(int minutes) {
    if (minutes < 0) return '';

    if (minutes < 60) {
      return '$minutes دقيقة';
    } else if (minutes < 1440) {
      final hours = (minutes / 60).floor();
      return '$hours ساعة';
    } else {
      final days = (minutes / 1440).floor();
      return '$days يوم';
    }
  }
}

class _ProductDetails extends StatelessWidget {
  final bool isLast;
  final String imageUrl;
  final String name;
  final int count;
  final String price;
  const _ProductDetails({
    this.isLast = false,
    required this.imageUrl,
    required this.name,
    required this.count,
    required this.price,
  });
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

class _TimeOrderOverlay extends StatelessWidget {
  final String title;
  final String subtitle;
  const _TimeOrderOverlay({required this.title, required this.subtitle});
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
