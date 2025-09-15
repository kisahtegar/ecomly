import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/error_response.dart';
import 'package:ecomly_client/core/utils/network_utils.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/wishlist/data/models/wishlist_product_model.dart';

abstract class WishlistRemoteDataSrc {
  Future<List<WishlistProductModel>> getWishlist(String userId);

  Future<void> addToWishlist({
    required String userId,
    required String productId,
  });

  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  });
}

class WishlistRemoteDataSrcImpl implements WishlistRemoteDataSrc {
  const WishlistRemoteDataSrcImpl(this._client);

  final http.Client _client;

  /// Fetches the wishlist contents for a specific user.
  ///
  /// Sends a `GET` request to `/users/{userId}/wishlist` endpoint and returns a
  /// list of [WishlistProductModel].
  ///
  /// - [userId]: The ID of the user whose wishlist should be fetched.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<WishlistProductModel>> getWishlist(String userId) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        payload as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      payload as List<dynamic>;
      return payload
          .cast<DataMap>()
          .map(
            (wishlistProduct) => WishlistProductModel.fromMap(wishlistProduct),
          )
          .toList();
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

  /// Adds a product to the user's wishlist.
  ///
  /// Sends a `POST` request to `/users/{userId}/wishlist` endpoint with the
  /// provided [productId] in the request body.
  ///
  /// - [userId]: The ID of the user whose wishlist should be updated.
  /// - [productId]: The ID of the product to be added to the wishlist.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200` or `201`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> addToWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}',
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({'productId': productId}),
      );

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200 && response.statusCode != 201) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
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

  /// Removes a product from the user's wishlist.
  ///
  /// Sends a `DELETE` request to `/users/{userId}/wishlist/{productId}` endpoint
  /// to remove the specified product from the user's wishlist.
  ///
  /// - [userId]: The ID of the user whose wishlist should be updated.
  /// - [productId]: The ID of the product to be removed from the wishlist.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200` or `204`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> removeFromWishlist({
    required String userId,
    required String productId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userWishlistEndpoint(userId)}/$productId',
      );

      final response = await _client.delete(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200 && response.statusCode != 204) {
        final payload = jsonDecode(response.body) as DataMap;
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
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

  /// Builds the wishlist API endpoint for a specific user.
  String _userWishlistEndpoint(String userId) {
    return '/users/$userId/wishlist';
  }
}
