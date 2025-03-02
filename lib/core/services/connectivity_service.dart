// lib/core/services/connectivity_service.dart

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Service for checking internet connectivity status.
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();

  // Checks for internet connectivity
  Future<bool> hasConnection() async {
    try {
      final connectivityResult = await _connectivity.checkConnectivity();
      print('Connectivity result: $connectivityResult');
      return !connectivityResult.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }
}
