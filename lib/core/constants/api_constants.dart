import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConstants {
  static String get restCountriesApiKey {
    return dotenv.env['REST_COUNTRIES_API_KEY'] ?? '';
  }

  static String get openWeatherApiKey {
    return dotenv.env['OPENWEATHER_API_KEY'] ?? '';
  }
}
