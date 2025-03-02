// lib/environments/main_mock.dart

/// Main entry point for the mock version of the FXTM Forex Tracker application.
import 'package:flutter/material.dart';
import 'package:fxtm/core/services/connectivity_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/cache_service.dart';
import '../data/repositories/forex_repository.dart';
import '../mocks/services/mock_finnhub_service.dart';
import '../mocks/services/mock_web_socket_client.dart';
import '../mocks/services/mock_ws_service.dart';
import '../pages/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize mock services
  final connectivityService = ConnectivityService();
  final mockFinnhubService = MockFinnhubService();
  final cacheService = CacheService(prefs);

  // Clear cache on startup to get fresh mock data
  await cacheService.clearCache();

  // Initialize repository with mock service
  final forexRepository = ForexRepository(
    service: mockFinnhubService,
    cacheService: cacheService,
  );

  // Initialize mock WebSocket
  final mockWsClient = MockWebSocketClient(
    connectivityService: connectivityService,
  );
  final mockWsService = MockWsService(mockWsClient: mockWsClient);

  runApp(FXTMApp(
    forexRepository: forexRepository,
    wsService: mockWsService,
    finnhubService: mockFinnhubService,
  ));
}

class FXTMApp extends StatelessWidget {
  final ForexRepository forexRepository;
  final MockWsService wsService;
  final MockFinnhubService finnhubService;

  const FXTMApp({
    Key? key,
    required this.forexRepository,
    required this.wsService,
    required this.finnhubService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker (Mock)',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Add visual indication of mock mode
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blue.shade800,
          foregroundColor: Colors.white,
        ),
      ),
      home: MainPage(
        forexRepository: forexRepository,
        wsService: wsService,
        finnhubService: finnhubService,
      ),
    );
  }
}
