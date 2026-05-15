import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/get_new_orders_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/home/domain/usecases/reject_order_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../../core/themes/app_colors.dart';
import '../../../../../core/widgets/app_buttons.dart';
import '../../manager/bloc/home_bloc.dart';
import '../home_radio_group.dart';
import '../home_text_field_with_title.dart';

class RejectOrderBottomSheet extends StatefulWidget {
  const RejectOrderBottomSheet({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });
  final int orderId;
  final String orderNumber;

  @override
  State<RejectOrderBottomSheet> createState() => _RejectOrderBottomSheetState();
}

class _RejectOrderBottomSheetState extends State<RejectOrderBottomSheet> {
  int? selectedRadio;
  late TextEditingController moreInfoController;
  @override
  void initState() {
    moreInfoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    moreInfoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 50),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Column(
            // mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(
                          "رفض الطلب #${widget.orderNumber}",
                          style: TextStyle(
                            color: const Color(0xFF111827),
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 2),
                        AppText(
                          "يرجى توضيح سبب الرفض للعميل",
                          style: TextStyle(
                            color: const Color(0xFF6B7280),
                            fontSize: 14,
                            height: 1.42,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => context.pop(),
                      customBorder: CircleBorder(),
                      child: const CircleAvatar(
                        backgroundColor: Color(0xFFF9FAFB),
                        radius: 16,
                        child: Icon(
                          FontAwesomeIcons.x,
                          size: 14,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 24),
                      Row(
                        children: [
                          const Icon(
                            FontAwesomeIcons.listCheck,
                            size: 14,
                            color: Color(0xFF3B82F6),
                          ),
                          const SizedBox(width: 8),
                          AppText(
                            "سبب الرفض *",
                            style: const TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      HomeRadioGroup(
                        radios: [
                          HomeRadioItem(
                            title: "نفاد الكمية",
                            subtitle: "المنتجات غير متوفرة حالياً",
                          ),
                          HomeRadioItem(
                            title: "منتج مزيف",
                            subtitle: "لا يمكن استقبال طلبات لمنتجات مزيفة",
                          ),
                          HomeRadioItem(
                            title: "سبب آخر",
                            subtitle: "يرجى التوضيح في الحقل أدناه",
                          ),
                        ],
                        onChanged: (value) {
                          print(value);
                          if (selectedRadio == value) return;
                          selectedRadio = value;
                          setState(() {});
                        },
                      ),
                      SizedBox(height: 24),
                      HomeTextFieldWithTitle(
                        controller: moreInfoController,
                        title: "ملاحظات إضافية",
                        icon: FontAwesomeIcons.message,
                        hintText: "اكتب رسالة توضيحية للعميل...",
                        maxLines: 3,
                      ),
                      SizedBox(height: 24),
                      _WarningDialog(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            width: context.width,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                context.padding.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border(top: BorderSide(color: Color(0xFFF3F4F6))),
              ),
              child: Row(
                spacing: 12,
                children: [
                  Expanded(
                    child: AppButton(
                      title: "تأكيد الرفض",
                      onTap: selectedRadio != null
                          ? () {
                              if (selectedRadio == 2 &&
                                  moreInfoController.text.trim().isEmpty) {
                                AppToast.showToast(
                                  context: context,
                                  message: "يرجى توضيح سبب الرفض",
                                  type: ToastificationType.error,
                                );
                                return;
                              }
                              String reason, rejectType;
                              switch (selectedRadio) {
                                case 0:
                                  rejectType = "out_of_stock";
                                  reason = "المنتجات غير متوفرة حالياً";
                                  break;
                                case 1:
                                  rejectType = "fake_order";
                                  reason =
                                      "لا يمكن استقبال طلبات لمنتجات مزيفة";
                                  break;
                                case 2:
                                  rejectType = "other";
                                  reason = moreInfoController.text.trim();
                                  break;
                                default:
                                  AppToast.showToast(
                                    context: context,
                                    message: "خطأ غير متوقع",
                                    type: ToastificationType.error,
                                  );
                                  return;
                              }
                              context.read<HomeBloc>().add(
                                RejectOrderEvent(
                                  params: RejectOrderParams(
                                    rejectType: rejectType,
                                    reason: reason,
                                    orderId: widget.orderId,
                                  ),
                                ),
                              );
                            }
                          : null,
                    ),
                  ),
                  AppOutlinedButton(
                    title: "تراجع",
                    color: const Color(0xFFFF4C51),
                    onTap: () => context.pop(),
                  ),
                ],
              ),
            ),
          ),
          BlocConsumer<HomeBloc, HomeState>(
            buildWhen: (previous, current) =>
                previous.rejectOrderStatus != current.rejectOrderStatus,
            listenWhen: (previous, current) =>
                previous.rejectOrderStatus != current.rejectOrderStatus,
            listener: (context, state) {
              if (state.rejectOrderStatus == BlocStatus.failed) {
                print(state.errorMessage);
                AppToast.showToast(
                  context: context,
                  message: state.errorMessage ?? "Unknown Error",
                  type: ToastificationType.error,
                );
              } else if (state.rejectOrderStatus == BlocStatus.success) {
                AppToast.showToast(
                  context: context,
                  message: "تم رفض الطلب بنجاح",
                  type: ToastificationType.success,
                );
                context.read<HomeBloc>().add(
                  GetNewOrdersEvent(
                    isReload: true,
                    params: GetNewOrdersParams(),
                  ),
                );
                context.pop();
              }
            },
            builder: (context, state) => switch (state.rejectOrderStatus) {
              BlocStatus.loading => Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0x4D000000),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
              ),
              _ => SizedBox(),
            },
          ),
        ],
      ),
    );
  }
}

class _WarningDialog extends StatelessWidget {
  const _WarningDialog();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x14FF9F43),
        border: Border.all(color: const Color(0x29FF9F43)),
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(
              FontAwesomeIcons.circleInfo,
              size: 16,
              color: const Color(0xFFFF9F43),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AppText(
                  "نظام الخصم التلقائي",
                  style: TextStyle(
                    color: const Color(0xFF9A3412),
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    height: 1.42,
                  ),
                ),
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AppText(
                    " • سيتم إشعار العميل فوراً بإلغاء الطلب.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: const Color(0xFFC2410C),
                      fontSize: 12,
                      height: 1.333,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: AppText(
                    " • قد يؤثر تكرار الرفض على نقاط الثقة.",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: const Color(0xFFC2410C),
                      fontSize: 12,
                      height: 1.333,
                    ),
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
