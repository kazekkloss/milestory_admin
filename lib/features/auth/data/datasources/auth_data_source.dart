import 'package:injectable/injectable.dart';
import 'package:milestory_crm/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/core_export.dart';

abstract class AuthDataSource {
  Future<DataState<UserModel>> signUp({required String email, required String password});
  Future<DataState<UserModel>> signIn({required String email, required String password});
  Future<DataState<UserModel>> checkAuth();
  Future<DataState> logout();
}

@LazySingleton(as: AuthDataSource)
class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient apiClient;
  final TokenManager tokenManager;

  AuthDataSourceImpl(this.apiClient, this.tokenManager);

    Future<void> _saveTokens(Map<String, dynamic> responseData) async {
    final accessToken = responseData['accessToken'] as String?;
    final refreshToken = responseData['refreshToken'] as String?;

    if (accessToken == null || refreshToken == null) {
      throw const AppError(message: "Invalid token response from server");
    }

    print("NEW ACCESS TOKEN: $accessToken");
    print("NEW REFRESH TOKEN: $refreshToken");

    await tokenManager.setAccessToken(accessToken);
    await tokenManager.setRefreshToken(refreshToken);
  }

  @override
  Future<DataState<UserModel>> signUp({required String email, required String password}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.signUp,
        method: RequestMethod.post,
        data: {'email': email, 'password': password},
      );
      if (response is DataSuccess) {
        final userModel = UserModel.fromJson(response.data);
        return DataSuccess(userModel);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState<UserModel>> signIn({required String email, required String password}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.signIn,
        method: RequestMethod.post,
        data: {'email': email, 'password': password},
      );

      if (response is DataSuccess) {
        await _saveTokens(response.data);
        final userData = response.data['user'] as Map<String, dynamic>?;

        final userModel = UserModel.fromJson(userData!);

        print("Sign-In successful: ${userModel.email}");
        return DataSuccess(userModel);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }

  @override
  Future<DataState<UserModel>> checkAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token == null || token.isEmpty) {
        return const DataFailed(AppError(message: 'Token is missing'));
      }

      final response = await apiClient.request(
        url: ApiConstants.checkAuth,
        method: RequestMethod.get,
      );

      if (response is DataSuccess) {
        final userModel = UserModel.fromJson(response.data);
        return DataSuccess(userModel);
      } else {
        return DataFailed(response.error!);
      }
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<DataState> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!prefs.containsKey('token')) {
        return const DataFailed(AppError(message: 'Token not found'));
      }

      await prefs.remove('token');
      return const DataSuccess();
    } catch (e) {
      return DataFailed(AppError(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
