import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/forex_symbols_api_model.dart';

class CacheService {
  static const String _forexPairsKey = 'forex_pairs_cache';
  static const Duration _cacheDuration = Duration(minutes: 5);

  final SharedPreferences _prefs;

  CacheService(this._prefs);

  Future<void> cacheForexPairs(List<ForexSymbolsApiModel> pairs) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cacheData = {
      'timestamp': timestamp,
      'pairs': pairs.map((pair) => pair.toJson()).toList(),
    };

    await _prefs.setString(_forexPairsKey, jsonEncode(cacheData));
  }

  Future<List<ForexSymbolsApiModel>?> getCachedForexPairs() async {
    final cachedData = _prefs.getString(_forexPairsKey);
    if (cachedData == null) return null;

    final data = jsonDecode(cachedData) as Map<String, dynamic>;
    final timestamp = data['timestamp'] as int;
    final now = DateTime.now().millisecondsSinceEpoch;

    // Проверяем не устарел ли кэш
    if (now - timestamp > _cacheDuration.inMilliseconds) {
      await _prefs.remove(_forexPairsKey);
      return null;
    }

    final pairsJson = data['pairs'] as List;
    return pairsJson
        .map((json) => ForexSymbolsApiModel.fromJson(json))
        .toList();
  }

  Future<void> clearCache() async {
    await _prefs.remove(_forexPairsKey);
  }
}
