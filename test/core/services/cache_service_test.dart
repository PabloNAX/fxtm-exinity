import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fxtm/core/services/cache_service.dart';
import 'package:fxtm/data/models/forex_symbols_api_model.dart';

// Создаем мок для SharedPreferences
class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  group('CacheService', () {
    late CacheService cacheService;
    late MockSharedPreferences mockPrefs;

    setUp(() {
      mockPrefs = MockSharedPreferences();
      cacheService = CacheService(mockPrefs);
    });

    test('cacheForexPairs should save data to SharedPreferences', () async {
      // Arrange
      final pairs = [
        ForexSymbolsApiModel(
            description: 'EUR/USD',
            displaySymbol: 'EUR/USD',
            symbol: 'OANDA:EUR_USD'),
      ];

      // Настраиваем мок для успешного сохранения
      when(() => mockPrefs.setString(any(), any()))
          .thenAnswer((_) async => true);

      // Act
      await cacheService.cacheForexPairs(pairs);

      // Assert
      verify(() => mockPrefs.setString('forex_pairs_cache', any())).called(1);
    });

    test('getCachedForexPairs should return null when no cache exists',
        () async {
      // Arrange
      when(() => mockPrefs.getString(any())).thenReturn(null);

      // Act
      final result = await cacheService.getCachedForexPairs();

      // Assert
      expect(result, isNull);
      verify(() => mockPrefs.getString('forex_pairs_cache')).called(1);
    });

    test('getCachedForexPairs should return data when valid cache exists',
        () async {
      // Arrange
      final now = DateTime.now();
      final timestamp = now.millisecondsSinceEpoch;
      final pairs = [
        {
          'description': 'EUR/USD',
          'displaySymbol': 'EUR/USD',
          'symbol': 'OANDA:EUR_USD'
        }
      ];

      final cacheData = {
        'timestamp': timestamp,
        'pairs': pairs,
      };

      when(() => mockPrefs.getString('forex_pairs_cache'))
          .thenReturn(jsonEncode(cacheData));

      // Act
      final result = await cacheService.getCachedForexPairs();

      // Assert
      expect(result, isNotNull);
      expect(result!.length, 1);
      expect(result.first.symbol, 'OANDA:EUR_USD');
      verify(() => mockPrefs.getString('forex_pairs_cache')).called(1);
    });

    test(
        'getCachedForexPairs should clear and return null when cache is expired',
        () async {
      // Arrange
      final expiredTimestamp =
          DateTime.now().subtract(Duration(minutes: 10)).millisecondsSinceEpoch;

      final pairs = [
        {
          'description': 'EUR/USD',
          'displaySymbol': 'EUR/USD',
          'symbol': 'OANDA:EUR_USD'
        }
      ];

      final cacheData = {
        'timestamp': expiredTimestamp,
        'pairs': pairs,
      };

      when(() => mockPrefs.getString('forex_pairs_cache'))
          .thenReturn(jsonEncode(cacheData));

      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      final result = await cacheService.getCachedForexPairs();

      // Assert
      expect(result, isNull);
      verify(() => mockPrefs.getString('forex_pairs_cache')).called(1);
      verify(() => mockPrefs.remove('forex_pairs_cache')).called(1);
    });

    test('clearCache should remove cached data', () async {
      // Arrange
      when(() => mockPrefs.remove(any())).thenAnswer((_) async => true);

      // Act
      await cacheService.clearCache();

      // Assert
      verify(() => mockPrefs.remove('forex_pairs_cache')).called(1);
    });
  });
}
