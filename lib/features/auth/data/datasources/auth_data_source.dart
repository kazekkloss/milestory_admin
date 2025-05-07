import 'package:injectable/injectable.dart';
import '../../../../core/core_export.dart';

abstract class AuthDataSource {
  Future<DataState<UserModel>> signIn({required String email, required String password});
  Future<DataState<UserModel>> checkAuth();
  Future<DataState> logout({required bool isLocal});
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
      final token = tokenManager.accessToken;
      if (token == null || token.isEmpty) {
        print("TOKEN ============================= ${token}");
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
      return DataFailed(AppError(message: e.toString()));
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

        print("WYLOGOWYWANIE ===========================================");
        if (response is! DataSuccess) {
          // Jeśli backend zwróci błąd, zdecyduj, co robić
          if (response.error?.apiError?.code == 403) {
            print("403 Forbidden during logout. Falling back to local logout...");
          } else {
            return DataFailed(response.error!);
          }
        }
      }

      await tokenManager.clearTokens();
      return const DataSuccess();
    } catch (e) {
      return DataFailed(AppError(message: e.toString()));
    }
  }
}
