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
        padding: const EdgeInsets.all(16),
        itemCount: 3,
        separatorBuilder: (_, _) => const SizedBox(height: 13),
        itemBuilder: (_, _) => Container(
          height: 270,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

@AutoRoutePage(path: '/profile/employees')
class EmployeeManagementScreen extends StatefulWidget {
  const EmployeeManagementScreen({super.key});

  @override
  State<EmployeeManagementScreen> createState() =>
      _EmployeeManagementScreenState();
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
            AppSimpleAppBar(title: 'إدارة الموظفين'),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: context.width,
                    child: Builder(
                      builder: (context) => BigButtonWithIcon(
                        icon: AppImage.asset(AppSvgs.add, size: 22),
                        title: 'إضافة موظف جديد',
                        onPressed: () async {
                          final refresh = await context.pushRoute(
                            '/profile/employees/create_employee',
                          );
                          if (refresh is! bool ||
                              !refresh ||
                              !context.mounted) {
                            return;
                          }
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
                    ),
                  ),
                  const SizedBox(height: 16),
                  Builder(
                    builder: (context) => _SearchSection(
                      onSearchChanged: (value) {
                        search = value.trim().isEmpty ? null : value.trim();
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
                  ),
                  const SizedBox(height: 3),
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
                    return const EmployeeLoading();
                  }
                  if (state.storeEmployeesStatus == BlocStatus.failed) {
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
                  }
                  if (state.storeEmployeesStatus == BlocStatus.success) {
                    final employees =
                        state.storeEmployees?.data?.employees ?? const [];
                    return ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: employees.length,
                      itemBuilder: (context, index) =>
                          _EmployeeCard(employee: employees[index]),
                      separatorBuilder: (_, _) => const SizedBox(height: 13),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final GetStoreEmployeesModelDataEmployeesItem employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    final rawPhone = employee.user?.phone?.trim();
    final hasPhone =
        rawPhone != null &&
        rawPhone.isNotEmpty &&
        rawPhone.toLowerCase() != 'null';
    final phoneText = hasPhone ? rawPhone : 'لا يوجد رقم هاتف';
    final joinedAt = DateTime.tryParse(employee.createdAt ?? '');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _EmployeeAvatar(imageUrl: employee.user?.profileImageUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      employee.user?.name ?? '-',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _EmployeeStatusChip(
                          isActive: employee.isActive ?? false,
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.phone,
                          color: Color(0xFF4B5563),
                          size: 10,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            phoneText,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textDirection: hasPhone
                                ? material.TextDirection.ltr
                                : material.TextDirection.rtl,
                            style: const TextStyle(
                              color: Color(0xFF4B5563),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              height: 1.333,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.more_vert, color: Color(0xFF4B5563), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFF9FAFB),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    AppText(
                      'تاريخ الانضمام',
                      style: TextStyle(
                        color: Color(0xFF4B5563),
                        fontSize: 12,
                        height: 1.333,
                      ),
                    ),
                    const Spacer(),
                    AppText(
                      joinedAt == null
                          ? '-'
                          : DateFormat.yMMMMd('ar_SA').format(joinedAt),
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        height: 1.42,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                AppText(
                  'الصلاحيات',
                  style: TextStyle(
                    color: Color(0xFF4B5563),
                    fontSize: 12,
                    height: 1.333,
                  ),
                ),
                if (employee.effectivePermissions?.isNotEmpty ?? false)
                  ...List.generate(
                    employee.effectivePermissions!.length,
                    (index) => AppText(
                      getPermissionDetails(
                        employee.effectivePermissions![index],
                      ).title,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: context.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        height: 1.6667,
                      ),
                    ),
                  )
                else
                  AppText(
                    'لا يوجد صلاحيات محددة',
                    textAlign: TextAlign.start,
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
          const SizedBox(height: 12),
          InkWell(
            onTap: () async {
              final refresh = await context.pushRoute(
                '/profile/employees/create_employee',
                arguments: employee,
              );
              if (refresh is! bool || !refresh || !context.mounted) return;
              context.read<ProfileBloc>().add(
                GetStoreEmployeesEvent(
                  params: GetStoreEmployeesParams(storeId: 1),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: context.width,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: context.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
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
                    FontAwesomeIcons.solidEye.data,
                    size: 14,
                    color: AppColors.white,
                  ),
                  const SizedBox(width: 8),
                  AppText(
                    'تفاصيل',
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

class _EmployeeAvatar extends StatelessWidget {
  final String? imageUrl;

  const _EmployeeAvatar({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl?.trim();
    final hasImage =
        url != null && url.isNotEmpty && url.toLowerCase() != 'null';

    if (hasImage) {
      return AppImage.network(
        url,
        size: 56,
        borderRadius: BorderRadius.circular(12),
        failedBuilder: (_) => _fallback(context),
      );
    }
    return _fallback(context);
  }

  Widget _fallback(BuildContext context) {
    return Container(
      width: 56,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: context.primary.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(Icons.person_rounded, size: 30, color: context.primary),
    );
  }
}

class _EmployeeStatusChip extends StatelessWidget {
  final bool isActive;

  const _EmployeeStatusChip({required this.isActive});

  @override
  Widget build(BuildContext context) {
    final color = isActive ? const Color(0xFF10B981) : const Color(0xFFF59E0B);
    final background = isActive
        ? const Color(0x1A10B981)
        : const Color(0x1AF59E0B);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(radius: 3, backgroundColor: color),
          const SizedBox(width: 4),
          AppText(
            isActive ? 'نشط' : 'معطل',
            style: TextStyle(
              color: color,
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

class _SearchSection extends StatelessWidget {
  final void Function(String value) onSearchChanged;

  const _SearchSection({required this.onSearchChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFF3F4F6)),
        boxShadow: [AppShadows.shadow],
      ),
      child: TextField(
        style: const TextStyle(
          color: Color(0xFF111287),
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        onSubmitted: onSearchChanged,
        decoration: InputDecoration(
          prefixIcon: const Padding(
            padding: EdgeInsets.only(right: 8),
            child: Icon(Icons.search, color: Color(0xFF9CA3AF)),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 10,
          ),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          hintText: 'ابحث عن موظف...',
          hintStyle: const TextStyle(
            color: Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),
        ),
      ),
    );
  }
}
