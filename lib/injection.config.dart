// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:milestory_admin/core/core_export.dart' as _i263;
import 'package:milestory_admin/core/network/api_client.dart' as _i729;
import 'package:milestory_admin/core/services/token/token_manager.dart'
    as _i604;
import 'package:milestory_admin/features/audio/audio_export.dart' as _i595;
import 'package:milestory_admin/features/audio/data/datasources/audio_data_source.dart'
    as _i381;
import 'package:milestory_admin/features/audio/data/repository/audio_repository_impl.dart'
    as _i348;
import 'package:milestory_admin/features/audio/domain/usecases/get_audio_url.dart'
    as _i135;
import 'package:milestory_admin/features/audio/presentation/bloc/audio_bloc.dart'
    as _i378;
import 'package:milestory_admin/features/auth/auth_export.dart' as _i934;
import 'package:milestory_admin/features/auth/data/datasources/auth_data_source.dart'
    as _i581;
import 'package:milestory_admin/features/auth/data/repository/auth_repository_impl.dart'
    as _i301;
import 'package:milestory_admin/features/auth/domain/repository/auth_repository.dart'
    as _i4;
import 'package:milestory_admin/features/auth/domain/usecases/check_auth.dart'
    as _i218;
import 'package:milestory_admin/features/auth/domain/usecases/delete_user.dart'
    as _i128;
import 'package:milestory_admin/features/auth/domain/usecases/logout.dart'
    as _i1006;
import 'package:milestory_admin/features/auth/domain/usecases/send_password_recovery_link.dart'
    as _i212;
import 'package:milestory_admin/features/auth/domain/usecases/sign_in.dart'
    as _i531;
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart'
    as _i80;
import 'package:milestory_admin/features/creator/creator_export.dart' as _i801;
import 'package:milestory_admin/features/creator/data/datasources/creator_data_source.dart'
    as _i909;
import 'package:milestory_admin/features/creator/data/repository/creator_repository_impl.dart'
    as _i471;
import 'package:milestory_admin/features/creator/domain/usecases/creator_service.dart'
    as _i1023;
import 'package:milestory_admin/features/creator/domain/usecases/get_tour_points.dart'
    as _i871;
import 'package:milestory_admin/features/creator/presentation/creator_bloc/creator_bloc.dart'
    as _i1041;
import 'package:milestory_admin/features/creator/presentation/map/map_builders.dart'
    as _i430;
import 'package:milestory_admin/features/tour/data/datasources/tour_data_source.dart'
    as _i668;
import 'package:milestory_admin/features/tour/data/repository/tour_repository_impl.dart'
    as _i64;
import 'package:milestory_admin/features/tour/domain/usecases/get_tours.dart'
    as _i120;
import 'package:milestory_admin/features/tour/presentation/bloc/tour_bloc.dart'
    as _i867;
import 'package:milestory_admin/features/tour/tour_export.dart' as _i213;
import 'package:milestory_admin/features/user_management/data/datasources/users_data_source.dart'
    as _i701;
import 'package:milestory_admin/features/user_management/data/repository/users_repository_impl.dart'
    as _i702;
import 'package:milestory_admin/features/user_management/domain/repository/users_repository.dart'
    as _i703;
import 'package:milestory_admin/features/user_management/domain/usecases/get_users.dart'
    as _i704;
import 'package:milestory_admin/features/user_management/presentation/bloc/users_bloc.dart'
    as _i705;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i1023.CreatorService>(() => _i1023.CreatorService());
    gh.lazySingleton<_i430.MapBuilders>(() => _i430.MapBuilders());
    gh.lazySingleton<_i604.TokenManager>(
      () => _i604.TokenManager(gh<_i361.Dio>(), gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i729.ApiClient>(
      () => _i729.ApiClient(gh<_i361.Dio>(), gh<_i263.TokenManager>()),
    );
    gh.lazySingleton<_i581.AuthDataSource>(
      () => _i581.AuthDataSourceImpl(
        gh<_i263.ApiClient>(),
        gh<_i263.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i381.AudioDataSource>(
      () => _i381.AudioDataSourceImpl(gh<_i263.ApiClient>()),
    );
    gh.lazySingleton<_i668.TourDataSource>(
      () => _i668.TourDataSourceImpl(gh<_i263.ApiClient>()),
    );
    gh.lazySingleton<_i909.CreatorDataSource>(
      () => _i909.CreatorDataSourceImpl(gh<_i263.ApiClient>()),
    );
    gh.singleton<_i595.AudioRepository>(
      () => _i348.AudioRepositoryImpl(
        audioDataSource: gh<_i595.AudioDataSource>(),
      ),
    );
    gh.lazySingleton<_i934.AuthRepository>(
      () =>
          _i301.AuthRepositoryImpl(authDataSource: gh<_i934.AuthDataSource>()),
    );
    gh.lazySingleton<_i218.CheckAuth>(
      () => _i218.CheckAuth(gh<_i4.AuthRepository>()),
    );
    gh.lazySingleton<_i128.DeleteUser>(
      () => _i128.DeleteUser(gh<_i4.AuthRepository>()),
    );
    gh.lazySingleton<_i1006.Logout>(
      () => _i1006.Logout(gh<_i4.AuthRepository>()),
    );
    gh.lazySingleton<_i212.SendPasswordRecoveryLink>(
      () => _i212.SendPasswordRecoveryLink(gh<_i4.AuthRepository>()),
    );
    gh.lazySingleton<_i531.SignIn>(
      () => _i531.SignIn(gh<_i4.AuthRepository>()),
    );
    gh.lazySingleton<_i801.CreatorRepository>(
      () => _i471.CreatorRepositoryImpl(
        creatorDataSource: gh<_i801.CreatorDataSource>(),
      ),
    );
    gh.factory<_i80.AuthBloc>(
      () => _i80.AuthBloc(
        signIn: gh<_i934.SignIn>(),
        logout: gh<_i934.Logout>(),
        checkAuth: gh<_i934.CheckAuth>(),
        sendPasswordRecoveryLink: gh<_i934.SendPasswordRecoveryLink>(),
        deleteUser: gh<_i934.DeleteUser>(),
      ),
    );
    gh.factory<_i135.GetAudioUrl>(
      () => _i135.GetAudioUrl(gh<_i595.AudioRepository>()),
    );
    gh.lazySingleton<_i213.TourRepository>(
      () => _i64.TourRepositoryImpl(tourDataSource: gh<_i213.TourDataSource>()),
    );
    gh.lazySingleton<_i871.GetTourPoints>(
      () => _i871.GetTourPoints(gh<_i801.CreatorRepository>()),
    );
    gh.factory<_i378.AudioBloc>(
      () => _i378.AudioBloc(getAudioUrl: gh<_i595.GetAudioUrl>()),
    );
    gh.factory<_i1041.CreatorBloc>(
      () => _i1041.CreatorBloc(
        getTourPoints: gh<_i801.GetTourPoints>(),
        mapBuilders: gh<_i801.MapBuilders>(),
      ),
    );
    gh.lazySingleton<_i120.GetTours>(
      () => _i120.GetTours(gh<_i213.TourRepository>()),
    );
    gh.factory<_i867.TourBloc>(
      () => _i867.TourBloc(getTours: gh<_i213.GetTours>()),
    );
    gh.lazySingleton<_i701.UsersDataSource>(
      () => _i701.UsersDataSourceImpl(gh<_i263.ApiClient>()),
    );
    gh.lazySingleton<_i703.UsersRepository>(
      () => _i702.UsersRepositoryImpl(gh<_i701.UsersDataSource>()),
    );
    gh.lazySingleton<_i704.GetUsers>(
      () => _i704.GetUsers(gh<_i703.UsersRepository>()),
    );
    gh.factory<_i705.UsersBloc>(
      () => _i705.UsersBloc(
        getUsers: gh<_i704.GetUsers>(),
        repository: gh<_i703.UsersRepository>(),
      ),
    );
    return this;
  }
}
