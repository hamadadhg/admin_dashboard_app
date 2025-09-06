// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

import '../../common/dio_helper.dart' as _i725;
import '../../common/logger_interceptor.dart' as _i589;
import '../../features/category_products/data/data_sources/category_products_remote_data_source.dart'
    as _i368;
import '../../features/category_products/data/repositories/category_products_repo_impl.dart'
    as _i664;
import '../../features/category_products/domain/repositories/category_products_repo.dart'
    as _i759;
import '../../features/category_products/domain/use_cases/fetch_category_products_use_case.dart'
    as _i114;
import '../../features/category_products/presentation/manager/bloc/category_products_bloc.dart'
    as _i554;
import '../../features/orders/data/data_sources/orders_remote_data_source.dart'
    as _i310;
import '../../features/orders/data/repositories/orders_repo_impl.dart' as _i813;
import '../../features/orders/domain/repositories/orders_repo.dart' as _i509;
import '../../features/orders/domain/use_cases/fetch_order_details_use_case.dart'
    as _i494;
import '../../features/orders/domain/use_cases/fetch_orders_use_case.dart'
    as _i908;
import '../../features/orders/presentation/manager/bloc/orders_bloc.dart'
    as _i6;
import 'injection.dart' as _i464;

// initializes the registration of main-scope dependencies inside of GetIt
_i174.GetIt $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final injectableModule = _$InjectableModule();
  gh.singleton<_i725.DioNetwork>(() => injectableModule.dio);
  gh.lazySingleton<_i589.LoggerInterceptor>(() => _i589.LoggerInterceptor());
  gh.lazySingleton<_i368.CategoryProductsRemoteDataSource>(() =>
      _i368.CategoryProductsRemoteDataSource(
          dioNetwork: gh<_i725.DioNetwork>()));
  gh.lazySingleton<_i310.OrdersRemoteDataSource>(
      () => _i310.OrdersRemoteDataSource(dioNetwork: gh<_i725.DioNetwork>()));
  gh.lazySingleton<_i509.OrdersRepo>(() => _i813.OrdersRepoImpl(
      ordersRemoteDataSource: gh<_i310.OrdersRemoteDataSource>()));
  gh.lazySingleton<_i908.FetchOrdersUseCase>(
      () => _i908.FetchOrdersUseCase(ordersRepo: gh<_i509.OrdersRepo>()));
  gh.lazySingleton<_i494.FetchOrderDetailsUseCase>(
      () => _i494.FetchOrderDetailsUseCase(ordersRepo: gh<_i509.OrdersRepo>()));
  gh.lazySingleton<_i759.CategoryProductsRepo>(() =>
      _i664.CategoryProductsRepoImpl(
          categoryProductsRemoteDataSource:
              gh<_i368.CategoryProductsRemoteDataSource>()));
  gh.lazySingleton<_i114.FetchCategoryProductsUseCase>(() =>
      _i114.FetchCategoryProductsUseCase(
          categoryProductsRepo: gh<_i759.CategoryProductsRepo>()));
  gh.factory<_i6.OrdersBloc>(() => _i6.OrdersBloc(
        gh<_i908.FetchOrdersUseCase>(),
        gh<_i494.FetchOrderDetailsUseCase>(),
      ));
  gh.factory<_i554.CategoryProductsBloc>(() =>
      _i554.CategoryProductsBloc(gh<_i114.FetchCategoryProductsUseCase>()));
  return getIt;
}

class _$InjectableModule extends _i464.InjectableModule {}
