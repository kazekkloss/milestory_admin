// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:milestory_crm/core/core_export.dart' as _i937;
import 'package:milestory_crm/core/network/api_client.dart' as _i415;
import 'package:milestory_crm/core/services/token/token_manager.dart' as _i349;
import 'package:milestory_crm/features/auth/auth_export.dart' as _i290;
import 'package:milestory_crm/features/auth/data/datasources/auth_data_source.dart'
    as _i359;
import 'package:milestory_crm/features/auth/data/repository/auth_repository_impl.dart'
    as _i721;
import 'package:milestory_crm/features/auth/domain/repository/auth_repository.dart'
    as _i55;
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart'
    as _i732;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i349.TokenManager>(
      () => _i349.TokenManager(gh<_i361.Dio>(), gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i415.ApiClient>(
      () => _i415.ApiClient(gh<_i361.Dio>(), gh<_i937.TokenManager>()),
    );
    gh.lazySingleton<_i359.AuthDataSource>(
      () => _i359.AuthDataSourceImpl(
        gh<_i937.ApiClient>(),
        gh<_i937.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i55.AuthRepository>(
      () =>
          _i721.AuthRepositoryImpl(authDataSource: gh<_i359.AuthDataSource>()),
    );
    gh.factory<_i732.AuthBloc>(
      () => _i732.AuthBloc(authRepository: gh<_i290.AuthRepository>()),
    );
    return this;
  }
}
