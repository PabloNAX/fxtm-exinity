import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'environments/main_prod.dart' as prod;
import 'environments/main_mock.dart' as mock;

/// I created mock env expeciaaly to check if the prod api not working
/// because candle API for history page is Premium feature in Finhub.
/// To change the env you need to go to .env and change to prod or to mock
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print("FLAVOR from .env: ${dotenv.env['FLAVOR']}");
  // Set flavor in the .env either prod or mock
  final flavor = dotenv.env['FLAVOR'] ?? 'prod';
  if (flavor == 'mock') {
    mock.main();
  } else {
    prod.main();
  }
}
