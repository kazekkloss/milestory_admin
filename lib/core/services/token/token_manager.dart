import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core_export.dart';

@lazySingleton
class TokenManager {
  final Dio _dio;
  final SharedPreferences _storage;
  String? _accessToken;

  final String _appKey = dotenv.env['APP_KEY'] ?? '';

  TokenManager(this._dio, this._storage) {
    _initializeToken();
  }

  void _initializeToken() async {
    if (_appKey.isEmpty) {
      print('Warning: APP_KEY not found in .env');
    }
    _dio.options.headers['X-App-Key'] = _appKey;

    _accessToken = _storage.getString('accessToken');
    if (_accessToken != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
    } else {
      _dio.options.headers.remove('Authorization');
    }
  }

  String? get accessToken => _accessToken;

  Future<void> setAccessToken(String token) async {
    _accessToken = token;
    await _storage.setString('accessToken', token);
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  Future<String?> getRefreshToken() async {
   return _storage.getString('refreshToken');
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.setString('refreshToken', token); 
  }

  Future<void> clearTokens() async {
    _accessToken = null;
    await _storage.remove('accessToken');
    await _storage.remove('refreshToken');
    _dio.options.headers.remove('Authorization');
  }

  Future<bool> refreshTokens() async {
    final refreshToken = await getRefreshToken();
    if (refreshToken == null) {
      return false;
    }

    try {
      _dio.options.headers.remove('Authorization');

      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      final newAccessToken = response.data['accessToken'] as String;
      final newRefreshToken = response.data['refreshToken'] as String?;

      await setAccessToken(newAccessToken);
      if (newRefreshToken != null) {
        await setRefreshToken(newRefreshToken);
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, String>> getHeaders() async {
    if (_accessToken == null) {
      _accessToken = _storage.getString('accessToken');
      if (_accessToken == null) {
        final refreshed = await refreshTokens();
        if (!refreshed) {
          return {'X-App-Key': _appKey};
        }
      } else {
        _dio.options.headers['Authorization'] = 'Bearer $_accessToken';
      }
    }
    return _accessToken != null ? {'Authorization': 'Bearer $_accessToken'} : {};
  }
}