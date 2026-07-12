import 'dart:developer';

import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/widgets/product_image_field.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/add_update_store_employee_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_employee_permissions_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/update_store_employee_password_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/helpers/phone_number_helper.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
import '../../../../core/widgets/app_phone_number_field.dart';
import '../../../../core/widgets/app_switch.dart';
import '../../../products/view/widgets/product_text_field.dart';
import '../../data/models/get_store_employees_model.dart';
import '../manager/bloc/profile_bloc.dart';

@AutoRoutePage(path: "/profile/employees/create_employee")
class CreateNewEmployeeScreen extends StatefulWidget {
  const CreateNewEmployeeScreen({super.key, this.params});
  final GetStoreEmployeesModelDataEmployeesItem? params;
  @override
  State<CreateNewEmployeeScreen> createState() =>
      _CreateNewEmployeeScreenState();
}

class _CreateNewEmployeeScreenState extends State<CreateNewEmployeeScreen> {
  GetStoreEmployeesModelDataEmployeesItem params =
      GetStoreEmployeesModelDataEmployeesItem();
  String? imagePath;
  final _phoneFieldKey = GlobalKey<AppPhoneNumberFieldState>();
  PhoneNumber? _phone;
  PhoneNumber? _initialPhone;
  late final TextEditingController _newPasswordController;
  late final TextEditingController _confirmPasswordController;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _passwordMismatch = false;
  bool _isUpdatingPassword = false;

  @override
  void initState() {
    super.initState();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    if (widget.params != null) params = widget.params!;
    params.user ??= GetStoreEmployeesModelDataEmployeesItemUser();
    params.permissionIds ??= [];
    _loadInitialPhone();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadInitialPhone() async {
    final parsed = await parseInitialPhone(params.user?.phone);
    if (!mounted) return;
    log(parsed?.phoneNumber ?? "");
    setState(() {
      _initialPhone = parsed;
      _phone = parsed;
    });
  }

  bool get _isCreateMode => widget.params == null;

  bool get _shouldSendPassword {
    if (_isCreateMode) return true;
    return _newPasswordController.text.trim().isNotEmpty ||
        _confirmPasswordController.text.trim().isNotEmpty;
  }

  void _syncPasswordMismatch() {
    final newPassword = _newPasswordController.text.trim();
    final confirmation = _confirmPasswordController.text.trim();
    final mismatch =
        newPassword.isNotEmpty &&
        confirmation.isNotEmpty &&
        newPassword != confirmation;
    if (_passwordMismatch != mismatch) {
      setState(() {
        _passwordMismatch = mismatch;
      });
    }
  }

  String? _validatePasswordSection() {
    final newPassword = _newPasswordController.text.trim();
    final confirmation = _confirmPasswordController.text.trim();
    final hasAnyPasswordInput =
        newPassword.isNotEmpty || confirmation.isNotEmpty;

    if (!_isCreateMode && !hasAnyPasswordInput) {
      _passwordMismatch = false;
      return null;
    }

    if (newPassword.isEmpty || confirmation.isEmpty) {
      _passwordMismatch = false;
      return "الرجاء إدخال كلمة المرور وتأكيدها";
    }

    if (newPassword.length < 8) {
      _passwordMismatch = false;
      return "كلمة المرور يجب أن تكون 8 أحرف على الأقل";
    }

    if (newPassword != confirmation) {
      _passwordMismatch = true;
      return "كلمتا المرور غير متطابقتين";
    }

    _passwordMismatch = false;
    return null;
  }

  Future<void> _updateEmployeePassword({required int staffId}) async {
    setState(() {
      _isUpdatingPassword = true;
    });

    final result = await getIt<UpdateStoreEmployeePasswordUseCase>()(
      UpdateStoreEmployeePasswordParams(
        staffId: staffId,
        newPassword: _newPasswordController.text.trim(),
        newPasswordConfirmation: _confirmPasswordController.text.trim(),
      ),
    );

    if (!mounted) return;
    setState(() {
      _isUpdatingPassword = false;
    });

    await result.fold(
      (l) async {
        AppToast.showToast(
          context: context,
          message: "تم حفظ الموظف، لكن فشل تحديث كلمة المرور: ${l.message}",
          type: ToastificationType.warning,
        );
        context.pop(true);
      },
      (r) async {
        AppToast.showToast(
          context: context,
          message: r.message ?? "تم الحفظ بنجاح",
          type: ToastificationType.success,
        );
        context.pop(true);
      },
    );
  }

  Widget _buildPasswordField({
    required String title,
    required String hintText,
    required TextEditingController controller,
    required bool obscureText,
    required VoidCallback onToggle,
    bool hasError = false,
  }) {
    return Column(
      spacing: 8,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: title,
            children: const [
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
          style: const TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontWeight: FontWeight.w500,
            height: 1.42,
          ),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          onChanged: (_) => _syncPasswordMismatch(),
          onTapOutside: (_) => FocusScope.of(context).unfocus(),
          style: const TextStyle(color: Color(0xB22F2B3D), fontSize: 14),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            hintText: hintText,
            hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
            suffixIcon: IconButton(
              icon: Icon(
                obscureText
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: const Color(0xFF6B7280),
              ),
              onPressed: onToggle,
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFE5E7EB),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFE5E7EB),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError
                    ? const Color(0xFFEF4444)
                    : const Color(0xFFE5E7EB),
              ),
              borderRadius: const BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _onSavePressed(ProfileBloc bloc) async {
    if (_isUpdatingPassword) return;

    _syncPasswordMismatch();
    final phoneError = await _phoneFieldKey.currentState?.validate();
    if (phoneError != null) {
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        message: phoneError,
        type: ToastificationType.error,
      );
      return;
    }

    final phone = formatPhoneForApi(_phone);
    if (phone == null) {
      if (!mounted) return;
      AppToast.showToast(
        context: context,
        message: "الرجاء إدخال رقم الهاتف",
        type: ToastificationType.error,
      );
      return;
    }

    final passwordError = _validatePasswordSection();
    if (passwordError != null) {
      if (!mounted) return;
      setState(() {});
      AppToast.showToast(
        context: context,
        message: passwordError,
        type: ToastificationType.error,
      );
      return;
    }

    params.user?.phone = phone;

    bloc.add(
      AddUpdateStoreEmployeeEvent(
        params: AddUpdateStoreEmployeeParams(
          method: params.id != null ? RequestMethod.put : RequestMethod.post,
          userId: params.userId,
          storeId: 1,
          employee: params,
          imagePath: imagePath,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>()
          ..add(
            GetEmployeePermissionsEvent(params: GetEmployeePermissionsParams()),
          ),
        child: Column(
          children: [
            AppSimpleAppBar(
              title: widget.params != null
                  ? "تفاصيل الموظف"
                  : "إضافة موظف جديد",
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24),
                child: Column(
                  children: [
                    _ProfileForm(
                      title: "البيانات الأساسية",
                      icon: FontAwesomeIcons.user.data,
                      iconColor: Color(0xFF064E3B),
                      child: Column(
                        children: [
                          AppImageField(
                            initialNetworkImage: params.user?.profileImageUrl,
                            onPickImage: (imagePath) {
                              this.imagePath = imagePath;
                            },
                            title: "صورة الموظف",
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            title: "الاسم الكامل",
                            hintText: "أدخل الاسم الكامل للموظف",
                            isRequired: true,
                            controller: TextEditingController(
                              text: params.user?.name,
                            ),
                            onChanged: (value) {
                              params.user?.name = value;
                            },
                          ),
                          SizedBox(height: 16),
                          AppTextField(
                            title: "الايميل",
                            hintText: "أدخل ايميل للموظف",
                            isRequired: true,
                            controller: TextEditingController(
                              text: params.user?.email,
                            ),
                            onChanged: (value) {
                              params.user?.email = value;
                            },
                          ),
                          SizedBox(height: 16),
                          AppPhoneNumberField(
                            key: _phoneFieldKey,
                            label: 'رقم الهاتف',
                            hintText: "9xxxxxxxx",
                            isRequired: true,
                            initialValue: _initialPhone,
                            variant: AppPhoneFieldVariant.ownerProfile,
                            onChanged: (phone) => _phone = phone,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProfileForm(
                      title: "تحديد صلاحيات الموظف",
                      subtitle: "اختر الصلاحيات المناسبة لدور الموظف",
                      icon: FontAwesomeIcons.shieldHalved.data,
                      iconColor: Color(0xFFD97706),
                      child: BlocBuilder<ProfileBloc, ProfileState>(
                        buildWhen: (previous, current) =>
                            previous.employeePermissionsStatus !=
                            current.employeePermissionsStatus,
                        builder: (context, state) {
                          if (state.employeePermissionsStatus ==
                              BlocStatus.loading) {
                            return PermissionLoading();
                          } else if (state.employeePermissionsStatus ==
                              BlocStatus.failed) {
                            return Center(
                              child: FailureWidget(
                                message: state.errorMessage.toString(),
                                onRetry: () {
                                  context.read<ProfileBloc>().add(
                                    GetEmployeePermissionsEvent(
                                      params: GetEmployeePermissionsParams(),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state.employeePermissionsStatus ==
                              BlocStatus.success) {
                            return Column(
                              spacing: 10,
                              children: [
                                ...List.generate(
                                  state
                                          .employeePermissions
                                          ?.data
                                          ?.permissions
                                          ?.length ??
                                      0,
                                  (index) => _PermissionChooser(
                                    value:
                                        params.permissionIds?.contains(
                                          state
                                              .employeePermissions!
                                              .data!
                                              .permissions![index]
                                              .id!,
                                        ) ??
                                        false,
                                    name: state
                                        .employeePermissions!
                                        .data!
                                        .permissions![index]
                                        .name!,
                                    id: state
                                        .employeePermissions!
                                        .data!
                                        .permissions![index]
                                        .id!,
                                    onChanged: (value) {
                                      if (value) {
                                        params.permissionIds?.add(
                                          state
                                              .employeePermissions!
                                              .data!
                                              .permissions![index]
                                              .id!,
                                        );
                                      } else {
                                        params.permissionIds?.removeWhere(
                                          (id) =>
                                              id ==
                                              state
                                                  .employeePermissions!
                                                  .data!
                                                  .permissions![index]
                                                  .id!,
                                        );
                                      }
                                    },
                                  ),
                                ),
                                AlertMessage(
                                  message:
                                      "يمكنك تعديل صلاحيات الموظف في أي وقت من صفحة إدارة الموظفين",
                                  color: Color(0xFF064E3B),
                                  icon: FontAwesomeIcons.solidLightbulb.data,
                                ),
                              ],
                            );
                          }
                          return SizedBox();
                        },
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProfileForm(
                      title: "بيانات كلمة المرور",
                      subtitle: _isCreateMode
                          ? "كلمة المرور مطلوبة عند إنشاء موظف جديد"
                          : "اختياري في التعديل - اترك الحقول فارغة إذا لا تريد تغيير كلمة المرور",
                      icon: FontAwesomeIcons.lock.data,
                      iconColor: Color(0xFF1E3A8A),
                      child: Column(
                        children: [
                          _buildPasswordField(
                            title: "كلمة المرور الجديدة",
                            hintText: "8 أحرف على الأقل",
                            controller: _newPasswordController,
                            obscureText: _obscureNewPassword,
                            hasError: _passwordMismatch,
                            onToggle: () {
                              setState(() {
                                _obscureNewPassword = !_obscureNewPassword;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          _buildPasswordField(
                            title: "تأكيد كلمة المرور",
                            hintText: "أعد إدخال كلمة المرور",
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            hasError: _passwordMismatch,
                            onToggle: () {
                              setState(() {
                                _obscureConfirmPassword =
                                    !_obscureConfirmPassword;
                              });
                            },
                          ),
                          if (_passwordMismatch) ...[
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Color(0xFFEF4444),
                                ),
                                SizedBox(width: 6),
                                Expanded(
                                  child: AppText(
                                    "كلمتا المرور غير متطابقتين",
                                    style: TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProfileForm(
                      title: "حالة الحساب",
                      icon: FontAwesomeIcons.toggleOn.data,
                      iconColor: Color(0xFF10B981),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Color(0xFFF9FAFB),
                              borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    spacing: 4,
                                    children: [
                                      AppText(
                                        "تفعيل الحساب",
                                        style: TextStyle(
                                          color: Color(0xFF111827),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          height: 1.42,
                                        ),
                                      ),
                                      AppText(
                                        "السماح للموظف بالدخول للنظام",
                                        style: TextStyle(
                                          color: Color(0xFF6B7280),
                                          fontSize: 12,
                                          height: 1.333,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                AppSwitch(
                                  onChanged: (value) {
                                    params.isActive =
                                        !(params.isActive ?? false);
                                    setState(() {});
                                  },
                                  value: params.isActive ?? false,
                                  activeColor: Color(0xFF10B981),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16),
                          AlertMessage(
                            message:
                                "الحساب نشط - سيتمكن الموظف من تسجيل الدخول فور الحفظ",
                            icon: FontAwesomeIcons.solidCircleCheck.data,
                            color: Color(0xFF10B981),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 28),
                    BlocConsumer<ProfileBloc, ProfileState>(
                      listenWhen: (previous, current) =>
                          previous.addUpdateStoreEmployeeStatus !=
                          current.addUpdateStoreEmployeeStatus,
                      listener: (context, state) async {
                        if (state.addUpdateStoreEmployeeStatus ==
                            BlocStatus.failed) {
                          AppToast.showToast(
                            context: context,
                            message: state.errorMessage.toString(),
                            type: ToastificationType.error,
                          );
                        } else if (state.addUpdateStoreEmployeeStatus ==
                            BlocStatus.success) {
                          if (_shouldSendPassword) {
                            final staffId =
                                state.addUpdateStoreEmployee?.data?.id ??
                                params.id;
                            if (staffId == null) {
                              AppToast.showToast(
                                context: context,
                                message:
                                    "تم حفظ الموظف، لكن تعذر تحديث كلمة المرور لعدم توفر معرف الموظف",
                                type: ToastificationType.warning,
                              );
                              context.pop(true);
                              return;
                            }
                            await _updateEmployeePassword(staffId: staffId);
                            return;
                          }

                          AppToast.showToast(
                            context: context,
                            message:
                                "تم ${params.id != null ? "التعديل" : "الإضافة"} بنجاح",
                            type: ToastificationType.success,
                          );
                          context.pop(true);
                        }
                      },
                      buildWhen: (previous, current) =>
                          previous.addUpdateStoreEmployeeStatus !=
                          current.addUpdateStoreEmployeeStatus,
                      builder: (context, state) {
                        if (state.addUpdateStoreEmployeeStatus ==
                                BlocStatus.loading ||
                            _isUpdatingPassword) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                title: "حفظ وتفعيل",
                                onTap: () async {
                                  await _onSavePressed(
                                    context.read<ProfileBloc>(),
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
                    // SizedBox(height: 45),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PermissionLoading extends StatelessWidget {
  const PermissionLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Column(
        spacing: 10,
        children: [
          _PermissionChooser(
            id: 1,
            name: "sdfsdf",
            onChanged: (value) {},
            value: false,
          ),
          _PermissionChooser(
            id: 1,
            name: "sdfsdf",
            onChanged: (value) {},
            value: false,
          ),
          _PermissionChooser(
            id: 1,
            name: "sdfsdf",
            onChanged: (value) {},
            value: false,
          ),
          AlertMessage(
            message:
                "يمكنك تعديل صلاحيات الموظف في أي وقت من صفحة إدارة الموظفين",
            color: Color(0xFF064E3B),
            icon: FontAwesomeIcons.solidLightbulb.data,
          ),
        ],
      ),
    );
  }
}

class PermissionDetails {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  PermissionDetails(this.title, this.description, this.icon, this.color);
}

class _PermissionChooser extends StatefulWidget {
  const _PermissionChooser({
    required this.name,
    required this.id,
    required this.onChanged,
    required this.value,
  });
  final String name;
  final int id;
  final void Function(bool value) onChanged;
  final bool value;

  @override
  State<_PermissionChooser> createState() => _PermissionChooserState();
}

class _PermissionChooserState extends State<_PermissionChooser> {
  bool isEnabled = false;
  @override
  void initState() {
    isEnabled = widget.value;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFF9FAFB),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Checkbox(
            value: isEnabled,
            onChanged: (value) {
              if (value == null) return;
              isEnabled = !isEnabled;
              widget.onChanged(value);
              setState(() {});
            },
            side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(6)),
              side: BorderSide(width: 2, color: Color(0xFFD1D5DB)),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  spacing: 8,
                  children: [
                    Icon(
                      getPermissionDetails(widget.name).icon,
                      color: getPermissionDetails(widget.name).color,
                      size: 14,
                    ),
                    Expanded(
                      child: AppText(
                        getPermissionDetails(widget.name).title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          height: 1.42,
                        ),
                      ),
                    ),
                  ],
                ),
                AppText(
                  getPermissionDetails(widget.name).description,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1.333,
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

class _ProfileForm extends StatelessWidget {
  const _ProfileForm({
    required this.title,
    this.subtitle,
    required this.child,
    required this.icon,
    required this.iconColor,
  });
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: const Color(0xFFF3F4F6)),
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFFF3F4F6))),
            ),
            child: Row(
              spacing: 8,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    color: iconColor.withValues(alpha: .1),
                  ),
                  child: Icon(icon, size: 18, color: iconColor),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 2,
                    children: [
                      AppText(
                        title,
                        style: TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          height: 1.5,
                        ),
                      ),
                      if (subtitle != null)
                        AppText(
                          subtitle!,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 12,
                            height: 1.333,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

class AlertMessage extends StatelessWidget {
  const AlertMessage({
    super.key,
    required this.message,
    required this.icon,
    required this.color,
  });
  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .05),
        borderRadius: BorderRadius.all(Radius.circular(12)),
        border: Border.all(color: color.withValues(alpha: .2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 14, color: color),
          ),
          SizedBox(width: 11),
          Expanded(
            child: AppText(
              message,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Color(0xFF374151),
                fontSize: 12,
                fontWeight: FontWeight.w500,
                height: 1.667,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class EmployeeParams {
  List<int> permissionIds = [];
  bool isActive = true;
  String? name;
  String? phone;
  String? imagePath;
}

PermissionDetails getPermissionDetails(String permission) {
  const storeColor = Color(0xFF2196F3); // Blue
  const productColor = Color(0xFF4CAF50); // Green
  const orderColor = Color(0xFFFF9800); // Orange
  const inventoryColor = Color(0xFF607D8B); // Blue Grey
  const offerColor = Color(0xFFE91E63); // Pink
  const staffColor = Color(0xFF673AB7); // Deep Purple
  const couponColor = Color(0xFF00BCD4); // Cyan
  const reportColor = Color(0xFF3F51B5); // Indigo
  const deleteColor = Color(0xFFF44336); // Red
  switch (permission) {
    // --- STORES (Blue) ---
    case 'stores.view':
      return PermissionDetails(
        "عرض المتاجر",
        "صلاحية الوصول إلى قائمة الفروع واستعراض بيانات المواقع.",
        FontAwesomeIcons.shop.data,
        storeColor,
      );
    case 'stores.create':
      return PermissionDetails(
        "إضافة متجر جديد",
        "إدراج فروع أو مستودعات جديدة في النظام وتحديد إعداداتها.",
        FontAwesomeIcons.circlePlus.data,
        storeColor,
      );
    case 'stores.update':
      return PermissionDetails(
        "تحديث بيانات المتجر",
        "تعديل معلومات الفروع القائمة مثل الموقع، وساعات العمل.",
        FontAwesomeIcons.penToSquare.data,
        storeColor,
      );
    case 'stores.delete':
      return PermissionDetails(
        "حذف المتجر",
        "إزالة بيانات المتجر من النظام أو أرشفتها بشكل نهائي.",
        FontAwesomeIcons.trashCan.data,
        deleteColor,
      );

    // --- PRODUCTS (Green) ---
    case 'products.view':
      return PermissionDetails(
        "استعراض المنتجات",
        "الاطلاع على كتالوج المنتجات، الأسعار، والمواصفات المتوفرة.",
        FontAwesomeIcons.boxesStacked.data,
        productColor,
      );
    case 'products.create':
      return PermissionDetails(
        "إضافة منتج",
        "تسجيل أصناف جديدة في النظام مع تحديد الأسعار والصور.",
        FontAwesomeIcons.boxOpen.data,
        productColor,
      );
    case 'products.update':
      return PermissionDetails(
        "تعديل المنتجات",
        "تغيير تفاصيل المنتج القائمة مثل تحديث الأسعار أو الوصف.",
        FontAwesomeIcons.filePen.data,
        productColor,
      );
    case 'products.delete':
      return PermissionDetails(
        "حذف المنتج",
        "إلغاء توفر المنتج وإزالته من قوائم البيع والبحث.",
        FontAwesomeIcons.eraser.data,
        deleteColor,
      );

    // --- ORDERS (Orange) ---
    case 'orders.view':
      return PermissionDetails(
        "متابعة الطلبات",
        "عرض تفاصيل طلبات الشراء، سجل المبيعات، وحالة الفواتير.",
        FontAwesomeIcons.receipt.data,
        orderColor,
      );
    case 'orders.create':
      return PermissionDetails(
        "إنشاء طلب",
        "إدراج عمليات بيع جديدة يدويًا وتحديد بيانات العميل.",
        FontAwesomeIcons.cartPlus.data,
        orderColor,
      );
    case 'orders.update':
      return PermissionDetails(
        "تحديث الطلبات",
        "تعديل حالة الطلب أو مراجعة الكميات.",
        FontAwesomeIcons.truckRampBox.data,
        orderColor,
      );
    case 'orders.delete':
      return PermissionDetails(
        "إلغاء الطلب",
        "حذف العمليات الشرائية الخاطئة أو معالجة المرتجعات.",
        FontAwesomeIcons.rectangleXmark.data,
        deleteColor,
      );

    // --- INVENTORY (Blue Grey) ---
    case 'inventory.view':
      return PermissionDetails(
        "رقابة المخزون",
        "الاطلاع على مستويات المخزون الحالية وتنبيهات النواقص.",
        FontAwesomeIcons.warehouse.data,
        inventoryColor,
      );
    case 'inventory.create':
      return PermissionDetails(
        "إدخال مخزني",
        "إضافة كميات جديدة للمستودع وتوثيق حركات التوريد.",
        FontAwesomeIcons.fileImport.data,
        inventoryColor,
      );
    case 'inventory.update':
      return PermissionDetails(
        "تسوية المخزون",
        "تعديل كميات الأصناف لمطابقة الجرد الفعلي.",
        FontAwesomeIcons.arrowRotateLeft.data,
        inventoryColor,
      );
    case 'inventory.delete':
      return PermissionDetails(
        "حذف سجلات المخزن",
        "إزالة بيانات الجرد القديمة أو الحركات الخاطئة.",
        FontAwesomeIcons.folderMinus.data,
        deleteColor,
      );

    // --- OFFERS (Pink) ---
    case 'offers.view':
      return PermissionDetails(
        "عرض العروض",
        "الاطلاع على قائمة الخصومات والحملات الترويجية النشطة.",
        FontAwesomeIcons.tags.data,
        offerColor,
      );
    case 'offers.create':
      return PermissionDetails(
        "إضافة عرض",
        "إطلاق حملات تخفيض جديدة وتحديد المنتجات المشمولة.",
        FontAwesomeIcons.tag.data,
        offerColor,
      );
    case 'offers.update':
      return PermissionDetails(
        "تحديث العروض",
        "تعديل نسب الخصم أو تمديد فترات صلاحية الحملات.",
        FontAwesomeIcons.clockRotateLeft.data,
        offerColor,
      );
    case 'offers.delete':
      return PermissionDetails(
        "إيقاف العرض",
        "إلغاء العروض الترويجية وإعادة الأسعار لطبيعتها.",
        FontAwesomeIcons.ban.data,
        deleteColor,
      );

    // --- STAFF (Purple) ---
    case 'staff.view':
      return PermissionDetails(
        "عرض الموظفين",
        "استعراض قائمة طاقم العمل، بيانات الاتصال، والأدوار.",
        FontAwesomeIcons.usersGear.data,
        staffColor,
      );
    case 'staff.create':
      return PermissionDetails(
        "توظيف موظف",
        "إنشاء حسابات جديدة للموظفين وتعيين الصلاحيات.",
        FontAwesomeIcons.userPlus.data,
        staffColor,
      );
    case 'staff.update':
      return PermissionDetails(
        "تعديل بيانات الموظف",
        "تحديث معلومات الموظفين وتعديل مسمياتهم الوظيفية.",
        FontAwesomeIcons.userPen.data,
        staffColor,
      );
    case 'staff.delete':
      return PermissionDetails(
        "إنهاء الخدمة",
        "تعطيل حساب الموظف ومنعه من الوصول للنظام.",
        FontAwesomeIcons.userSlash.data,
        deleteColor,
      );

    // --- COUPONS (Cyan) ---
    case 'coupons.view':
      return PermissionDetails(
        "إدارة الكوبونات",
        "الاطلاع على رموز الخصم، ونسب التوفير.",
        FontAwesomeIcons.ticket.data,
        couponColor,
      );
    case 'coupons.create':
      return PermissionDetails(
        "إنشاء كوبون",
        "توليد أكواد خصم جديدة وتحديد شروط الاستخدام.",
        FontAwesomeIcons.plus.data,
        couponColor,
      );
    case 'coupons.update':
      return PermissionDetails(
        "تحديث الكوبون",
        "تعديل قيم الخصم أو تغيير حالة النشاط.",
        FontAwesomeIcons.wrench.data,
        couponColor,
      );
    case 'coupons.delete':
      return PermissionDetails(
        "حذف الكوبون",
        "إلغاء كود الخصم نهائيًا ومنع استخدامه.",
        FontAwesomeIcons.xmark.data,
        deleteColor,
      );

    // --- REPORTS (Indigo) ---
    case 'reports.view':
      return PermissionDetails(
        "تحليل التقارير",
        "استخراج الإحصائيات المالية والرسوم البيانية.",
        FontAwesomeIcons.chartLine.data,
        reportColor,
      );

    default:
      return PermissionDetails(
        permission,
        permission,
        FontAwesomeIcons.question.data,
        Colors.grey,
      );
  }
}
