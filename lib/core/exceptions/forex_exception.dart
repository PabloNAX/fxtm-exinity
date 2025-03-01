// lib/core/exceptions/forex_exception.dart

enum ErrorType {
  network, // Ошибки сети
  server, // Ошибки сервера (500)
  auth, // Ошибки авторизации (401, 403)
  notFound, // Ресурс не найден (404)
  rateLimit, // Превышен лимит запросов (429)
  timeout, // Таймаут запроса
  unknown // Неизвестная ошибка
}

class ForexException implements Exception {
  final String userMessage;
  final ErrorType type;
  final dynamic originalError;

  ForexException(
    this.userMessage, {
    required this.type,
    this.originalError,
  });

  // Вспомогательный метод для получения сообщения для пользователя
  factory ForexException.fromType(ErrorType type, [dynamic originalError]) {
    String message;

    switch (type) {
      case ErrorType.network:
        message = 'Нет подключения к интернету. Проверьте ваше соединение.';
        break;
      case ErrorType.server:
        message = 'Ошибка сервера. Попробуйте позже.';
        break;
      case ErrorType.auth:
        message = 'Ошибка авторизации. Проверьте ваш API-ключ.';
        break;
      case ErrorType.notFound:
        message = 'Запрашиваемый ресурс не найден.';
        break;
      case ErrorType.rateLimit:
        message = 'Превышен лимит запросов. Попробуйте позже.';
        break;
      case ErrorType.timeout:
        message =
            'Превышено время ожидания запроса. Проверьте ваше соединение.';
        break;
      case ErrorType.unknown:
      default:
        message = 'Произошла неизвестная ошибка. Попробуйте позже.';
    }

    return ForexException(
      message,
      type: type,
      originalError: originalError,
    );
  }

  @override
  String toString() => userMessage;
}
