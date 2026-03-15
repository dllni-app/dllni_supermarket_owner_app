import 'dart:convert';
import 'dart:io';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_store_profile_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/update_store_data_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/step_details.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../manager/bloc/profile_bloc.dart';
import '../widgets/map_view.dart';
import '../widgets/pick_image.dart';

@AutoRoutePage(path: "/profile")
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileParams params = ProfileParams();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ProfileBloc>()
        ..add(GetStoreProfileEvent(params: GetStoreProfileParams(storeId: 1))),
      child: Scaffold(
        body: BlocConsumer<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) =>
              previous.storeProfileStatus != current.storeProfileStatus,
          listener: (context, state) {
            if (state.storeProfileStatus == BlocStatus.success) {
              params.logo64Based = state.storeProfile?.data?.logo;
              params.cover64Based = state.storeProfile?.data?.cover;
              params.storeName = state.storeProfile?.data?.name;
              params.description = state.storeProfile?.data?.description;
              params.city = state.storeProfile?.data?.city;
              params.town = state.storeProfile?.data?.neighborhood;
              params.address = state.storeProfile?.data?.address;
              params.lat = double.tryParse(
                state.storeProfile?.data?.latitude ?? "",
              );
              params.long = double.tryParse(
                state.storeProfile?.data?.longitude ?? "",
              );
              params.phone = state.storeProfile?.data?.phone;
            }
          },
          builder: (context, state) {
            if (state.storeProfileStatus == BlocStatus.loading) {
              return Center(child: CircularProgressIndicator());
            } else if (state.storeProfileStatus == BlocStatus.failed) {
              return Center(
                child: FailureWidget(
                  message: state.errorMessage.toString(),
                  onRetry: () {
                    context.read<ProfileBloc>().add(
                      GetStoreProfileEvent(
                        params: GetStoreProfileParams(storeId: 1),
                      ),
                    );
                  },
                ),
              );
            } else if (state.storeProfileStatus == BlocStatus.success) {
              return Column(
                children: [
                  AppSimpleAppBar(title: "معلومات السوبر ماركت"),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsetsDirectional.symmetric(horizontal: 19),
                      child: Column(
                        children: [
                          SizedBox(height: 16),
                          StepDetails(
                            number: 1,
                            title: "الهوية الأساسية",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PickImage(
                                  title: 'شعار السوبر ماركت',
                                  isRequired: true,
                                  imageBytes: params.logo64Based,
                                  height: 112,
                                  onChanged: (imagePath) {
                                    final bytes = File(
                                      imagePath,
                                    ).readAsBytesSync();
                                    params.logo64Based = base64Encode(bytes);
                                  },
                                ),
                                SizedBox(height: 20),
                                PickImage(
                                  title: "غلاف السوبر ماركت",
                                  isRequired: true,
                                  imageBytes: params.cover64Based,
                                  direction: Axis.vertical,
                                  onChanged: (imagePath) {
                                    final bytes = File(
                                      imagePath,
                                    ).readAsBytesSync();
                                    params.cover64Based = base64Encode(bytes);
                                  },
                                ),
                                SizedBox(height: 20),
                                AppTextField(
                                  isRequired: true,
                                  title: "اسم السوبر ماركت",
                                  onChanged: (value) {
                                    params.storeName = value;
                                  },
                                  controller: TextEditingController(
                                    text: params.storeName,
                                  ),
                                ),
                                SizedBox(height: 20),
                                AppTextField(
                                  maxLines: 4,
                                  title: "وصف السوبر ماركت",
                                  onChanged: (value) {
                                    params.description = value;
                                  },
                                  controller: TextEditingController(
                                    text: params.description,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          // LocationInfoCard(),
                          StepDetails(
                            number: 2,
                            title: "العنوان والموقع",
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        title: "المدينة",
                                        isRequired: true,
                                        onChanged: (value) {
                                          params.city = value;
                                        },
                                        controller: TextEditingController(
                                          text: params.city,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: AppTextField(
                                        title: "الحي",
                                        isRequired: true,
                                        onChanged: (value) {
                                          params.town = value;
                                        },
                                        controller: TextEditingController(
                                          text: params.town,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                AppTextField(
                                  title: "تفاصيل الموقع",
                                  isRequired: true,
                                  onChanged: (value) {
                                    params.address = value;
                                  },
                                  controller: TextEditingController(
                                    text: params.address,
                                  ),
                                ),
                                SizedBox(height: 20),
                                AppText(
                                  'الموقع على الخريطة',
                                  style: TextStyle(
                                    color: Color(0xFF374151),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    height: 1.42,
                                  ),
                                ),
                                SizedBox(height: 8),
                                MapView(
                                  initialLatLng: params.lat != null
                                      ? LatLng(params.lat!, params.long!)
                                      : null,
                                  onPickLocation: (latLng) {
                                    params.lat = latLng.latitude;
                                    params.long = latLng.longitude;
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          StepDetails(
                            number: 3,
                            title: "معلومات التواصل",
                            child: Column(
                              children: [
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
                                  controller: TextEditingController(
                                    text: params.phone,
                                  ),
                                  onChanged: (value) {
                                    params.phone = value;
                                  },
                                  style: TextStyle(
                                    color: Color(0xff2F2B3D),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    filled: true,
                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: Color(0xff064E3B),
                                    ),
                                    fillColor: Color(0xffF9FAFB),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    AppText.bodyMedium(
                                      'رقم الواتساب',
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
                                  controller: TextEditingController(
                                    text: params.whatsapp,
                                  ),
                                  onChanged: (value) {
                                    params.whatsapp = value;
                                  },
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
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.info_rounded,
                                      color: Color(0xff064E3B),
                                      size: 15,
                                    ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  controller: TextEditingController(
                                    text: params.instagram,
                                  ),
                                  onChanged: (value) {
                                    params.instagram = value;
                                  },
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
                                      child: AppImage.asset(
                                        AppImages.instagram,
                                      ),
                                    ),
                                    fillColor: Color(0xffF9FAFB),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                TextFormField(
                                  controller: TextEditingController(
                                    text: params.facebook,
                                  ),
                                  onChanged: (value) {
                                    params.facebook = value;
                                  },
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
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide(
                                        color: Color(0xffE5E7EB),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
                      if (state.storeDataStatus == BlocStatus.failed) {
                        AppToast.showToast(
                          context: context,
                          message: state.errorMessage.toString(),
                          type: ToastificationType.error,
                        );
                      }
                      if (state.storeDataStatus == BlocStatus.success) {
                        context.pop();
                        AppToast.showToast(
                          context: context,
                          message: "تم حفظ التغييرات بنجاح",
                          type: ToastificationType.success,
                        );
                      }
                    },
                    buildWhen: (previous, current) =>
                        previous.storeDataStatus != current.storeDataStatus,
                    builder: (context, state) {
                      if (state.storeDataStatus == BlocStatus.loading) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                        ),
                        child: Row(
                          spacing: 16,
                          children: [
                            Expanded(
                              child: AppButton(
                                title: "حفظ التغييرات",
                                onTap: () {
                                  context.read<ProfileBloc>().add(
                                    UpdateStoreDataEvent(
                                      params: UpdateStoreDataParams(
                                        params: params,
                                      ),
                                    ),
                                  );
                                  print("accept");
                                },
                              ),
                            ),
                            AppOutlinedButton(
                              title: "إلغاء",
                              color: const Color(0xFFFF4C51),
                              onTap: () {
                                print("Reject");
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 16 + context.padding.bottom),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

class ProfileParams {
  String? logo64Based, cover64Based;
  String? storeName, description;
  String? city, town, address;
  String? phone, whatsapp, instagram, facebook;
  double? lat, long;
}
