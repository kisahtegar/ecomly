// ignore_for_file: constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/core/common/models/user_model.dart';
import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/error_response.dart';
import 'package:ecomly_client/core/utils/network_utils.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

abstract class AuthRemoteDataSource {
  const AuthRemoteDataSource();

  Future<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  });

  Future<UserModel> login({required String email, required String password});

  Future<void> forgotPassword(String email);

  Future<void> verifyOTP({required String email, required String otp});

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  });

  Future<bool> verifyToken();
}

const REGISTER_ENDPOINT = '/register';
const LOGIN_ENDPOINT = '/login';
const FORGOT_PASSWORD_ENDPOINT = '/forgot-password';
const VERIFY_OTP_ENDPOINT = '/verify-otp';
const RESET_PASSWORD_ENDPOINT = '/reset-password';
const VERIFY_TOKEN_ENDPOINT = '/verify-token';

/// Authentication Remote Data Source Implementation
///
/// Provides concrete implementations for handling authentication-related network
/// requests such as login, registration, token verification, password recovery,
/// and OTP verification.
///
/// This class communicates directly with the backend API, processes responses,
/// and throws appropriate exceptions (e.g., [ServerException]) when requests fail.
/// It serves as the bridge between the `AuthRepository` and the remote server.
class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImplementation(this._client);

  final http.Client _client;

  /// Sends a password reset request for the given [email].
  ///
  /// This method sends a `POST` request to `/auth/forgotPassword` with the
  /// user's email in the request body. After processing the response:
  /// - If the status code is `200`, the request is considered successful.
  /// - If the status code is not `200`, it parses the error response and throws
  ///   a [ServerException] with details from the backend.
  ///
  /// Throws:
  /// - [ServerException] if the request fails due to server error or other
  ///   unexpected issues.
  @override
  Future<void> forgotPassword(String email) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$FORGOT_PASSWORD_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        body: jsonEncode({'email': email}),
        headers: NetworkConstants.headers,
      );

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
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

  /// Authenticates a user with the provided [email] and [password].
  ///
  /// This method sends a `POST` request to `/auth/login` with the user's
  /// credentials in the request body. After receiving the response:
  /// - If the status code is `200`, it caches the session token and user ID,
  ///   then parses and returns the [UserModel].
  /// - If the status code is not `200`, it parses the error response and throws
  ///   a [ServerException] with the backend-provided message.
  ///
  /// Throws:
  /// - [ServerException] if the login fails due to server error, invalid
  ///   credentials, or other unexpected issues.
  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$LOGIN_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({'password': password, 'email': email}),
        headers: NetworkConstants.headers,
      );
      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      await sl<CacheHelper>().cacheSessionToken(payload['accessToken']);
      final user = UserModel.fromMap(payload);
      await sl<CacheHelper>().cacheUserId(user.id);
      return user;
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

  /// Registers a new user with the provided [name], [email], [password], and [phone].
  ///
  /// This method sends a `POST` request to `/auth/register` with the user's
  /// information in the request body. After receiving the response:
  /// - If the status code is `200` or `201`, the registration is considered
  ///   successful.
  /// - If the status code indicates an error, it parses the error response and
  ///   throws a [ServerException] with the backend-provided message.
  ///
  /// Parameters:
  /// - [name]: The full name of the user.
  /// - [email]: The user's email address.
  /// - [password]: The user's chosen password.
  /// - [phone]: The user's phone number.
  ///
  /// Throws:
  /// - [ServerException] if registration fails due to server error, validation
  ///   issues, or other unexpected problems.
  @override
  Future<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  }) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$REGISTER_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({
          'name': name,
          'password': password,
          'email': email,
          'phone': phone,
        }),
        headers: NetworkConstants.headers,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
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

  /// Resets the password for the user with the provided [email].
  ///
  /// This method sends a `POST` request to `/auth/reset-password` with the
  /// user's email and new password in the request body. After processing the
  /// response:
  /// - If the status code is `200`, the password reset is considered successful.
  /// - If the status code indicates an error, it parses the error response and
  ///   throws a [ServerException] with the backend-provided message.
  ///
  /// Parameters:
  /// - [email]: The email address of the user whose password is to be reset.
  /// - [newPassword]: The new password to set for the user.
  ///
  /// Throws:
  /// - [ServerException] if the password reset fails due to server error,
  ///   validation issues, or other unexpected problems.
  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$RESET_PASSWORD_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        body: jsonEncode({'newPassword': newPassword, 'email': email}),
        headers: NetworkConstants.headers,
      );

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
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

  /// Verifies a one-time password (OTP) for the given [email].
  ///
  /// This method sends a `POST` request to `/auth/verify-otp` with the user's
  /// email and OTP in the request body. After processing the response:
  /// - If the status code is `200`, the OTP verification is successful.
  /// - If the status code indicates an error, it parses the error response and
  ///   throws a [ServerException] with details from the backend.
  ///
  /// Parameters:
  /// - [email]: The email address of the user to verify.
  /// - [otp]: The one-time password sent to the user's email.
  ///
  /// Throws:
  /// - [ServerException] if the OTP verification fails due to server error,
  ///   invalid OTP, or other unexpected issues.
  @override
  Future<void> verifyOTP({required String email, required String otp}) async {
    try {
      final uri = Uri.parse('${NetworkConstants.baseUrl}$VERIFY_OTP_ENDPOINT');

      final response = await _client.post(
        uri,
        body: jsonEncode({'email': email, 'otp': otp}),
        headers: NetworkConstants.headers,
      );

      if (response.statusCode != 200) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
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

  /// Verifies whether the current session token is still valid.
  ///
  /// This method sends a `GET` request to `/auth/verify-token` using the
  /// authentication headers from the cached session token. After processing the response:
  /// - If the status code is `200`, it returns `true` or `false` depending on
  ///   the validity of the token.
  /// - If the status code indicates an error, it parses the error response and
  ///   throws a [ServerException] with details from the backend.
  ///
  /// Throws:
  /// - [ServerException] if token verification fails due to server error,
  ///   invalid token, or other unexpected issues.
  @override
  Future<bool> verifyToken() async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$VERIFY_TOKEN_ENDPOINT',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body);
      await NetworkUtils.renewToken(response);
      if (response.statusCode != 200) {
        payload as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }
      return payload as bool;
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
