/// Constants and Enums
const List<String> defaultPairs = [
  'OANDA:EUR_USD',
  'OANDA:GBP_USD',
  'OANDA:USD_JPY',
  'OANDA:AUD_USD',
  'OANDA:USD_CAD',
  'OANDA:USD_CHF',
  'OANDA:EUR_GBP',
  'OANDA:EUR_JPY'
];

// For daily and weekly charts, show date
const monthNames = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec'
];

enum WebSocketStatus { disconnected, connected, paused }
