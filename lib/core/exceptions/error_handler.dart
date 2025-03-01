// lib/core/error/error_handler.dart

import 'package:flutter/material.dart';
import '../exceptions/forex_exception.dart';

class ErrorHandler {
  // Статичный метод для отображения ошибки
  static void showError(BuildContext context, dynamic error) {
    // Преобразуем ошибку в ForexException, если она еще не является ею
    final forexException = _asForexException(error);

    // Выбираем способ отображения в зависимости от типа ошибки
    switch (forexException.type) {
      case ErrorType.network:
        _showNetworkError(context, forexException.userMessage);
        break;
      case ErrorType.timeout:
        _showTimeoutError(context, forexException.userMessage);
        break;
      default:
        _showGeneralError(context, forexException.userMessage);
    }
  }

  // Преобразует ошибку в ForexException
  static ForexException _asForexException(dynamic error) {
    if (error is ForexException) {
      return error;
    }

    return ForexException.fromType(ErrorType.unknown, error);
  }

  // Показывает ошибку сети
  static void _showNetworkError(BuildContext context, String message) {
    _showDialog(
      context,
      'Ошибка подключения',
      message,
      icon: Icons.wifi_off,
      color: Colors.red,
    );
  }

  // Показывает ошибку таймаута
  static void _showTimeoutError(BuildContext context, String message) {
    _showDialog(
      context,
      'Превышено время ожидания',
      message,
      icon: Icons.timer_off,
      color: Colors.orange,
    );
  }

  // Показывает общую ошибку
  static void _showGeneralError(BuildContext context, String message) {
    _showDialog(
      context,
      'Ошибка',
      message,
      icon: Icons.error_outline,
      color: Colors.red,
    );
  }

  // Базовый метод для отображения диалога
  static void _showDialog(
    BuildContext context,
    String title,
    String message, {
    IconData icon = Icons.error_outline,
    Color color = Colors.red,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 8),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
