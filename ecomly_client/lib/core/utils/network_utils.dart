import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/services/router.dart';

/// A utility class that provides helpers for network-related tasks.
///
/// Currently focuses on handling authentication tokens in HTTP responses and
/// redirecting the user to the login flow when needed.
///
/// This class is declared as `abstract` to prevent instantiation,
/// and all its methods are static.
abstract class NetworkUtils {
  const NetworkUtils();

  /// Handles token renewal or session expiration based on the given [response].
  ///
  /// - If the response contains an `Authorization` header:
  ///   - Extracts the token (removing `"Bearer"` prefix if present).
  ///   - Saves the token securely using [CacheHelper].
  ///
  /// - If the response has a `401 Unauthorized` status code:
  ///   - Navigates the user back to the root (`'/'`) using [GoRouter],
  ///     which typically represents a login or landing screen.
  ///
  /// Example usage inside a repository or data source:
  /// ```dart
  /// final response = await http.get(Uri.parse(apiUrl));
  /// await NetworkUtils.renewToken(response);
  /// ```
  static Future<void> renewToken(http.Response response) async {
    if (response.headers['authorization'] != null) {
      var token = response.headers['authorization'] as String;
      if (token.startsWith('Bearer')) {
        token = token.replaceFirst('Bearer', '').trim();
      }
      await sl<CacheHelper>().cacheSessionToken(token);
    } else if (response.statusCode == 401) {
      rootNavigatorKey.currentContext?.go('/');
    }
  }
}
