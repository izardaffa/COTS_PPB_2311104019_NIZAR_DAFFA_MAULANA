import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  static String get baseUrl {
    final value = dotenv.env['BASE_URL'];
    if (value == null || value.isEmpty) {
      throw Exception('BASE_URL tidak ditemukan di .env');
    }
    return value;
  }

  static String get anonKey {
    final value = dotenv.env['ANON_KEY'];
    if (value == null || value.isEmpty) {
      throw Exception('ANON_KEY tidak ditemukan di .env');
    }
    return value;
  }
}
