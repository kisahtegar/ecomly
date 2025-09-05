import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

abstract class NetworkConstants {
  const NetworkConstants();

  static final baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://127.0.0.1:3000/api/v1';
  static final authority = dotenv.env['AUTHORITY'] ?? '127.0.0.1:3000';
  static final apiUrl = dotenv.env['API_URL'] ?? '/api/v1';
  static const headers = {'Content-Type': 'application/json; charset=UTF-8'};
  static const pageSize = 10;
}
