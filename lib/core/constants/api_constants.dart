import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String baseUrl = dotenv.env['API_BASE_URL'] ?? "";
  static String bearerToken = dotenv.env['API_TOKEN'] ?? '';
  static String apiKey= dotenv.env['APi_KEY']??'';
  static String apiShortNerToken= dotenv.env['API_SHORTNER_TOKEN']??'';
}
