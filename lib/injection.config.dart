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
import 'package:milestory_admin/core/core_export.dart' as _i937;
import 'package:milestory_admin/core/network/api_client.dart' as _i415;
import 'package:milestory_admin/core/services/image/image_service_impl.dart'
    as _i557;
import 'package:milestory_admin/core/services/token/token_manager.dart' as _i349;
import 'package:milestory_admin/features/audio/audio_export.dart' as _i242;
import 'package:milestory_admin/features/audio/data/datasources/audio_data_source.dart'
    as _i281;
import 'package:milestory_admin/features/audio/data/repository/audio_repository_impl.dart'
    as _i199;
import 'package:milestory_admin/features/audio/domain/usecases/get_audio_url.dart'
    as _i368;
import 'package:milestory_admin/features/audio/presentation/bloc/audio_bloc.dart'
    as _i513;
import 'package:milestory_admin/features/auth/auth_export.dart' as _i290;
import 'package:milestory_admin/features/auth/data/datasources/auth_data_source.dart'
    as _i359;
import 'package:milestory_admin/features/auth/data/repository/auth_repository_impl.dart'
    as _i721;
import 'package:milestory_admin/features/auth/domain/repository/auth_repository.dart'
    as _i55;
import 'package:milestory_admin/features/auth/domain/usecases/check_auth.dart'
    as _i580;
import 'package:milestory_admin/features/auth/domain/usecases/delete_user.dart'
    as _i551;
import 'package:milestory_admin/features/auth/domain/usecases/logout.dart'
    as _i717;
import 'package:milestory_admin/features/auth/domain/usecases/send_password_recovery_link.dart'
    as _i658;
import 'package:milestory_admin/features/auth/domain/usecases/sign_in.dart'
    as _i142;
import 'package:milestory_admin/features/auth/presentation/auth_bloc/auth_bloc.dart'
    as _i732;
import 'package:milestory_admin/features/creator/creator_export.dart' as _i911;
import 'package:milestory_admin/features/creator/data/datasources/creator_data_source.dart'
    as _i730;
import 'package:milestory_admin/features/creator/data/repository/creator_repository_impl.dart'
    as _i289;
import 'package:milestory_admin/features/creator/domain/usecases/creator_service.dart'
    as _i681;
import 'package:milestory_admin/features/creator/domain/usecases/get_tour_points.dart'
    as _i286;
import 'package:milestory_admin/features/creator/presentation/creator_bloc/creator_bloc.dart'
    as _i772;
import 'package:milestory_admin/features/creator/presentation/map/map_builders.dart'
    as _i399;
import 'package:milestory_admin/features/guide_user/data/datasources/guide_user_data_source.dart'
    as _i515;
import 'package:milestory_admin/features/guide_user/data/repository/guide_user_repository_impl.dart'
    as _i300;
import 'package:milestory_admin/features/guide_user/domain/usecases/get_guide_user.dart'
    as _i127;
import 'package:milestory_admin/features/guide_user/domain/usecases/mark_onboarding_seen.dart'
    as _i145;
import 'package:milestory_admin/features/guide_user/domain/usecases/update_guide_user.dart'
    as _i656;
import 'package:milestory_admin/features/guide_user/guide_user_export.dart'
    as _i1;
import 'package:milestory_admin/features/guide_user/presentation/guide_user_bloc/guide_user_bloc.dart'
    as _i315;
import 'package:milestory_admin/features/tour/data/datasources/tour_data_source.dart'
    as _i497;
import 'package:milestory_admin/features/tour/data/repository/tour_repository_impl.dart'
    as _i737;
import 'package:milestory_admin/features/tour/domain/usecases/get_tours.dart'
    as _i752;
import 'package:milestory_admin/features/tour/presentation/bloc/tour_bloc.dart'
    as _i42;
import 'package:milestory_admin/features/tour/tour_export.dart' as _i366;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    gh.lazySingleton<_i681.CreatorService>(() => _i681.CreatorService());
    gh.lazySingleton<_i399.MapBuilders>(() => _i399.MapBuilders());
    gh.lazySingleton<_i349.TokenManager>(
      () => _i349.TokenManager(gh<_i361.Dio>(), gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i415.ApiClient>(
      () => _i415.ApiClient(gh<_i361.Dio>(), gh<_i937.TokenManager>()),
    );
    gh.lazySingleton<_i730.CreatorDataSource>(
      () => _i730.CreatorDataSourceImpl(gh<_i937.ApiClient>()),
    );
    gh.lazySingleton<_i515.GuideUserDataSource>(
      () => _i515.GuideUserDataSourceImpl(gh<_i937.ApiClient>()),
    );
    gh.lazySingleton<_i281.AudioDataSource>(
      () => _i281.AudioDataSourceImpl(gh<_i937.ApiClient>()),
    );
    gh.lazySingleton<_i1.GuideUserRepository>(
      () => _i300.GuideUserRepositoryImpl(
        guideUserDataSource: gh<_i1.GuideUserDataSource>(),
      ),
    );
    gh.singleton<_i242.AudioRepository>(
      () => _i199.AudioRepositoryImpl(
        audioDataSource: gh<_i242.AudioDataSource>(),
      ),
    );
    gh.lazySingleton<_i127.GetGuideUser>(
      () => _i127.GetGuideUser(gh<_i1.GuideUserRepository>()),
    );
    gh.lazySingleton<_i145.MarkOnboardingSeen>(
      () => _i145.MarkOnboardingSeen(gh<_i1.GuideUserRepository>()),
    );
    gh.lazySingleton<_i497.TourDataSource>(
      () => _i497.TourDataSourceImpl(gh<_i937.ApiClient>()),
    );
    gh.lazySingleton<_i359.AuthDataSource>(
      () => _i359.AuthDataSourceImpl(
        gh<_i937.ApiClient>(),
        gh<_i937.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i937.ImageService>(
      () => _i557.ImageServiceImpl(gh<_i937.ApiClient>()),
    );
    gh.lazySingleton<_i656.UpdateGuideUser>(
      () => _i656.UpdateGuideUser(
        gh<_i1.GuideUserRepository>(),
        gh<_i937.ImageService>(),
      ),
    );
    gh.lazySingleton<_i911.CreatorRepository>(
      () => _i289.CreatorRepositoryImpl(
        creatorDataSource: gh<_i911.CreatorDataSource>(),
      ),
    );
    gh.lazySingleton<_i286.GetTourPoints>(
      () => _i286.GetTourPoints(gh<_i911.CreatorRepository>()),
    );
    gh.factory<_i368.GetAudioUrl>(
      () => _i368.GetAudioUrl(gh<_i242.AudioRepository>()),
    );
    gh.factory<_i513.AudioBloc>(
      () => _i513.AudioBloc(getAudioUrl: gh<_i242.GetAudioUrl>()),
    );
    gh.factory<_i315.GuideUserBloc>(
      () => _i315.GuideUserBloc(
        updateGuideUser: gh<_i1.UpdateGuideUser>(),
        getGuideUser: gh<_i1.GetGuideUser>(),
        markOnboardingSeen: gh<_i1.MarkOnboardingSeen>(),
      ),
    );
    gh.lazySingleton<_i290.AuthRepository>(
      () =>
          _i721.AuthRepositoryImpl(authDataSource: gh<_i290.AuthDataSource>()),
    );
    gh.factory<_i772.CreatorBloc>(
      () => _i772.CreatorBloc(
        getTourPoints: gh<_i911.GetTourPoints>(),
        mapBuilders: gh<_i911.MapBuilders>(),
      ),
    );
    gh.lazySingleton<_i580.CheckAuth>(
      () => _i580.CheckAuth(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i551.DeleteUser>(
      () => _i551.DeleteUser(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i717.Logout>(
      () => _i717.Logout(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i658.SendPasswordRecoveryLink>(
      () => _i658.SendPasswordRecoveryLink(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i142.SignIn>(
      () => _i142.SignIn(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i366.TourRepository>(
      () =>
          _i737.TourRepositoryImpl(tourDataSource: gh<_i366.TourDataSource>()),
    );
    gh.lazySingleton<_i752.GetTours>(
      () => _i752.GetTours(gh<_i366.TourRepository>()),
    );
    gh.factory<_i732.AuthBloc>(
      () => _i732.AuthBloc(
        signIn: gh<_i290.SignIn>(),
        logout: gh<_i290.Logout>(),
        checkAuth: gh<_i290.CheckAuth>(),
        sendPasswordRecoveryLink: gh<_i290.SendPasswordRecoveryLink>(),
        deleteUser: gh<_i290.DeleteUser>(),
      ),
    );
    gh.factory<_i42.TourBloc>(
      () => _i42.TourBloc(
        getTours: gh<_i366.GetTours>(),
      ),
    );
    return this;
  }
}
