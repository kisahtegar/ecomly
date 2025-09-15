import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

/// Centralized network configuration constants for the Ecomly client.
///
/// This class reads environment-based configuration using `flutter_dotenv`
/// and provides sane defaults for local development when variables are not set.
/// It also exposes commonly used HTTP headers and pagination settings.
///
/// Environment variables are typically defined in `.env` and loaded during app
/// startup. See `.env.example` for available keys.
///
/// ### Environment keys:
/// - `BASE_URL`: Fully-qualified base URL, e.g., `https://api.example.com/api/v1`
/// - `AUTHORITY`: Host and port (used for Uri construction), e.g., `api.example.com:443`
/// - `API_URL`: API base path, e.g., `/api/v1`
///
/// ### Example usage:
/// ```dart
/// final uri = Uri.https(NetworkConstants.authority, '${NetworkConstants.apiUrl}/products');
/// final response = await http.get(uri, headers: NetworkConstants.headers);
/// ```
///
/// ### Defaults (when .env vars are missing):
/// - `BASE_URL` → `https://127.0.0.1:3000/api/v1`
/// - `AUTHORITY` → `127.0.0.1:3000`
/// - `API_URL` → `/api/v1`
/// - `headers` → JSON content type with UTF-8 charset
/// - `pageSize` → 10 items per page
abstract class NetworkConstants {
  const NetworkConstants();

  /// Fully-qualified base URL for direct string-based requests.
  static final baseUrl =
      dotenv.env['BASE_URL'] ?? 'https://127.0.0.1:3000/api/v1';

  /// Host and port component used for Uri construction.
  static final authority = dotenv.env['AUTHORITY'] ?? '127.0.0.1:3000';

  /// Base API path appended to the host when constructing endpoints.
  static final apiUrl = dotenv.env['API_URL'] ?? '/api/v1';

  /// Default HTTP headers used for JSON requests.
  static const headers = {'Content-Type': 'application/json; charset=UTF-8'};

  /// Default pagination size for list endpoints.
  static const pageSize = 10;
}
