import 'package:dio/dio.dart';

class ApiError {
  final int code;
  final String message;

  ApiError({required this.code, required this.message});

  static ApiError fromDioError(DioException error) {
    print('Dio error type: ${error.type}, message: ${error.message}');

    // Domyślne wartości w przypadku braku odpowiedzi
    final statusCode = error.response?.statusCode ?? -1;
    final errorData = error.response?.data;
    String errorMessage = error.response?.statusMessage ?? 'Unknown error';

    // Sprawdzamy typ błędu Dio
    switch (error.type) {
      case DioExceptionType.cancel:
        return ApiError(code: statusCode, message: 'Request was cancelled');
      case DioExceptionType.connectionTimeout:
        return ApiError(code: statusCode, message: 'Connection timeout');
      case DioExceptionType.sendTimeout:
        return ApiError(code: statusCode, message: 'Send timeout');
      case DioExceptionType.receiveTimeout:
        return ApiError(code: statusCode, message: 'Receive timeout');
      case DioExceptionType.connectionError:
        return ApiError(code: -1, message: 'Connection error: ${error.message}');
      case DioExceptionType.badResponse:
        // Mapowanie kodów statusu z Node.js na komunikaty błędów
        switch (statusCode) {
          case 400:
            errorMessage = 'Nieprawidłowe dane wejściowe'; // IncorrectPasswordError
            if (errorData is Map<String, dynamic> && errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            }
            break;
          case 401:
            errorMessage = 'Brak autoryzacji'; // UnauthorizedError
            break;
          case 403:
            errorMessage = 'Dostęp zabroniony'; // AccessDeniedError, InvalidRefreshTokenError
            if (errorData is Map<String, dynamic> && errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            }
            break;
          case 404:
            errorMessage = 'Nie znaleziono zasobu'; // UserNotFoundError, DataNotFoundError
            break;
          case 409:
            errorMessage = 'Użytkownik już istnieje'; // UserAlreadyExistsError
            break;
          case 422:
            errorMessage = 'Błąd walidacji danych'; // DataValidationError
            if (errorData is Map<String, dynamic> && errorData['message'] != null) {
              errorMessage = errorData['message'].toString();
            }
            break;
          case 500:
            errorMessage = 'Błąd serwera'; // MailError, DataSaveError
            break;
          default:
            errorMessage = 'Nieoczekiwany błąd: $statusCode';
        }
        return ApiError(code: statusCode, message: errorMessage);
      case DioExceptionType.unknown:
      default:
        return ApiError(code: -1, message: 'Nieoczekiwany błąd');
    }
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message)';
  }
}
