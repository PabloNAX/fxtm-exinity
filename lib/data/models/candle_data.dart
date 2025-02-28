// lib/data/models/candle_data.dart

class CandleData {
  final double open;
  final double high;
  final double low;
  final double close;
  final int timestamp;
  final int volume;

  CandleData({
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.timestamp,
    required this.volume,
  });

  // Геттер для получения даты из timestamp
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Если вам нужно создавать объект из JSON напрямую
  factory CandleData.fromJson(Map<String, dynamic> json) {
    return CandleData(
      open: json['open'],
      high: json['high'],
      low: json['low'],
      close: json['close'],
      timestamp: json['timestamp'],
      volume: json['volume'],
    );
  }
}
