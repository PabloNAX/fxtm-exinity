// lib/core/exceptions/app_error.dart
/// Enum representing different types of application errors that can occur.
/// This helps categorize errors for better handling and user feedback.
enum ErrorType {
  network, // Network issues
  server, // Server issues
  auth, // Authentication issues
  data, // Data-related issues
  timeout, // Timeout issues
  unknown // All other issues
}

/// Class representing an application error, implementing the Exception interface.
/// This class encapsulates error details, including a message, type, and original exception.
class AppError implements Exception {
  final String message;
  final ErrorType type;
  final dynamic originalException;

  AppError({required this.message, required this.type, this.originalException});

  // Factory method for creating a network error
  factory AppError.network([dynamic originalException]) {
    return AppError(
        message: 'No internet connection',
        type: ErrorType.network,
        originalException: originalException);
  }

  // Factory method for creating a server error
  factory AppError.server([dynamic originalException]) {
    return AppError(
        message: 'Server error',
        type: ErrorType.server,
        originalException: originalException);
  }

  // Factory method for creating an authentication error
  factory AppError.auth([dynamic originalException]) {
    return AppError(
        message: 'Authentication error',
        type: ErrorType.auth,
        originalException: originalException);
  }

  // Factory method for creating a data error
  factory AppError.data([dynamic originalException]) {
    return AppError(
        message: 'Data error',
        type: ErrorType.data,
        originalException: originalException);
  }

  // Factory method for creating a timeout error
  factory AppError.timeout([dynamic originalException]) {
    return AppError(
        message: 'Timeout exceeded',
        type: ErrorType.timeout,
        originalException: originalException);
  }

  // Factory method for creating an unknown error
  factory AppError.unknown(String message, [dynamic originalException]) {
    return AppError(
        message: message,
        type: ErrorType.unknown,
        originalException: originalException);
  }

  @override
  String toString() => message;
}
