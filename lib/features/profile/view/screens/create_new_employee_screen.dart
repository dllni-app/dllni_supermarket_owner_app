import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/failure_widget.dart';
import 'package:dllni_supermarket_owner_app/features/products/view/widgets/product_image_field.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/add_update_store_employee_use_case.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_employee_permissions_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/app_buttons.dart';
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
  @override
  void initState() {
    if (widget.params != null) params = widget.params!;
    params.user ??= GetStoreEmployeesModelDataEmployeesItemUser();
    params.permissionIds ??= [];
    super.initState();
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
                      icon: FontAwesomeIcons.user,
                      iconColor: Color(0xFF064E3B),
                      child: Column(
                        children: [
                          AppImageField(
                            initialNetworkImage: params.user?.profileImageUrl,
                            onPickImage: (imagePath) {
                              imagePath = imagePath;
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
                          AppTextField(
                            title: "رقم الهاتف",
                            hintText: "9xxxxxxxx",
                            isRequired: true,
                            keyboardType: TextInputType.phone,
                            controller: TextEditingController(
                              text: params.user?.phone,
                            ),
                            onChanged: (value) {
                              params.user?.phone = value;
                            },
                            suffixIcon: Padding(
                              padding: EdgeInsets.only(top: 15),
                              child: Text(
                                "   +963",
                                textDirection: TextDirection.ltr,
                                style: TextStyle(
                                  color: Color(0xFF4B5563),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  height: 1.42,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    _ProfileForm(
                      title: "تحديد صلاحيات الموظف",
                      subtitle: "اختر الصلاحيات المناسبة لدور الموظف",
                      icon: FontAwesomeIcons.shieldHalved,
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
                                  icon: FontAwesomeIcons.solidLightbulb,
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
                      title: "حالة الحساب",
                      icon: FontAwesomeIcons.toggleOn,
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
                            icon: FontAwesomeIcons.solidCircleCheck,
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
                      listener: (context, state) {
                        if (state.addUpdateStoreEmployeeStatus ==
                            BlocStatus.failed) {
                          AppToast.showToast(
                            context: context,
                            message: state.errorMessage.toString(),
                            type: ToastificationType.error,
                          );
                        } else if (state.addUpdateStoreEmployeeStatus ==
                            BlocStatus.success) {
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
                            BlocStatus.loading) {
                          return Center(child: CircularProgressIndicator());
                        }
                        return Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                title: "حفظ وتفعيل",
                                onTap: () {
                                  // print(params.id);
                                  // print(params.user?.id);
                                  // print(params.user?.name);
                                  // print(params.user?.email);
                                  // print(params.user?.phone);
                                  // print(imagePath);
                                  // print(params.permissionIds);
                                  // return;
                                  context.read<ProfileBloc>().add(
                                    AddUpdateStoreEmployeeEvent(
                                      params: AddUpdateStoreEmployeeParams(
                                        method: params.id != null
                                            ? RequestMethod.put
                                            : RequestMethod.post,
                                        userId: params.userId,
                                        storeId: 1,
                                        employee: params,
                                        imagePath: imagePath,
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
            icon: FontAwesomeIcons.solidLightbulb,
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
                Column(
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
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 12,
                          height: 1.333,
                        ),
                      ),
                  ],
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
        FontAwesomeIcons.shop,
        storeColor,
      );
    case 'stores.create':
      return PermissionDetails(
        "إضافة متجر جديد",
        "إدراج فروع أو مستودعات جديدة في النظام وتحديد إعداداتها.",
        FontAwesomeIcons.circlePlus,
        storeColor,
      );
    case 'stores.update':
      return PermissionDetails(
        "تحديث بيانات المتجر",
        "تعديل معلومات الفروع القائمة مثل الموقع، وساعات العمل.",
        FontAwesomeIcons.penToSquare,
        storeColor,
      );
    case 'stores.delete':
      return PermissionDetails(
        "حذف المتجر",
        "إزالة بيانات المتجر من النظام أو أرشفتها بشكل نهائي.",
        FontAwesomeIcons.trashCan,
        deleteColor,
      );

    // --- PRODUCTS (Green) ---
    case 'products.view':
      return PermissionDetails(
        "استعراض المنتجات",
        "الاطلاع على كتالوج المنتجات، الأسعار، والمواصفات المتوفرة.",
        FontAwesomeIcons.boxesStacked,
        productColor,
      );
    case 'products.create':
      return PermissionDetails(
        "إضافة منتج",
        "تسجيل أصناف جديدة في النظام مع تحديد الأسعار والصور.",
        FontAwesomeIcons.boxOpen,
        productColor,
      );
    case 'products.update':
      return PermissionDetails(
        "تعديل المنتجات",
        "تغيير تفاصيل المنتج القائمة مثل تحديث الأسعار أو الوصف.",
        FontAwesomeIcons.filePen,
        productColor,
      );
    case 'products.delete':
      return PermissionDetails(
        "حذف المنتج",
        "إلغاء توفر المنتج وإزالته من قوائم البيع والبحث.",
        FontAwesomeIcons.eraser,
        deleteColor,
      );

    // --- ORDERS (Orange) ---
    case 'orders.view':
      return PermissionDetails(
        "متابعة الطلبات",
        "عرض تفاصيل طلبات الشراء، سجل المبيعات، وحالة الفواتير.",
        FontAwesomeIcons.receipt,
        orderColor,
      );
    case 'orders.create':
      return PermissionDetails(
        "إنشاء طلب",
        "إدراج عمليات بيع جديدة يدويًا وتحديد بيانات العميل.",
        FontAwesomeIcons.cartPlus,
        orderColor,
      );
    case 'orders.update':
      return PermissionDetails(
        "تحديث الطلبات",
        "تعديل حالة الطلب أو مراجعة الكميات.",
        FontAwesomeIcons.truckRampBox,
        orderColor,
      );
    case 'orders.delete':
      return PermissionDetails(
        "إلغاء الطلب",
        "حذف العمليات الشرائية الخاطئة أو معالجة المرتجعات.",
        FontAwesomeIcons.rectangleXmark,
        deleteColor,
      );

    // --- INVENTORY (Blue Grey) ---
    case 'inventory.view':
      return PermissionDetails(
        "رقابة المخزون",
        "الاطلاع على مستويات المخزون الحالية وتنبيهات النواقص.",
        FontAwesomeIcons.warehouse,
        inventoryColor,
      );
    case 'inventory.create':
      return PermissionDetails(
        "إدخال مخزني",
        "إضافة كميات جديدة للمستودع وتوثيق حركات التوريد.",
        FontAwesomeIcons.fileImport,
        inventoryColor,
      );
    case 'inventory.update':
      return PermissionDetails(
        "تسوية المخزون",
        "تعديل كميات الأصناف لمطابقة الجرد الفعلي.",
        FontAwesomeIcons.arrowRotateLeft,
        inventoryColor,
      );
    case 'inventory.delete':
      return PermissionDetails(
        "حذف سجلات المخزن",
        "إزالة بيانات الجرد القديمة أو الحركات الخاطئة.",
        FontAwesomeIcons.folderMinus,
        deleteColor,
      );

    // --- OFFERS (Pink) ---
    case 'offers.view':
      return PermissionDetails(
        "عرض العروض",
        "الاطلاع على قائمة الخصومات والحملات الترويجية النشطة.",
        FontAwesomeIcons.tags,
        offerColor,
      );
    case 'offers.create':
      return PermissionDetails(
        "إضافة عرض",
        "إطلاق حملات تخفيض جديدة وتحديد المنتجات المشمولة.",
        FontAwesomeIcons.tag,
        offerColor,
      );
    case 'offers.update':
      return PermissionDetails(
        "تحديث العروض",
        "تعديل نسب الخصم أو تمديد فترات صلاحية الحملات.",
        FontAwesomeIcons.clockRotateLeft,
        offerColor,
      );
    case 'offers.delete':
      return PermissionDetails(
        "إيقاف العرض",
        "إلغاء العروض الترويجية وإعادة الأسعار لطبيعتها.",
        FontAwesomeIcons.ban,
        deleteColor,
      );

    // --- STAFF (Purple) ---
    case 'staff.view':
      return PermissionDetails(
        "عرض الموظفين",
        "استعراض قائمة طاقم العمل، بيانات الاتصال، والأدوار.",
        FontAwesomeIcons.usersGear,
        staffColor,
      );
    case 'staff.create':
      return PermissionDetails(
        "توظيف موظف",
        "إنشاء حسابات جديدة للموظفين وتعيين الصلاحيات.",
        FontAwesomeIcons.userPlus,
        staffColor,
      );
    case 'staff.update':
      return PermissionDetails(
        "تعديل بيانات الموظف",
        "تحديث معلومات الموظفين وتعديل مسمياتهم الوظيفية.",
        FontAwesomeIcons.userPen,
        staffColor,
      );
    case 'staff.delete':
      return PermissionDetails(
        "إنهاء الخدمة",
        "تعطيل حساب الموظف ومنعه من الوصول للنظام.",
        FontAwesomeIcons.userSlash,
        deleteColor,
      );

    // --- COUPONS (Cyan) ---
    case 'coupons.view':
      return PermissionDetails(
        "إدارة الكوبونات",
        "الاطلاع على رموز الخصم، ونسب التوفير.",
        FontAwesomeIcons.ticket,
        couponColor,
      );
    case 'coupons.create':
      return PermissionDetails(
        "إنشاء كوبون",
        "توليد أكواد خصم جديدة وتحديد شروط الاستخدام.",
        FontAwesomeIcons.plus,
        couponColor,
      );
    case 'coupons.update':
      return PermissionDetails(
        "تحديث الكوبون",
        "تعديل قيم الخصم أو تغيير حالة النشاط.",
        FontAwesomeIcons.wrench,
        couponColor,
      );
    case 'coupons.delete':
      return PermissionDetails(
        "حذف الكوبون",
        "إلغاء كود الخصم نهائيًا ومنع استخدامه.",
        FontAwesomeIcons.xmark,
        deleteColor,
      );

    // --- REPORTS (Indigo) ---
    case 'reports.view':
      return PermissionDetails(
        "تحليل التقارير",
        "استخراج الإحصائيات المالية والرسوم البيانية.",
        FontAwesomeIcons.chartLine,
        reportColor,
      );

    default:
      return PermissionDetails(
        permission,
        permission,
        FontAwesomeIcons.question,
        Colors.grey,
      );
  }
}
