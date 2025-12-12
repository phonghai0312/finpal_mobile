import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiBaseDev {
  static const String baseUrlDevelopment =
      'https://finpal.id.vn/';
}

class ApiBaseProd {
  static const String baseUrlProduction = 'https://api.example.com';
}

class ApiKey {
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
}
