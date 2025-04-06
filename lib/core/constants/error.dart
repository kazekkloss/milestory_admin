import 'package:equatable/equatable.dart';
import '../core_export.dart';

class AppError extends Equatable {
  final ApiError? apiError;
  final String? message;

  const AppError({this.apiError, this.message});

  factory AppError.fromApiError(ApiError apiError) {
    return AppError(apiError: apiError);
  }

  factory AppError.fromMessage(String message) {
    return AppError(message: message);
  }

  @override
  List<Object?> get props => [apiError, message];
}
