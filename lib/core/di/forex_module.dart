// class ForexModule {
//   static Future<ForexRepository> provideRepository() async {
//     // Create API client
//     final apiClient = ApiClient(apiKey: const String.fromEnvironment('API_KEY'));
//
//     // Create Finnhub service
//     final finnhubService = FinnhubServiceImpl(apiClient);
//
//     // Create Cache service
//     final prefs = await SharedPreferences.getInstance();
//     final cacheService = CacheService(prefs);
//
//     // Create WebSocket client and service
//     final wsClient = WebSocketClient(apiToken: const String.fromEnvironment('API_KEY'));
//     final wsService = WsService(wsClient: wsClient);
//
//     // Create repository
//     return ForexRepository(
//       service: finnhubService,
//       cacheService: cacheService,
//       wsService: wsService,
//     );
//   }
// }
