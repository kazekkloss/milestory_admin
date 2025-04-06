import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../core_export.dart';

enum RequestMethod { get, post, delete, streamTo }

@lazySingleton
class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;

  ApiClient(this._dio, this._tokenManager);

  Future<DataState> request({
    required String url,
    required RequestMethod method,
    Map<String, dynamic>? data,
    Uint8List? fileData,
    String? fileName,
  }) async {
    try {
      Response response = await _performRequest(url, method, data, fileData, fileName);
      return DataSuccess(response.data);
    } on DioException catch (e) {
      // Obsługa błędu 401 - próba odświeżenia tokena
      if (e.response?.statusCode == 401) {
        final refreshed = await _tokenManager.refreshTokens();
        if (refreshed) {
          // Ponowienie żądania po udanym odświeżeniu tokenów
          try {
            Response response = await _performRequest(url, method, data, fileData, fileName);
            return DataSuccess(response.data);
          } on DioException catch (retryError) {
            // Jeśli ponowione żądanie też zawiedzie, zwracamy błąd
            return DataFailed(AppError(apiError: ApiError.fromDioError(retryError)));
          }
        } else {
          // Jeśli odświeżenie tokenów się nie powiodło, zwracamy 401
          return DataFailed(AppError(apiError: ApiError(code: 401, message: 'Sesja wygasła')));
        }
      }
      // Inne błędy Dio są zwracane bez ponawiania
      return DataFailed(AppError(apiError: ApiError.fromDioError(e)));
    } catch (e) {
      // Nieoczekiwane błędy poza Dio
      return DataFailed(AppError(apiError: ApiError(code: -1, message: 'Nieoczekiwany błąd: ${e.toString()}')));
    }
  }

  Future<Response> _performRequest(
    String url,
    RequestMethod method,
    Map<String, dynamic>? data,
    Uint8List? fileData,
    String? fileName,
  ) async {
    switch (method) {
      case RequestMethod.post:
        if (data == null) throw ArgumentError('Data must be provided for POST requests');
        return await _dio.post(url, data: data);
      case RequestMethod.get:
        return await _dio.get(url);
      case RequestMethod.delete:
        return await _dio.delete(url, data: data);
      case RequestMethod.streamTo:
        if (fileData == null || fileName == null) {
          throw ArgumentError('File data and file name must be provided for streamTo requests');
        }
        FormData formData = FormData.fromMap({
          ...?data,
          'file': MultipartFile.fromBytes(fileData, filename: fileName),
        });
        return await _dio.post(url, data: formData);
    }
  }
}

// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// import '../core_export.dart';

// enum RequestMethod { get, post, streamTo, delete }

// @lazySingleton
// class ApiClient {
//   final Dio _dio;
//   final SharedPreferences _preferences;

//   ApiClient(this._dio, this._preferences);

//   // Metoda do pobierania nagłówków z tokenem
//   Future<Map<String, String>> getHeaders() async {
//     final token = _preferences.getString('token');
//     return {
//       if (token != null) 'Authorization': 'Bearer $token',
//     };
//   }

//   Future<DataState<T>> request<T>({
//     required String url,
//     required RequestMethod method,
//     Map<String, dynamic>? data,
//     Uint8List? fileData,
//     String? fileName,
//   }) async {
//     try {
//       // Korzystamy z getHeaders do ustawienia nagłówków
//       final headers = await getHeaders();
//       _dio.options.headers.addAll(headers);

//       Response<T> response;

//       switch (method) {
//         case RequestMethod.post:
//           if (data == null) {
//             throw ArgumentError('Data must be provided for POST requests');
//           }
//           response = await _dio.post<T>(url, data: data);
//           break;
//         case RequestMethod.get:
//           response = await _dio.get<T>(url);
//           break;
//         case RequestMethod.streamTo:
//           if (fileData == null || fileName == null) {
//             throw ArgumentError('File data and file name must be provided for streamTo requests');
//           }
//           FormData formData = FormData.fromMap({
//             ...?data,
//             'file': MultipartFile.fromBytes(fileData, filename: fileName),
//           });
//           response = await _dio.post<T>(url, data: formData);
//           break;
//         case RequestMethod.delete:
//           if (data == null) {
//             throw ArgumentError('Data must be provided for POST requests');
//           }
//           response = await _dio.delete<T>(url, data: data);
//           break;
//       }

//       return DataSuccess(response.data);
//     } on DioException catch (e) {
//       print('DioException: ${e.response?.statusCode} ${e.response?.statusMessage}');
//       return DataFailed(AppError(apiError: ApiError.fromDioError(e)));
//     } catch (e) {
//       print('Unexpected error: $e');
//       return DataFailed(AppError(apiError: ApiError(code: -1, message: 'Unexpected error: ${e.toString()}')));
//     }
//   }
// }
