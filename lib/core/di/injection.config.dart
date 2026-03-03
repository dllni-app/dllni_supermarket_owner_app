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
import '../../features/home/view/manager/bloc/home_bloc.dart' as _i648;
import '../../features/orders/data/repository/orders_repo_impl.dart' as _i849;
import '../../features/orders/data/source/orders_remote_data_source.dart'
    as _i702;
import '../../features/orders/domain/repository/orders_repo.dart' as _i132;
import '../../features/orders/view/manager/bloc/orders_bloc.dart' as _i305;
import '../../features/products/data/repository/products_repo_impl.dart'
    as _i99;
import '../../features/products/data/source/products_remote_data_source.dart'
    as _i811;
import '../../features/products/domain/repository/products_repo.dart' as _i466;
import '../../features/products/domain/usecases/get_categories_use_case.dart'
    as _i862;
import '../../features/products/domain/usecases/get_low_stock_use_case.dart'
    as _i348;
import '../../features/products/domain/usecases/get_products_use_case.dart'
    as _i846;
import '../../features/products/view/manager/bloc/products_bloc.dart' as _i113;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(getIt, environment, environmentFilter);
  final injectableModule = _$InjectableModule();
  gh.factory<_i648.HomeBloc>(() => _i648.HomeBloc());
  gh.factory<_i305.OrdersBloc>(() => _i305.OrdersBloc());
  gh.singleton<_i960.DioNetwork>(() => injectableModule.dio);
  gh.lazySingleton<_i702.OrdersRemoteDataSource>(
    () => _i702.OrdersRemoteDataSource(),
  );
  gh.lazySingleton<_i132.OrdersRepo>(() => _i849.OrdersRepoImpl());
  gh.lazySingleton<_i777.AuthRemoteDataSource>(
    () => _i777.AuthRemoteDataSource(dioNetwork: gh<_i497.DioNetwork>()),
  );
  gh.lazySingleton<_i811.ProductsRemoteDataSource>(
    () => _i811.ProductsRemoteDataSource(dioNetwork: gh<_i960.DioNetwork>()),
  );
  gh.lazySingleton<_i466.ProductsRepo>(
    () => _i99.ProductsRepoImpl(
      productsRemoteDataSource: gh<_i811.ProductsRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i862.GetCategoriesUseCase>(
    () => _i862.GetCategoriesUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i348.GetLowStockUseCase>(
    () => _i348.GetLowStockUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i846.GetProductsUseCase>(
    () => _i846.GetProductsUseCase(products: gh<_i466.ProductsRepo>()),
  );
  gh.lazySingleton<_i976.AuthRepo>(
    () => _i751.AuthRepoImpl(
      authRemoteDataSource: gh<_i777.AuthRemoteDataSource>(),
    ),
  );
  gh.lazySingleton<_i37.LoginUseCase>(
    () => _i37.LoginUseCase(auth: gh<_i976.AuthRepo>()),
  );
  gh.factory<_i958.AuthBloc>(() => _i958.AuthBloc(gh<_i37.LoginUseCase>()));
  gh.factory<_i113.ProductsBloc>(
    () => _i113.ProductsBloc(
      gh<_i846.GetProductsUseCase>(),
      gh<_i862.GetCategoriesUseCase>(),
      gh<_i348.GetLowStockUseCase>(),
    ),
  );
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
