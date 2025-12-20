import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiBaseDev {
  static const  String baseUrlDevelopment = 'http://10.0.2.2:3001/api/';

}
class ApiBaseNotiDev {
  static const  String baseUrlNotification = 'http://10.0.2.2:3002/notification/';

}

class ApiBaseProd {
  static const String baseUrlProduction = 'https://api.example.com';
}

class ApiKey {
  static String get googleApiKey => dotenv.env['GOOGLE_API_KEY'] ?? '';
  static String get firebaseApiKey => dotenv.env['FIREBASE_API_KEY'] ?? '';
}
