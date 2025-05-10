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
import 'package:milestory_crm/features/auth/domain/usecases/check_auth.dart'
    as _i580;
import 'package:milestory_crm/features/auth/domain/usecases/logout.dart'
    as _i717;
import 'package:milestory_crm/features/auth/domain/usecases/sign_in.dart'
    as _i142;
import 'package:milestory_crm/features/auth/presentation/auth_bloc/auth_bloc.dart'
    as _i732;
import 'package:milestory_crm/features/guide_application_management/data/datasources/guide_application_data_sources.dart'
    as _i641;
import 'package:milestory_crm/features/guide_application_management/data/repository/guide_application_repository_impl.dart'
    as _i49;
import 'package:milestory_crm/features/guide_application_management/domain/usecases/delete_guide_application.dart'
    as _i618;
import 'package:milestory_crm/features/guide_application_management/domain/usecases/get_guide_applications.dart'
    as _i506;
import 'package:milestory_crm/features/guide_application_management/guide_application_export.dart'
    as _i85;
import 'package:milestory_crm/features/guide_application_management/presentation/guide_application_bloc/guide_application_bloc.dart'
    as _i648;
import 'package:milestory_crm/features/user_management/data/datasources/users_data_sources.dart'
    as _i455;
import 'package:milestory_crm/features/user_management/data/repository/users_repository_impl.dart'
    as _i933;
import 'package:milestory_crm/features/user_management/domain/repository/users_repository.dart'
    as _i189;
import 'package:milestory_crm/features/user_management/domain/usecases/delete_user.dart'
    as _i188;
import 'package:milestory_crm/features/user_management/domain/usecases/get_users.dart'
    as _i353;
import 'package:milestory_crm/features/user_management/domain/usecases/logout_user.dart'
    as _i523;
import 'package:milestory_crm/features/user_management/domain/usecases/search_user.dart'
    as _i297;
import 'package:milestory_crm/features/user_management/domain/usecases/update_user.dart'
    as _i909;
import 'package:milestory_crm/features/user_management/presentation/users_bloc/users_bloc.dart'
    as _i26;
import 'package:milestory_crm/features/user_management/users_export.dart'
    as _i865;
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
    gh.lazySingleton<_i455.UsersDataSource>(
      () => _i455.UsersDataSourceImpl(
        gh<_i937.ApiClient>(),
        gh<_i937.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i865.UsersRepository>(
      () => _i933.UsersRepositoryImpl(
        usersDataSource: gh<_i865.UsersDataSource>(),
      ),
    );
    gh.lazySingleton<_i641.GuideApplicationDataSource>(
      () => _i641.UsersDataSourceImpl(
        gh<_i937.ApiClient>(),
        gh<_i937.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i359.AuthDataSource>(
      () => _i359.AuthDataSourceImpl(
        gh<_i937.ApiClient>(),
        gh<_i937.TokenManager>(),
      ),
    );
    gh.lazySingleton<_i85.GuideApplicationRepository>(
      () => _i49.GuideApplicationRepositoryImpl(
        guideApplicationDataSource: gh<_i85.GuideApplicationDataSource>(),
      ),
    );
    gh.lazySingleton<_i353.GetUsers>(
      () => _i353.GetUsers(gh<_i865.UsersRepository>()),
    );
    gh.lazySingleton<_i523.LogoutUser>(
      () => _i523.LogoutUser(gh<_i865.UsersRepository>()),
    );
    gh.lazySingleton<_i188.DeleteUser>(
      () => _i188.DeleteUser(gh<_i865.UsersRepository>()),
    );
    gh.lazySingleton<_i297.SearchUser>(
      () => _i297.SearchUser(gh<_i189.UsersRepository>()),
    );
    gh.lazySingleton<_i909.UpdateUser>(
      () => _i909.UpdateUser(gh<_i865.UsersRepository>()),
    );
    gh.lazySingleton<_i55.AuthRepository>(
      () =>
          _i721.AuthRepositoryImpl(authDataSource: gh<_i359.AuthDataSource>()),
    );
    gh.lazySingleton<_i580.CheckAuth>(
      () => _i580.CheckAuth(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i717.Logout>(
      () => _i717.Logout(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i142.SignIn>(
      () => _i142.SignIn(gh<_i55.AuthRepository>()),
    );
    gh.lazySingleton<_i618.DeleteGuideApplication>(
      () => _i618.DeleteGuideApplication(gh<_i85.GuideApplicationRepository>()),
    );
    gh.lazySingleton<_i506.GetGuideApplications>(
      () => _i506.GetGuideApplications(gh<_i85.GuideApplicationRepository>()),
    );
    gh.factory<_i26.UsersBloc>(
      () => _i26.UsersBloc(
        getUsers: gh<_i865.GetUsers>(),
        updateUser: gh<_i865.UpdateUser>(),
        deleteUser: gh<_i865.DeleteUser>(),
        logoutUser: gh<_i865.LogoutUser>(),
        searchUser: gh<_i865.SearchUser>(),
      ),
    );
    gh.factory<_i732.AuthBloc>(
      () => _i732.AuthBloc(
        signIn: gh<_i290.SignIn>(),
        checkAuth: gh<_i290.CheckAuth>(),
        logout: gh<_i290.Logout>(),
      ),
    );
    gh.factory<_i648.GuideApplicationBloc>(
      () => _i648.GuideApplicationBloc(
        getGuideApplications: gh<_i85.GetGuideApplications>(),
        deleteGuideApplication: gh<_i85.DeleteGuideApplication>(),
      ),
    );
    return this;
  }
}
