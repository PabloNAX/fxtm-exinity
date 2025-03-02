// test/mocks/mock_classes.dart

import 'package:mockito/annotations.dart';
import 'package:fxtm/core/services/api_client.dart';
import 'package:fxtm/core/services/cache_service.dart';
import 'package:fxtm/core/services/connectivity_service.dart';
import 'package:fxtm/core/services/finnhub_service.dart';
import 'package:fxtm/core/services/web_socket_client.dart';
import 'package:fxtm/core/services/ws_service.dart';
import 'package:fxtm/data/repositories/forex_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Generate mock classes with Mockito
@GenerateMocks([
  ApiClient,
  CacheService,
  ConnectivityService,
  FinnhubService,
  WebSocketClient,
  WsService,
  ForexRepository,
  SharedPreferences,
])
void main() {}
