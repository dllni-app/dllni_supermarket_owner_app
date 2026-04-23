// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:common_package/common_package.dart' as _i960;
import 'package:common_package/helpers/dio_network.dart' as _i497;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../features/auth/data/repository/auth_repo_impl.dart' as _i751;
import '../../features/auth/data/source/auth_remote_data_source.dart' as _i777;
import '../../features/auth/domain/repository/auth_repo.dart' as _i976;
import '../../features/auth/domain/usecases/login_use_case.dart' as _i37;
import '../../features/auth/view/manager/bloc/auth_bloc.dart' as _i958;
import '../../features/home/data/repository/home_repo_impl.dart' as _i1013;
import '../../features/home/data/source/home_remote_data_source.dart' as _i557;
import '../../features/home/domain/repository/home_repo.dart' as _i396;
import '../../features/home/domain/usecases/accept_order_use_case.dart'
    as _i982;
import '../../features/home/domain/usecases/fetch_notifications_use_case.dart'
    as _i204;
import '../../features/home/domain/usecases/get_daily_count_use_case.dart'
    as _i557;
import '../../features/home/domain/usecases/get_dashboard_overview_use_case.dart'
    as _i393;
import '../../features/home/domain/usecases/get_new_orders_use_case.dart'
    as _i856;
import '../../features/home/domain/usecases/get_performance_report_use_case.dart'
    as _i826;
import '../../features/home/domain/usecases/get_preparing_orders_use_case.dart'
    as _i963;
import '../../features/home/domain/usecases/make_read_all_notifications_use_case.dart'
    as _i326;
import '../../features/home/domain/usecases/reject_order_use_case.dart'
    as _i501;
import '../../features/home/view/manager/bloc/home_bloc.dart' as _i648;
import '../../features/inventory/data/repository/inventory_repo_impl.dart'
    as _i821;
import '../../features/inventory/data/source/inventory_remote_data_source.dart'
    as _i543;
import '../../features/inventory/domain/repository/inventory_repo.dart'
    as _i1071;
import '../../features/inventory/domain/usecases/get_hourly_count_use_case.dart'
    as _i767;
import '../../features/inventory/domain/usecases/get_inventory_summary_use_case.dart'
    as _i495;
import '../../features/inventory/domain/usecases/get_products_use_case.dart'
    as _i132;
import '../../features/inventory/domain/usecases/update_product_amount_use_case.dart'
    as _i169;
import '../../features/inventory/view/manager/bloc/inventory_bloc.dart'
    as _i784;
import '../../features/orders/data/repository/orders_repo_impl.dart' as _i849;
import '../../features/orders/data/source/orders_remote_data_source.dart'
    as _i702;
import '../../features/orders/domain/repository/orders_repo.dart' as _i132;
import '../../features/orders/domain/usecases/accept_order_use_case.dart'
    as _i420;
import '../../features/orders/domain/usecases/get_order_details_use_case.dart'
    as _i384;
import '../../features/orders/domain/usecases/get_orders_use_case.dart'
    as _i1013;
import '../../features/orders/domain/usecases/reject_order_use_case.dart'
    as _i194;
import '../../features/orders/view/manager/bloc/orders_bloc.dart' as _i305;
import '../../features/products/data/repository/products_repo_impl.dart'
    as _i99;
import '../../features/products/data/source/products_remote_data_source.dart'
    as _i811;
import '../../features/products/domain/repository/products_repo.dart' as _i466;
import '../../features/products/domain/usecases/add_product_use_case.dart'
    as _i363;
import '../../features/products/domain/usecases/delete_product_use_case.dart'
    as _i290;
import '../../features/products/domain/usecases/get_categories_use_case.dart'
    as _i862;
import '../../features/products/domain/usecases/get_low_stock_use_case.dart'
    as _i348;
import '../../features/products/domain/usecases/get_product_from_image_use_case.dart'
    as _i989;
import '../../features/products/domain/usecases/get_product_from_text_use_case.dart'
    as _i143;
import '../../features/products/domain/usecases/get_products_use_case.dart'
    as _i846;
import '../../features/products/domain/usecases/import_products_file_use_case.dart'
    as _i342;
import '../../features/products/domain/usecases/import_products_from_master_use_case.dart'
    as _i507;
import '../../features/products/domain/usecases/search_master_products_use_case.dart'
    as _i133;
import '../../features/products/domain/usecases/total_producst_count_use_case.dart'
    as _i119;
import '../../features/products/domain/usecases/update_product_use_case.dart'
    as _i796;
import '../../features/products/view/manager/bloc/products_bloc.dart' as _i113;
import '../../features/profile/data/repository/profile_repo_impl.dart' as _i265;
import '../../features/profile/data/source/profile_remote_data_source.dart'
    as _i502;
import '../../features/profile/domain/repository/profile_repo.dart' as _i275;
import '../../features/profile/domain/usecases/add_coupon_code_use_case.dart'
    as _i40;
import '../../features/profile/domain/usecases/add_offer_use_case.dart'
    as _i242;
import '../../features/profile/domain/usecases/add_store_hours_use_case.dart'
    as _i167;
import '../../features/profile/domain/usecases/add_update_store_employee_use_case.dart'
    as _i127;
import '../../features/profile/domain/usecases/delete_store_hours_use_case.dart'
    as _i205;
import '../../features/profile/domain/usecases/get_coupon_codes_use_case.dart'
    as _i550;
import '../../features/profile/domain/usecases/get_coupon_week_analysis_use_case.dart'
    as _i622;
import '../../features/profile/domain/usecases/get_employee_permissions_use_case.dart'
    as _i189;
import '../../features/profile/domain/usecases/get_offer_codes_use_case.dart'
    as _i290;
import '../../features/profile/domain/usecases/get_offers_weekly_summary_use_case.dart'
    as _i860;
import '../../features/profile/domain/usecases/get_products_count_use_case.dart'
    as _i14;
import '../../features/profile/domain/usecases/get_products_use_case.dart'
    as _i555;
import '../../features/profile/domain/usecases/get_store_employees_use_case.dart'
    as _i186;
import '../../features/profile/domain/usecases/get_store_hours_use_case.dart'
    as _i261;
import '../../features/profile/domain/usecases/get_store_profile_use_case.dart'
    as _i712;
import '../../features/profile/domain/usecases/update_store_data_use_case.dart'
    as _i78;
import '../../features/profile/domain/usecases/update_store_hours_use_case.dart'
    as _i624;
import '../../features/profile/view/manager/bloc/profile_bloc.dart' as _i821;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.singleton<_i960.DioNetwork>(() => injectableModule.dio);
  gh.lazySingleton<_i777.AuthRemoteDataSource>(
    () => _i777.AuthRemoteDataSource(dioNetwork: gh<_i497.DioNetwork>()),
  );
  gh.lazySingleton<_i557.HomeRemoteDataSource>(
    () => _i557.HomeRemoteDataSource(dioNetwork: gh<_i497.DioNetwork>()),
  );
  gh.lazySingleton<_i543.InventoryRemoteDataSource>(
    () => _i543.InventoryRemoteDataSource(dioNetwork: gh<_i960.DioNetwork>()),
  );
  gh.lazySingleton<_i702.OrdersRemoteDataSource>(
    () => _i702.OrdersRemoteDataSource(dioNetwork: gh<_i960.DioNetwork>()),
  );
  gh.lazySingleton<_i811.ProductsRemoteDataSource>(
    () => _i811.ProductsRemoteDataSource(dioNetwork: gh<_i960.DioNetwork>()),
  );
  gh.lazySingleton<_i502.ProfileRemoteDataSource>(
    () => _i502.ProfileRemoteDataSource(dioNetwork: gh<_i960.DioNetwork>()),
  );
  gh.lazySingleton<_i1071.InventoryRepo>(
    () => _i821.InventoryRepoImpl(
      inventoryRemoteDataSource: gh<_i543.InventoryRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i466.ProductsRepo>(
    () => _i99.ProductsRepoImpl(
      productsRemoteDataSource: gh<_i811.ProductsRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i363.AddProductUseCase>(
    () => _i363.AddProductUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i290.DeleteProductUseCase>(
    () => _i290.DeleteProductUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i862.GetCategoriesUseCase>(
    () => _i862.GetCategoriesUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i348.GetLowStockUseCase>(
    () => _i348.GetLowStockUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i989.GetProductFromImageUseCase>(
    () => _i989.GetProductFromImageUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i143.GetProductFromTextUseCase>(
    () => _i143.GetProductFromTextUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i846.GetProductsUseCase>(
    () => _i846.GetProductsUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i342.ImportProductsFileUseCase>(
    () => _i342.ImportProductsFileUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i507.ImportProductsFromMasterUseCase>(
    () => _i507.ImportProductsFromMasterUseCase(
      products: gh<_i466.ProductsRepo>(),
    ),
  );
  gh.lazySingleton<_i133.SearchMasterProductsUseCase>(
    () => _i133.SearchMasterProductsUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i119.TotalProducstCountUseCase>(
    () => _i119.TotalProducstCountUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i796.UpdateProductUseCase>(
    () => _i796.UpdateProductUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i132.OrdersRepo>(
    () => _i849.OrdersRepoImpl(
      ordersRemoteDataSource: gh<_i702.OrdersRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i976.AuthRepo>(
    () => _i751.AuthRepoImpl(
      authRemoteDataSource: gh<_i777.AuthRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i37.LoginUseCase>(
    () => _i37.LoginUseCase(auth: gh<_i976.AuthRepo>()),
  );
  gh.lazySingleton<_i396.HomeRepo>(
    () => _i1013.HomeRepoImpl(
      homeRemoteDataSource: gh<_i557.HomeRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i767.GetHourlyCountUseCase>(
    () => _i767.GetHourlyCountUseCase(inventory: gh<_i1071.InventoryRepo>()),
  );
  gh.lazySingleton<_i495.GetInventorySummaryUseCase>(
    () =>
        _i495.GetInventorySummaryUseCase(inventory: gh<_i1071.InventoryRepo>()),
  );
  gh.lazySingleton<_i132.GetProductsUseCase>(
    () => _i132.GetProductsUseCase(inventory: gh<_i1071.InventoryRepo>()),
  );
  gh.lazySingleton<_i169.UpdateProductAmountUseCase>(
    () =>
        _i169.UpdateProductAmountUseCase(inventory: gh<_i1071.InventoryRepo>()),
  );
  gh.lazySingleton<_i275.ProfileRepo>(
    () => _i265.ProfileRepoImpl(
      profileRemoteDataSource: gh<_i502.ProfileRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i420.AcceptOrderUseCase>(
    () => _i420.AcceptOrderUseCase(orders: gh<_i132.OrdersRepo>()),
  );
  gh.lazySingleton<_i384.GetOrderDetailsUseCase>(
    () => _i384.GetOrderDetailsUseCase(orders: gh<_i132.OrdersRepo>()),
  );
  gh.lazySingleton<_i1013.GetOrdersUseCase>(
    () => _i1013.GetOrdersUseCase(orders: gh<_i132.OrdersRepo>()),
  );
  gh.lazySingleton<_i194.RejectOrderUseCase>(
    () => _i194.RejectOrderUseCase(orders: gh<_i132.OrdersRepo>()),
  );
  gh.factory<_i113.ProductsBloc>(
    () => _i113.ProductsBloc(
      gh<_i846.GetProductsUseCase>(),
      gh<_i348.GetLowStockUseCase>(),
      gh<_i119.TotalProducstCountUseCase>(),
      gh<_i862.GetCategoriesUseCase>(),
      gh<_i989.GetProductFromImageUseCase>(),
      gh<_i143.GetProductFromTextUseCase>(),
      gh<_i363.AddProductUseCase>(),
      gh<_i796.UpdateProductUseCase>(),
      gh<_i342.ImportProductsFileUseCase>(),
      gh<_i133.SearchMasterProductsUseCase>(),
      gh<_i507.ImportProductsFromMasterUseCase>(),
      gh<_i290.DeleteProductUseCase>(),
    ),
  );
  gh.factory<_i784.InventoryBloc>(
    () => _i784.InventoryBloc(
      gh<_i132.GetProductsUseCase>(),
      gh<_i169.UpdateProductAmountUseCase>(),
      gh<_i767.GetHourlyCountUseCase>(),
      gh<_i495.GetInventorySummaryUseCase>(),
      gh<_i348.GetLowStockUseCase>(),
    ),
  );
  gh.factory<_i958.AuthBloc>(() => _i958.AuthBloc(gh<_i37.LoginUseCase>()));
  gh.lazySingleton<_i40.AddCouponCodeUseCase>(
    () => _i40.AddCouponCodeUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i242.AddOfferUseCase>(
    () => _i242.AddOfferUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i167.AddStoreHoursUseCase>(
    () => _i167.AddStoreHoursUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i127.AddUpdateStoreEmployeeUseCase>(
    () => _i127.AddUpdateStoreEmployeeUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i205.DeleteStoreHoursUseCase>(
    () => _i205.DeleteStoreHoursUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i550.GetCouponCodesUseCase>(
    () => _i550.GetCouponCodesUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i622.GetCouponWeekAnalysisUseCase>(
    () => _i622.GetCouponWeekAnalysisUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i189.GetEmployeePermissionsUseCase>(
    () => _i189.GetEmployeePermissionsUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i290.GetOfferCodesUseCase>(
    () => _i290.GetOfferCodesUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i860.GetOffersWeeklySummaryUseCase>(
    () => _i860.GetOffersWeeklySummaryUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i14.GetProductsCountUseCase>(
    () => _i14.GetProductsCountUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i555.GetProductsUseCase>(
    () => _i555.GetProductsUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i186.GetStoreEmployeesUseCase>(
    () => _i186.GetStoreEmployeesUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i261.GetStoreHoursUseCase>(
    () => _i261.GetStoreHoursUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i712.GetStoreProfileUseCase>(
    () => _i712.GetStoreProfileUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i78.UpdateStoreDataUseCase>(
    () => _i78.UpdateStoreDataUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i624.UpdateStoreHoursUseCase>(
    () => _i624.UpdateStoreHoursUseCase(profile: gh<_i275.ProfileRepo>()),
  );
  gh.lazySingleton<_i982.AcceptOrderUseCase>(
    () => _i982.AcceptOrderUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i204.FetchNotificationsUseCase>(
    () => _i204.FetchNotificationsUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i557.GetDailyCountUseCase>(
    () => _i557.GetDailyCountUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i393.GetDashboardOverviewUseCase>(
    () => _i393.GetDashboardOverviewUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i856.GetNewOrdersUseCase>(
    () => _i856.GetNewOrdersUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i826.GetPerformanceReportUseCase>(
    () => _i826.GetPerformanceReportUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i963.GetPreparingOrdersUseCase>(
    () => _i963.GetPreparingOrdersUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i326.MakeReadAllNotificationsUseCase>(
    () => _i326.MakeReadAllNotificationsUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.lazySingleton<_i501.RejectOrderUseCase>(
    () => _i501.RejectOrderUseCase(home: gh<_i396.HomeRepo>()),
  );
  gh.factory<_i305.OrdersBloc>(
    () => _i305.OrdersBloc(
      gh<_i1013.GetOrdersUseCase>(),
      gh<_i420.AcceptOrderUseCase>(),
      gh<_i194.RejectOrderUseCase>(),
      gh<_i384.GetOrderDetailsUseCase>(),
    ),
  );
  gh.factory<_i648.HomeBloc>(
    () => _i648.HomeBloc(
      gh<_i393.GetDashboardOverviewUseCase>(),
      gh<_i856.GetNewOrdersUseCase>(),
      gh<_i963.GetPreparingOrdersUseCase>(),
      gh<_i501.RejectOrderUseCase>(),
      gh<_i557.GetDailyCountUseCase>(),
      gh<_i982.AcceptOrderUseCase>(),
      gh<_i826.GetPerformanceReportUseCase>(),
      gh<_i204.FetchNotificationsUseCase>(),
      gh<_i326.MakeReadAllNotificationsUseCase>(),
    ),
  );
  gh.factory<_i821.ProfileBloc>(
    () => _i821.ProfileBloc(
      gh<_i712.GetStoreProfileUseCase>(),
      gh<_i78.UpdateStoreDataUseCase>(),
      gh<_i261.GetStoreHoursUseCase>(),
      gh<_i167.AddStoreHoursUseCase>(),
      gh<_i624.UpdateStoreHoursUseCase>(),
      gh<_i205.DeleteStoreHoursUseCase>(),
      gh<_i550.GetCouponCodesUseCase>(),
      gh<_i189.GetEmployeePermissionsUseCase>(),
      gh<_i860.GetOffersWeeklySummaryUseCase>(),
      gh<_i186.GetStoreEmployeesUseCase>(),
      gh<_i127.AddUpdateStoreEmployeeUseCase>(),
      gh<_i290.GetOfferCodesUseCase>(),
      gh<_i555.GetProductsUseCase>(),
      gh<_i14.GetProductsCountUseCase>(),
      gh<_i40.AddCouponCodeUseCase>(),
      gh<_i622.GetCouponWeekAnalysisUseCase>(),
      gh<_i242.AddOfferUseCase>(),
    ),
  );
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
