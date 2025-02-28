class ForexException implements Exception {
  final String message;
  
  ForexException(this.message);
  
  @override
  String toString() => message;
} 