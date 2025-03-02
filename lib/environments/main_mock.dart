// lib/environments/main_mock.dart

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

  // Инициализация SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Инициализация мок-сервисов
  final connectivityService = ConnectivityService();
  final mockFinnhubService = MockFinnhubService();
  final cacheService = CacheService(prefs);

  // Очистка кэша при запуске для получения свежих мок-данных
  await cacheService.clearCache();

  // Инициализация репозитория с мок-сервисом
  final forexRepository = ForexRepository(
    service: mockFinnhubService,
    cacheService: cacheService,
  );

  // Инициализация мок WebSocket
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
        // Добавьте визуальную индикацию мок-режима
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
