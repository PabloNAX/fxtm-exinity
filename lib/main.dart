import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/api_client.dart';
import 'core/services/cache_service.dart';
import 'core/services/connectivity_service.dart';
import 'core/services/finnhub_service.dart';
import 'core/services/web_socket_client.dart';
import 'core/services/ws_service.dart';
import 'data/repositories/forex_repository.dart';
import 'features/main_page.dart';
import 'mocks/services/mock_finnhub_service.dart';

void main() async {
  // Обязательно для асинхронных операций перед runApp
  WidgetsFlutterBinding.ensureInitialized();

  // Загрузка переменных окружения (если используете)
  await dotenv.load(fileName: ".env");

  // Получение API ключей из .env файла (или используйте константы для тестирования)
  final apiKey = dotenv.env['API_KEY'] ?? 'your_api_key_here';

  // Инициализация SharedPreferences
  final prefs = await SharedPreferences.getInstance();

  // Инициализация ConnectivityService
  final connectivityService = ConnectivityService();

  // Инициализация сервисов
  final apiClient = ApiClient(
    apiKey: apiKey,
    connectivityService: connectivityService,
  );

  // Инициализация сервисов
  // final finnhubService = FinnhubServiceImpl(apiClient);

  //Mock finhab service
  final finnhubService = MockFinhubService();

  final cacheService = CacheService(prefs);
  // Every fresh launch clear the cash to fetch the data from api first
  await cacheService.clearCache();

  // Use the mock service instead

  // Инициализация репозитория
  final forexRepository = ForexRepository(
    service: finnhubService,
    cacheService: cacheService,
  );

  // Инициализация WebSocket
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
