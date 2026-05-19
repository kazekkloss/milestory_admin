import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import '../core_export.dart';

enum RequestMethod { get, post, patch, delete, streamTo }

@lazySingleton
class ApiClient {
  final Dio _dio;
  final TokenManager _tokenManager;

  ApiClient(this._dio, this._tokenManager);

  Future<DataState> request({
    required String url,
    required RequestMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Uint8List? fileData,
    String? fileName,
  }) async {
    try {
      Response response = await _performRequest(
          url, method, data, queryParameters, fileData, fileName);
      return DataSuccess(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        final refreshed = await _tokenManager.refreshTokens();
        if (refreshed) {
          try {
            Response response = await _performRequest(
                url, method, data, queryParameters, fileData, fileName);
            return DataSuccess(response.data);
          } on DioException catch (retryError) {
            return DataFailed(UiEvent.fromDioError(retryError));
          }
        } else {
          return const DataFailed(UiEvent.sessionExpired());
        }
      }
      return DataFailed(UiEvent.fromDioError(e));
    } catch (e) {
      return DataFailed(UiEvent.unexpected(e.toString()));
    }
  }

  Future<Response> _performRequest(
    String url,
    RequestMethod method,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Uint8List? fileData,
    String? fileName,
  ) async {
    switch (method) {
      case RequestMethod.post:
        return await _dio.post(url,
            data: data, queryParameters: queryParameters);
      case RequestMethod.get:
        return await _dio.get(url, queryParameters: queryParameters);
      case RequestMethod.patch:
        return await _dio.patch(url,
            data: data, queryParameters: queryParameters);
      case RequestMethod.delete:
        return await _dio.delete(url,
            data: data, queryParameters: queryParameters);
      case RequestMethod.streamTo:
        if (fileData == null || fileName == null) {
          throw ArgumentError(
              'File data and file name must be provided for streamTo requests');
        }
        FormData formData = FormData.fromMap({
          ...?data,
          'file': MultipartFile.fromBytes(fileData, filename: fileName)
        });
        return await _dio.post(url,
            data: formData, queryParameters: queryParameters);
    }
  }
}
