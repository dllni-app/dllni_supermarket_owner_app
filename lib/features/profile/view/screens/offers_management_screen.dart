import 'package:common_package/common_package.dart';
import 'package:dllni_supermarket_owner_app/features/profile/data/models/get_offer_codes_model.dart';
import 'package:dllni_supermarket_owner_app/features/profile/domain/usecases/get_offers_weekly_summary_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:toastification/toastification.dart';
import 'package:common_package/helpers/dio_network.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/services/store_owner_operations_service.dart';
import '../../../../core/widgets/app_app_bars.dart';
import '../../../../core/widgets/failure_widget.dart';
import '../../domain/usecases/get_offer_codes_use_case.dart';
import '../manager/bloc/profile_bloc.dart';
import '../widgets/coupons_filter_card.dart';
import '../widgets/offer_card.dart';
import '../widgets/promotion_edit_dialogs.dart';
import '../widgets/offers_statistics_grid.dart';
import 'create_offer_screen.dart';

@AutoRoutePage(path: "/offers_management")
class OffersManagementScreen extends StatefulWidget {
  const OffersManagementScreen({super.key});

  @override
  State<OffersManagementScreen> createState() => _OffersManagementScreenState();
}

class _OffersManagementScreenState extends State<OffersManagementScreen> {
  String? search, sort;
  int selectedTab = 0;
  List<int> selectedProductIds = [];

  StoreOwnerOperationsService get _operations =>
      StoreOwnerOperationsService(getIt<DioNetwork>());

  void _reloadOffers(BuildContext context) {
    context.read<ProfileBloc>().add(
      GetOfferCodesEvent(
        isReload: true,
        params: GetOfferCodesParams(
          storeId: 1,
          search: search,
          isActive: selectedTab == 1
              ? true
              : selectedTab == 2
              ? false
              : null,
        ),
      ),
    );
    context.read<ProfileBloc>().add(
      GetOffersWeeklySummaryEvent(
        params: GetOffersWeeklySummaryParams(storeId: 1),
      ),
    );
  }

  Future<void> _editOffer(
    BuildContext context,
    GetOfferCodesModelDataItem offer,
  ) async {
    final id = offer.id;
    if (id == null) return;
    final body = await showOfferEditDialog(context, offer);
    if (body == null || !context.mounted) return;
    await _runOfferAction(
      context,
      () => _operations.updateOffer(offerId: id, body: body),
      'تم تحديث العرض',
    );
  }

  Future<void> _toggleOffer(
    BuildContext context,
    GetOfferCodesModelDataItem offer,
  ) async {
    final id = offer.id;
    if (id == null) return;
    final active = !(offer.isActive ?? false);
    await _runOfferAction(
      context,
      () => _operations.updateOffer(
        offerId: id,
        body: {'isActive': active},
      ),
      active ? 'تم تفعيل العرض' : 'تم تعطيل العرض',
    );
  }

  Future<void> _deleteOffer(
    BuildContext context,
    GetOfferCodesModelDataItem offer,
  ) async {
    final id = offer.id;
    if (id == null) return;
    final confirmed = await _confirmDelete(
      context,
      'حذف العرض',
      'هل تريد حذف العرض «${offer.name ?? ''}» نهائيًا؟',
    );
    if (!confirmed || !context.mounted) return;
    await _runOfferAction(
      context,
      () => _operations.deleteOffer(id),
      'تم حذف العرض',
    );
  }

  Future<void> _runOfferAction(
    BuildContext context,
    Future<Map<String, dynamic>> Function() action,
    String successMessage,
  ) async {
    try {
      await action();
      if (!context.mounted) return;
      AppToast.showToast(
        context: context,
        message: successMessage,
        type: ToastificationType.success,
      );
      _reloadOffers(context);
    } on StoreOwnerOperationException catch (error) {
      if (!context.mounted) return;
      AppToast.showToast(
        context: context,
        message: error.message,
        type: ToastificationType.error,
      );
    }
  }

  Future<bool> _confirmDelete(
    BuildContext context,
    String title,
    String message,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (dialogContext) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: const Text('إلغاء'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: const Text('حذف'),
              ),
            ],
          ),
        ) ??
        false;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<ProfileBloc>()
          ..add(
            GetOffersWeeklySummaryEvent(
              params: GetOffersWeeklySummaryParams(storeId: 1),
            ),
          )
          ..add(GetOfferCodesEvent(params: GetOfferCodesParams(storeId: 1))),
        child: Column(
          children: [
            AppSimpleAppBar(title: "إدارة العروض"),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                return Padding(
                  padding: EdgeInsetsDirectional.symmetric(horizontal: 24),
                  child: InkWell(
                    onTap: () {
                      // context.pushRoute("/create_offer");
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider.value(
                            value: context.read<ProfileBloc>(),
                            child: CreateOfferScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: context.primaryContainer,
                      ),
                      width: context.width,
                      padding: EdgeInsetsDirectional.symmetric(vertical: 11),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_circle,
                            color: context.onPrimaryContainer,
                            size: 22,
                          ),
                          SizedBox(width: 8),
                          AppText.labelLarge(
                            'إنشاء عرض جديد',
                            color: context.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 16),
            OffersStatisticsGrid(),
            SizedBox(height: 16),
            Builder(
              builder: (context) {
                return CouponsFilterCard(
                  onSortChanged: (sort) {
                    this.sort = sort;
                    context.read<ProfileBloc>().add(
                      GetOfferCodesEvent(
                        isReload: true,
                        params: GetOfferCodesParams(
                          storeId: 1,
                          search: search,
                          sort: sort,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                  onSearchChanged: (value) {
                    search = value;
                    context.read<ProfileBloc>().add(
                      GetOfferCodesEvent(
                        isReload: true,
                        params: GetOfferCodesParams(
                          storeId: 1,
                          search: search,
                          sort: sort,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                  onTabChanged: (index) {
                    selectedTab = index;
                    context.read<ProfileBloc>().add(
                      GetOfferCodesEvent(
                        isReload: true,
                        params: GetOfferCodesParams(
                          storeId: 1,
                          search: search,
                          isActive: selectedTab == 1
                              ? true
                              : selectedTab == 2
                              ? false
                              : null,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProfileBloc, ProfileState>(
                buildWhen: (previous, current) =>
                    previous.offerCodes != current.offerCodes,
                builder: (context, state) {
                  return state.offerCodes!.builder(
                    loadingWidget: OffersLoading(),
                    emptyWidget: Center(
                      child: AppText.labelMedium(
                        'لا يوجد عروض',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    successWidget: () {
                      return ListView.separated(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 24,
                          vertical: 8,
                        ),
                        itemBuilder: (context, index) {
                          print(state.offerCodes?.length);
                          if (state.offerCodes!.length <= index) {
                            if (state.offerCodes!.length == index) {
                              context.read<ProfileBloc>().add(
                                GetOfferCodesEvent(
                                  params: GetOfferCodesParams(
                                    storeId: 1,
                                    page: state.offerCodes!.pageNumber,
                                    search: search,
                                    isActive: selectedTab == 1
                                        ? true
                                        : selectedTab == 2
                                        ? false
                                        : null,
                                  ),
                                ),
                              );
                            }
                            return Shimmer.fromColors(
                              baseColor: Color(0xFFE0E0E0),
                              highlightColor: Color(0xFFCCCCCC),
                              child: Container(
                                width: double.infinity,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }
                          // a expired coupon
                          if (selectedTab == 3 &&
                              (DateTime.tryParse(
                                            state.offerCodes![index].endsAt ??
                                                "",
                                          ) ??
                                          DateTime.now())
                                      .difference(DateTime.now())
                                      .inMilliseconds >
                                  0) {
                            return SizedBox();
                          }
                          final offer = state.offerCodes![index];
                          return OfferCard(
                            offer: offer,
                            onEdit: () => _editOffer(context, offer),
                            onToggle: () => _toggleOffer(context, offer),
                            onDelete: () => _deleteOffer(context, offer),
                          );
                        },
                        separatorBuilder: (context, index) {
                          // a expired coupon
                          if (selectedTab == 3 &&
                              (DateTime.tryParse(
                                            state.offerCodes![index].endsAt ??
                                                "",
                                          ) ??
                                          DateTime.now())
                                      .difference(DateTime.now())
                                      .inMilliseconds >
                                  0) {
                            return SizedBox();
                          }
                          return SizedBox(height: 16);
                        },
                        itemCount: state.offerCodes!.listLength(1),
                      );
                    },
                    failedWidget: FailureWidget(
                      message: state.errorMessage ?? "Unknown Error",
                      onRetry: () {
                        context.read<ProfileBloc>().add(
                          GetOfferCodesEvent(
                            isReload: true,
                            params: GetOfferCodesParams(
                              storeId: 1,
                              search: search,
                              isActive: selectedTab == 1
                                  ? true
                                  : selectedTab == 2
                                  ? false
                                  : null,
                            ),
                          ),
                        );
                      },
                    ),
                    onTapRetry: () {
                      context.read<ProfileBloc>().add(
                        GetOfferCodesEvent(
                          isReload: true,
                          params: GetOfferCodesParams(
                            storeId: 1,
                            search: search,
                            isActive: selectedTab == 1
                                ? true
                                : selectedTab == 2
                                ? false
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OffersLoading extends StatelessWidget {
  const OffersLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: ListView.separated(
        padding: EdgeInsetsDirectional.only(start: 24, end: 24, bottom: 20),
        itemBuilder: (context, index) => OfferCard(
          offer: GetOfferCodesModelDataItem.fromJson({
            "id": 2,
            "storeId": 1,
            "name": "خصم 15% على المعكرونة",
            "description": null,
            "offerType": "percentage",
            "discountValue": null,
            "discountPercent": 15,
            "startsAt": null,
            "endsAt": "2027-03-15 22:22:00",
            "isActive": true,
            "createdAt": "2026-03-15 22:22:00",
            "updatedAt": "2026-03-15 22:22:00",
          }),
        ),
        separatorBuilder: (context, index) => SizedBox(height: 16),
        itemCount: 2,
      ),
    );
  }
}
