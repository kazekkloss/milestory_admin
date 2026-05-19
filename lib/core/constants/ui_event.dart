import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

class UiEvent extends Equatable {
  final String message;
  final bool isError;
  final int? httpStatus;
  final String? code;
  final List<String>? errors;
  final String? blockingStatus;

  const UiEvent({
    this.message = "Wystąpił nieoczekiwany błąd",
    this.isError = true,
    this.httpStatus,
    this.code,
    this.errors,
    this.blockingStatus,
  });

  const UiEvent.success({required String message})
      : this(message: message, isError: false);

  const UiEvent.sessionExpired()
      : this(message: 'Sesja wygasła', httpStatus: 401);

  factory UiEvent.unexpected(String details) =>
      UiEvent(message: 'Nieoczekiwany błąd: $details');

  factory UiEvent.fromDioError(DioException error) {
    debugPrint('Dio error type: ${error.type}, message: ${error.message}');

    final statusCode = error.response?.statusCode;
    final errorData = error.response?.data;

    switch (error.type) {
      case DioExceptionType.cancel:
        return const UiEvent(message: 'Żądanie zostało anulowane');
      case DioExceptionType.connectionTimeout:
        return const UiEvent(message: 'Przekroczono czas połączenia');
      case DioExceptionType.sendTimeout:
        return const UiEvent(message: 'Przekroczono czas wysyłania');
      case DioExceptionType.receiveTimeout:
        return const UiEvent(message: 'Przekroczono czas odbioru');
      case DioExceptionType.connectionError:
        return UiEvent(message: 'Błąd połączenia: ${error.message}');
      case DioExceptionType.badResponse:
        return _fromBadResponse(statusCode ?? -1, errorData);
      case DioExceptionType.unknown:
      default:
        return const UiEvent(message: 'Nieoczekiwany błąd');
    }
  }

  static UiEvent _fromBadResponse(int statusCode, dynamic errorData) {
    String message = _defaultMessageForStatus(statusCode);

    if (errorData is Map<String, dynamic> && errorData['message'] != null) {
      message = errorData['message'].toString();
    }

    String? parsedCode;
    List<String>? parsedErrors;
    String? parsedBlockingStatus;

    if (errorData is Map<String, dynamic>) {
      parsedCode = errorData['code'] as String?;
      parsedBlockingStatus = errorData['blockingStatus'] as String?;
      final rawErrors = errorData['errors'];
      if (rawErrors is List) {
        parsedErrors = rawErrors.map((e) => e.toString()).toList();
      }
    }

    return UiEvent(
      message: message,
      httpStatus: statusCode,
      code: parsedCode,
      errors: parsedErrors,
      blockingStatus: parsedBlockingStatus,
    );
  }

  static String _defaultMessageForStatus(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Nieprawidłowe dane wejściowe';
      case 401:
        return 'Brak autoryzacji';
      case 403:
        return 'Dostęp zabroniony';
      case 404:
        return 'Nie znaleziono zasobu';
      case 409:
        return 'Konflikt';
      case 422:
        return 'Błąd walidacji danych';
      case 500:
        return 'Błąd serwera';
      default:
        return 'Nieoczekiwany błąd: $statusCode';
    }
  }

  @override
  List<Object?> get props =>
      [message, isError, httpStatus, code, errors, blockingStatus];
}
