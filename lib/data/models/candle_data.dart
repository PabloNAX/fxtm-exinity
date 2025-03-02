// lib/data/models/candle_data.dart

/// Model representing candle data for financial charts.
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

  // Getter to retrieve the date from the timestamp
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Factory method to create an object from JSON directly
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
