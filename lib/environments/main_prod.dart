/// Main entry point for the production version of the FXTM Forex Tracker application.
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/services/api_client.dart';
import '../core/services/cache_service.dart';
import '../core/services/connectivity_service.dart';
import '../core/services/finnhub_service.dart';
import '../core/services/web_socket_client.dart';
import '../core/services/ws_service.dart';
import '../data/repositories/forex_repository.dart';
import '../pages/main_page.dart';

void main() async {
  // Retrieve API keys from the .env file (or use constants for testing)
  final apiKey = dotenv.env['API_KEY'] ?? 'your_api_key_here';

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Initialize ConnectivityService
  final connectivityService = ConnectivityService();

  // Initialize services
  final apiClient = ApiClient(
    apiKey: apiKey,
    connectivityService: connectivityService,
  );

  // Initialize Finnhub service
  final finnhubService = FinnhubServiceImpl(apiClient);

  final cacheService = CacheService(prefs);
  // Clear the cache on fresh launch to fetch data from the API first
  await cacheService.clearCache();

  // Initialize repository
  final forexRepository = ForexRepository(
    service: finnhubService,
    cacheService: cacheService,
  );

  // Initialize WebSocket
  final wsClient = WebSocketClient(
      apiToken: apiKey, connectivityService: connectivityService);
  final wsService = WsService(wsClient: wsClient);

  runApp(FXTMApp(
    forexRepository: forexRepository,
    wsService: wsService,
    finnhubService: finnhubService,
  ));
}

class FXTMApp extends StatelessWidget {
  final ForexRepository forexRepository;
  final WsService wsService;
  final FinnhubService finnhubService;

  const FXTMApp({
    Key? key,
    required this.forexRepository,
    required this.wsService,
    required this.finnhubService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FXTM Forex Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(
        forexRepository: forexRepository,
        wsService: wsService,
        finnhubService: finnhubService,
      ),
    );
  }
}
