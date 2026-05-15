import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/core/widgets/app_app_bars.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/themes/app_colors.dart';
import '../../../../core/themes/app_shadows.dart';
import '../../../../core/utils/app_svgs.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../../products/view/widgets/big_button_with_icon.dart';
import '../../data/models/get_store_employees_model.dart';
import '../../domain/usecases/get_store_employees_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import 'create_new_employee_screen.dart';

class EmployeeLoading extends StatelessWidget {
  const EmployeeLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) => _EmployeeCard(
          employee: GetStoreEmployeesModelDataEmployeesItem.fromJson({
            "id": 9,
            "storeId": 1,
            "userId": 35,
            "isActive": true,
            "user": {
              "id": 35,
              "name": "Mohammed Deeb",
              "email": "jalabmouhamed@gmail.com",
              "phone": "+963954802408",
              "profileImageUrl": "http://localhost/storage/1/avatar.png",
            },
            "permissionIds": [18, 20],
            "effectivePermissions": ["coupons.create", "coupons.delete"],
            "createdAt": "2026-03-16 02:54:52",
            "updatedAt": "2026-03-16 02:54:52",
          }),
        ),
        itemCount: 3,
        separatorBuilder: (context, index) => SizedBox(height: 13),
      ),
    );
  }
}

@AutoRoutePage(path: "/profile/employees")
class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
}

class _EmployeeCard extends StatelessWidget {
  final GetStoreEmployeesModelDataEmployeesItem employee;
  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppImage.network(
                employee.user?.profileImageUrl ?? "null",
                size: 56,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                failedBuilder: (context) =>
                    Icon(Icons.error_outline, color: Colors.black),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      employee.user?.name ?? "null",
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        if (employee.isActive ?? false)
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0x1A10B981),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Color(0xFF10B981),
                                ),
                                SizedBox(width: 4),
                                AppText(
                                  "نشط",
                                  style: TextStyle(
                                    color: Color(0xFF10B981),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0x1AF59E0B),
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor: Color(0xFFF59E0B),
                                ),
                                SizedBox(width: 4),
                                AppText(
                                  "معطل",
                                  style: TextStyle(
                                    color: Color(0xFFF59E0B),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    height: 1.333,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(width: 8),
                        Icon(Icons.phone, color: Color(0xFF4B5563), size: 10),
                        SizedBox(width: 4),
                        Text(
                          employee.user?.phone ?? "null",
                          textDirection: material.TextDirection.ltr,
                          style: TextStyle(
                            color: Color(0xFF4B5563),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            height: 1.333,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12),
              Icon(Icons.more_vert, color: Color(0xFF4B5563), size: 18),
            ],
          ),
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              color: Color(0xFFF9FAFB),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      "تاريخ الانضمام",
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        height: 1.333,
                      ),
                    ),
                    Spacer(),
                    AppText(
                      DateFormat.yMMMMd('ar_SA').format(
                        DateTime.tryParse(employee.createdAt ?? "") ??
                            DateTime(2025),
                      ),
                      style: TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                AppText(
                  "الصلاحيات",
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    height: 1.333,
                  ),
                ),
                if (employee.effectivePermissions?.isNotEmpty ?? false) ...[
                  ...List.generate(
                    employee.effectivePermissions?.length ?? 0,
                    (index) => AppText(
                      getPermissionDetails(
                        employee.effectivePermissions?[index] ?? "null",
                      ).title,
                      style: TextStyle(
                        color: context.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.6667,
                      ),
                    ),
                  ),
                ] else
                  AppText(
                    "لا يوجد صلاحيات محددة",
                    style: TextStyle(
                      color: context.primary,
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.6667,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final refresh = await context.pushRoute(
                "/profile/employees/create_employee",
                arguments: employee,
              );
              if (refresh is! bool) return;
              if (!refresh || !context.mounted) return;
              context.read<ProfileBloc>().add(
                GetStoreEmployeesEvent(
                  params: GetStoreEmployeesParams(storeId: 1),
                ),
              );
            },
            borderRadius: BorderRadius.all(Radius.circular(12)),
            child: Container(
              width: context.width,
              padding: EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.all(Radius.circular(12)),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 4),
                    blurRadius: 5.3,
                    color: Color(0x40000000),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    FontAwesomeIcons.solidEye,
                    size: 14,
                    color: AppColors.white,
                  ),
                  SizedBox(width: 8),
                  AppText(
                    "تفاصيل",
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

class _EmployeeManagementScreenState extends State<EmployeeManagementScreen> {
  String? search;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>()
          ..add(
            GetStoreEmployeesEvent(params: GetStoreEmployeesParams(storeId: 1)),
          ),
        child: Column(
          children: [
            AppSimpleAppBar(title: "إدارة الموظفين"),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: context.width,
                    child: Builder(
                      builder: (context) {
                        return BigButtonWithIcon(
                          icon: AppImage.asset(AppSvgs.add, size: 22),
                          title: "إضافة موظف جديد",
                          onPressed: () async {
                            final refresh = await context.pushRoute(
                              "/profile/employees/create_employee",
                            );
                            if (refresh is! bool) return;
                            if (!refresh || !context.mounted) return;
                            context.read<ProfileBloc>().add(
                              GetStoreEmployeesEvent(
                                params: GetStoreEmployeesParams(
                                  storeId: 1,
                                  search: search,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Builder(
                    builder: (context) {
                      return _FilterSection(
                        onSearchChanged: (value) {
                          search = value;
                          context.read<ProfileBloc>().add(
                            GetStoreEmployeesEvent(
                              params: GetStoreEmployeesParams(
                                storeId: 1,
                                search: search,
                              ),
                            ),
                          );
                        },
                        onFilterPressed: null,
                        onSortingPressed: null,
                      );
                    },
                  ),
                  SizedBox(height: 3),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.storeEmployeesStatus !=
                    current.storeEmployeesStatus,
                builder: (context, state) {
                  if (state.storeEmployeesStatus == BlocStatus.loading) {
                    return EmployeeLoading();
                  } else if (state.storeEmployeesStatus == BlocStatus.failed) {
                    return Center(
                      child: FailureWidget(
                        message: state.errorMessage.toString(),
                        onRetry: () {
                          context.read<ProfileBloc>().add(
                            GetStoreEmployeesEvent(
                              params: GetStoreEmployeesParams(
                                storeId: 1,
                                search: search,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else if (state.storeEmployeesStatus == BlocStatus.success) {
                    return ListView.separated(
                      padding: EdgeInsets.all(16),
                      itemCount:
                          state.storeEmployees?.data?.employees?.length ?? 0,
                      itemBuilder: (context, index) => _EmployeeCard(
                        employee: state.storeEmployees!.data!.employees![index],
                      ),
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 13),
                    );
                  }

                  return SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterSection extends StatelessWidget {
  final void Function()? onSortingPressed;

  final void Function()? onFilterPressed;
  final void Function(String value) onSearchChanged;
  const _FilterSection({
    required this.onSortingPressed,
    required this.onFilterPressed,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        border: Border.all(color: Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          TextField(
            style: TextStyle(
              color: Color(0xFF111287),
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
            onSubmitted: onSearchChanged,
            decoration: InputDecoration(
              prefixIcon: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              filled: true,
              fillColor: Color(0xFFF9FAFB),
              hintText: "ابحث عن موظف...",
              hintStyle: TextStyle(
                color: Color(0xFF9CA3AF),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFE5E7EB)),
              ),
            ),
          ),
          if (onFilterPressed != null || onSortingPressed != null)
            SizedBox(height: 12),
          Row(
            spacing: 8,
            children: [
              if (onFilterPressed != null)
                Expanded(
                  child: GestureDetector(
                    onTap: onFilterPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.filter,
                            color: AppColors.accent,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          AppText(
                            "حسب الحالة",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              if (onSortingPressed != null)
                Expanded(
                  child: GestureDetector(
                    onTap: onSortingPressed,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 11),
                      decoration: BoxDecoration(
                        color: Color(0xFFF9FAFB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            FontAwesomeIcons.sort,
                            color: AppColors.accent,
                            size: 14,
                          ),
                          SizedBox(width: 8),
                          AppText(
                            "ترتيب",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              height: 1.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
