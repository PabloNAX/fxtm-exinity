// lib/core/ui/error_ui.dart
import 'package:flutter/material.dart';
import '../exceptions/app_error.dart';
import '../services/error_service.dart';

/// UI utility for displaying error messages to the user.
class ErrorUI {
  // Displays a Snackbar with the error message
  static void showSnackBar(BuildContext context, dynamic error) {
    final appError = ErrorService.handleError(error);

    // Settings for different types of errors
    IconData icon;
    Color color;

    switch (appError.type) {
      case ErrorType.network:
        icon = Icons.wifi_off;
        color = Colors.orange;
        break;
      case ErrorType.server:
        icon = Icons.cloud_off;
        color = Colors.red;
        break;
      case ErrorType.auth:
        icon = Icons.lock;
        color = Colors.deepPurple;
        break;
      case ErrorType.data:
        icon = Icons.data_usage;
        color = Colors.amber;
        break;
      case ErrorType.timeout:
        icon = Icons.timer_off;
        color = Colors.orange;
        break;
      default:
        icon = Icons.error;
        color = Colors.red;
    }

    // Display the SnackBar
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
                child: Text(appError.message,
                    style: const TextStyle(fontSize: 16))),
          ],
        ),
        backgroundColor: color,
        duration: const Duration(seconds: 4),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        action: SnackBarAction(
          label: 'OK',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

  // Displays a Dialog with the error message (for critical errors)
  static void showErrorDialog(BuildContext context, dynamic error) {
    final appError = ErrorService.handleError(error);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(appError.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
