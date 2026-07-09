import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/profile/data/models/add_coupon_code_model.dart';
import 'package:dllni_supermarket_owner_app/features/profile/view/screens/create_new_employee_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/step_details.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../domain/usecases/add_coupon_code_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'create_offer_screen.dart';

@AutoRoutePage(path: '/coupons_management/new')
class CreateCouponScreen extends StatefulWidget {
  const CreateCouponScreen({super.key});

  @override
  State<CreateCouponScreen> createState() => _CreateCouponScreenState();
}

class _CreateCouponScreenState extends State<CreateCouponScreen> {
  String discountType = "%";
  AddCouponCodeModelData coupon = AddCouponCodeModelData(type: "percent");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AppSimpleAppBar(title: "إنشاء كوبون جديد"),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsetsDirectional.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                children: [
                  StepDetails(
                    number: 1,
                    title: 'كود الكوبون',
                    child: AppTextField(
                      title: "كود الكوبون",
                      hintText: "مثال: SUMMER2026",
                      onChanged: (value) {
                        coupon.code = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 2,
                    title: 'نوع الخصم',
                    child: Column(
                      children: [
                        DiscountChooser(
                          onChanged: (discountType) {
                            if (discountType == "نسبة مئوية") {
                              this.discountType = "%";
                              coupon.type = "percent";
                            } else {
                              this.discountType = "ل.س";
                              coupon.type = "value";
                            }
                            coupon.percent = null;
                            coupon.value = null;
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 8),
                        AppTextField(
                          title: "قيمة الخصم ($discountType)",
                          hintText: "0",
                          keyboardType: TextInputType.number,
                          controller: TextEditingController(
                            text:
                                coupon.percent?.toString() ??
                                coupon.value?.toString() ??
                                "",
                          ),
                          onChanged: (value) {
                            if (coupon.type == "percent") {
                              coupon.percent = int.tryParse(value);
                            } else {
                              coupon.value = value;
                            }
                          },
                          suffixIcon: Padding(
                            padding: const EdgeInsets.only(top: 15),
                            child: Text(
                              discountType,
                              style: TextStyle(
                                color: Color(0xFF9CA3AF),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 3,
                    title: 'الحد الأدنى لمبلغ الشراء',
                    child: AppTextField(
                      title: "الحد الأدنى لمبلغ الشراء",
                      hintText: "0",
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        coupon.minOrderAmount = value;
                      },
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          "ل.س",
                          style: TextStyle(
                            color: Color(0xFF9CA3AF),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 4,
                    title: 'الحد الأقصى لعدد الاستخدامات',
                    child: AppTextField(
                      title: "الحد الأقصى لعدد الاستخدامات",
                      hintText: "0",
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        coupon.maxDiscountAmount = value;
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  StepDetails(
                    number: 5,
                    title: 'مدة الكوبون',
                    leading: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: const Color(0xFFF3F4F6),
                      ),
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: AppText.labelLarge(
                        'اختياري',
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        AlertMessage(
                          message:
                              "تاريخ البداية والنهاية اختياريان، يمكنك تركهما فارغين",
                          icon: FontAwesomeIcons.circleInfo.data,
                          color: const Color(0xFF92400E),
                        ),
                        AppDatePicker(
                          title: "تاريخ البداية",
                          onDateChanged: (expiredDate) {
                            coupon.startsAt = expiredDate.toIso8601String();
                          },
                        ),
                        AppDatePicker(
                          title: "تاريخ النهاية",
                          onDateChanged: (expiredDate) {
                            coupon.endsAt = expiredDate.toIso8601String();
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listenWhen: (previous, current) =>
                        previous.addCouponCodeStatus !=
                        current.addCouponCodeStatus,
                    buildWhen: (previous, current) =>
                        previous.addCouponCodeStatus !=
                        current.addCouponCodeStatus,
                    listener: (context, state) {
                      if (state.addCouponCodeStatus == BlocStatus.failed) {
                        AppToast.showToast(
                          context: context,
                          message: state.errorMessage.toString(),
                          type: ToastificationType.error,
                        );
                      }
                      if (state.addCouponCodeStatus == BlocStatus.success) {
                        AppToast.showToast(
                          context: context,
                          message: "تم إضافة كوبون بنجاح",
                          type: ToastificationType.success,
                        );
                        context.pop();
                      }
                    },
                    builder: (context, state) {
                      if (state.addCouponCodeStatus == BlocStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              title: "حفظ وتفعيل",
                              onTap: () {
                                final validationMessage = validateCoupon();
                                if (validationMessage != null) {
                                  AppToast.showToast(
                                    context: context,
                                    message: validationMessage,
                                    type: ToastificationType.error,
                                  );
                                  return;
                                }
                                context.read<ProfileBloc>().add(
                                  AddCouponCodeEvent(
                                    params: AddCouponCodeParams(
                                      coupon: coupon,
                                      storeId: 1,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(width: 16),
                          AppOutlinedButton(
                            title: "إلغاء",
                            color: const Color(0xFFFF4C51),
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String? validateCoupon() {
    if (coupon.code == null || coupon.code!.trim().isEmpty) {
      return "يرجى إدخال كود الكوبون";
    }

    if (coupon.code!.length < 4) {
      return "كود الكوبون يجب أن يكون على الأقل 4 أحرف";
    }

    if (coupon.type == null) {
      return "يرجى اختيار نوع الخصم";
    }

    if (coupon.type == "percent") {
      if (coupon.percent == null) {
        return "يرجى إدخال نسبة الخصم";
      }

      if (coupon.percent! <= 0 || coupon.percent! > 100) {
        return "نسبة الخصم يجب أن تكون بين 1 و 100";
      }
    } else {
      if (coupon.value == null || coupon.value.toString().isEmpty) {
        return "يرجى إدخال قيمة الخصم";
      }

      final value = double.tryParse(coupon.value.toString());
      if (value == null || value <= 0) {
        return "قيمة الخصم غير صحيحة";
      }
    }

    if (coupon.minOrderAmount != null &&
        coupon.minOrderAmount.toString().isNotEmpty) {
      final min = double.tryParse(coupon.minOrderAmount.toString());

      if (min == null || min < 0) {
        return "الحد الأدنى للطلب غير صحيح";
      }
    }

    if (coupon.maxDiscountAmount != null &&
        coupon.maxDiscountAmount.toString().isNotEmpty) {
      final max = int.tryParse(coupon.maxDiscountAmount.toString());

      if (max == null || max <= 0) {
        return "عدد الاستخدامات يجب أن يكون أكبر من 0";
      }
    }

    if (coupon.startsAt != null && coupon.endsAt != null) {
      final start = DateTime.tryParse(coupon.startsAt!);
      final end = DateTime.tryParse(coupon.endsAt!);

      if (start != null && end != null) {
        if (end.isBefore(start)) {
          return "تاريخ النهاية يجب أن يكون بعد تاريخ البداية";
        }
      }
    }

    return null;
  }
}
