// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ecomly_client/core/common/models/user_model.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/error_response.dart';
import 'package:ecomly_client/core/utils/network_utils.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> getUser(String userId);

  Future<UserModel> updateUser({
    required String userId,
    required DataMap updateData,
  });

  Future<String> getUserPaymentProfile(String userId);
}

const USERS_ENDPOINT = '/users';

/// User Remote Data Source Implementation
///
/// Handles all user-related network requests such as fetching user details,
/// updating user information, and retrieving the user’s payment profile.
/// Communicates directly with the backend API and throws [ServerException]
/// on failure.
class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  const UserRemoteDataSourceImpl(this._client);

  final http.Client _client;

  /// Fetches a single [UserModel] from the remote API using the provided [userId].
  ///
  /// This method sends a `GET` request to the `/users/{userId}` endpoint, including
  /// authentication headers from the cached session token. After receiving the response:
  /// - It attempts to renew the session token if necessary.
  /// - If the status code is `200`, the response payload is deserialized into a [UserModel].
  /// - If the status code is not `200`, a [ServerException] is thrown with details from
  ///   the error response.
  ///
  /// Throws:
  /// - [ServerException] if the request fails due to server error or unexpected issues.
  @override
  Future<UserModel> getUser(String userId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return UserModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  /// Retrieves the payment profile URL for a given user.
  ///
  /// This method sends a `GET` request to `/users/{userId}/paymentProfile`,
  /// using authentication headers from the cached session token. After
  /// processing the response:
  /// - If the status code is `200`, the method extracts and returns the `url`
  ///   field from the response payload.
  /// - If the status code is not `200`, it throws a [ServerException] with
  ///   details from the error response.
  ///
  /// Throws:
  /// - [ServerException] if the request fails due to server error or other
  ///   unexpected issues.
  @override
  Future<String> getUserPaymentProfile(String userId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId/paymentProfile',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return payload['url'] as String;
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }

  /// Updates a user's information on the server.
  ///
  /// This method sends a `PUT` request to `/users/{userId}` with the provided
  /// [updateData] in the request body. After processing the response:
  /// - If the status code is `200` or `201`, the method parses and returns
  ///   the updated [UserModel].
  /// - If the status code indicates an error, it throws a [ServerException]
  ///   with details from the error response.
  ///
  /// Parameters:
  /// - [userId]: The unique identifier of the user to update.
  /// - [updateData]: A key-value map containing the fields to update.
  ///
  /// Throws:
  /// - [ServerException] if the request fails due to server error or other
  ///   unexpected issues.
  @override
  Future<UserModel> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$USERS_ENDPOINT/$userId',
      );

      final response = await _client.put(
        uri,
        body: jsonEncode(updateData),
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body) as DataMap;
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return UserModel.fromMap(payload);
    } on ServerException {
      rethrow;
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: s);
      throw const ServerException(
        message: "Error Occurred: It's not your fault, it's ours",
        statusCode: 500,
      );
    }
  }
}
