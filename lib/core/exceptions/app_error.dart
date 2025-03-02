// lib/core/exceptions/app_error.dart
enum ErrorType {
  network, // Проблемы с сетью
  server, // Проблемы с сервером
  auth, // Проблемы с авторизацией
  data, // Проблемы с данными
  timeout, // Тайм-ауты
  unknown // Все остальное
}

class AppError implements Exception {
  final String message;
  final ErrorType type;
  final dynamic originalException;

  AppError({required this.message, required this.type, this.originalException});

  // Фабричный метод для создания ошибки определенного типа
  factory AppError.network([dynamic originalException]) {
    return AppError(
        message: 'Нет подключения к интернету',
        type: ErrorType.network,
        originalException: originalException);
  }

  factory AppError.server([dynamic originalException]) {
    return AppError(
        message: 'Ошибка сервера',
        type: ErrorType.server,
        originalException: originalException);
  }

  factory AppError.auth([dynamic originalException]) {
    return AppError(
        message: 'Ошибка авторизации',
        type: ErrorType.auth,
        originalException: originalException);
  }

  factory AppError.data([dynamic originalException]) {
    return AppError(
        message: 'Ошибка данных',
        type: ErrorType.data,
        originalException: originalException);
  }

  factory AppError.timeout([dynamic originalException]) {
    return AppError(
        message: 'Превышено время ожидания',
        type: ErrorType.timeout,
        originalException: originalException);
  }

  factory AppError.unknown(String message, [dynamic originalException]) {
    return AppError(
        message: message,
        type: ErrorType.unknown,
        originalException: originalException);
  }

  @override
  String toString() => message;
}
