import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/core_export.dart';
import '../../auth_export.dart';

abstract class AuthDataSource {
  Future<DataState<UserModel>> signIn(
      {required String email, required String password});
  Future<DataState<UserModel>> checkAuth();
  Future<DataState> logout({required bool isLocal});
  Future<DataState> sendPasswordRecoveryLink({required String email});
  Future<DataState> deleteUser({required String userId});
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
      throw const UiEvent(message: "Invalid token response from server");
    }

    debugPrint("NEW ACCESS TOKEN: $accessToken");
    debugPrint("NEW REFRESH TOKEN: $refreshToken");

    await tokenManager.setAccessToken(accessToken);
    await tokenManager.setRefreshToken(refreshToken);
  }

  @override
  Future<DataState<UserModel>> signIn(
      {required String email, required String password}) async {
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
        debugPrint("Sign-In successful: ${userModel.email}");
        return DataSuccess(userModel);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState<UserModel>> checkAuth() async {
    try {
      final token = tokenManager.accessToken;
      if (token == null || token.isEmpty) {
        return const DataFailed(UiEvent(message: 'Token is missing'));
      }

      final response = await apiClient.request(
        url: ApiConstants.checkAuth,
        method: RequestMethod.get,
      );

      if (response is DataSuccess) {
        final userModel = UserModel.fromJson(response.data);
        return DataSuccess(userModel);
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState> sendPasswordRecoveryLink({required String email}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.sendPasswordRecoveryLink,
        method: RequestMethod.post,
        data: {'email': email},
      );
      if (response is DataSuccess) {
        return const DataSuccess();
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }

  @override
  Future<DataState> logout({required bool isLocal}) async {
    try {
      if (!isLocal) {
        final response = await apiClient.request(
          url: ApiConstants.logout,
          method: RequestMethod.delete,
        );

        if (response is! DataSuccess) {
          if (response.uiEvent?.httpStatus == 403) {
            debugPrint("403 during logout, falling back to local logout");
          } else {
            return DataFailed(response.uiEvent!);
          }
        }
      }

      await tokenManager.clearTokens();
      return const DataSuccess();
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }


  @override
  Future<DataState> deleteUser({required String userId}) async {
    try {
      final response = await apiClient.request(
        url: ApiConstants.deleteUser,
        method: RequestMethod.delete,
        data: {'userId': userId},
      );
      if (response is DataSuccess) {
        await tokenManager.clearTokens();
        return const DataSuccess();
      } else {
        return DataFailed(response.uiEvent!);
      }
    } catch (e) {
      return DataFailed(UiEvent(message: e.toString()));
    }
  }
}
