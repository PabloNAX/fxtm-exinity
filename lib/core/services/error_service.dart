// lib/core/services/error_service.dart
import 'package:dio/dio.dart';
import '../exceptions/app_error.dart';

/// Service for handling and transforming errors into AppError instances.
class ErrorService {
  // Converts any error into AppError
  static AppError handleError(dynamic error) {
    // If it's already an AppError, just return it
    if (error is AppError) {
      return error;
    }

    // Handle Dio exceptions
    if (error is DioException) {
      return _handleDioError(error);
    }

    // Handle general exceptions
    return AppError.unknown(
        error?.toString() ?? 'An unknown error occurred', error);
  }

  // Converts DioException into AppError
  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError.timeout(error);

      case DioExceptionType.connectionError:
        return AppError.network(error);

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        if (statusCode == null) {
          return AppError.unknown('Server response error', error);
        }

        if (statusCode >= 500) {
          return AppError.server(error);
        } else if (statusCode == 401 || statusCode == 403) {
          return AppError.auth(error);
        } else if (statusCode == 404) {
          return AppError.data(error);
        } else {
          return AppError.unknown('HTTP error $statusCode', error);
        }

      default:
        return AppError.unknown('Unknown network error', error);
    }
  }

  // Converts exception to string for logging
  static String getErrorLogMessage(dynamic error) {
    final appError = handleError(error);
    return 'Error type: ${appError.type}, message: ${appError.message}, original: ${appError.originalException}';
  }
}
