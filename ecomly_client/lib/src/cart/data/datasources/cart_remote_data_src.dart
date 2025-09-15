import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:ecomly_client/core/common/singletons/cache.dart';
import 'package:ecomly_client/core/errors/exceptions.dart';
import 'package:ecomly_client/core/extensions/colour_extensions.dart';
import 'package:ecomly_client/core/extensions/string_extensions.dart';
import 'package:ecomly_client/core/utils/constants/network_constants.dart';
import 'package:ecomly_client/core/utils/error_response.dart';
import 'package:ecomly_client/core/utils/network_utils.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/cart/data/models/cart_product_model.dart';
import 'package:ecomly_client/src/cart/domain/entities/cart_product.dart';

abstract class CartRemoteDataSrc {
  Future<List<CartProductModel>> getCart(String userId);

  Future<int> getCartCount(String userId);

  Future<CartProductModel> getCartProduct({
    required String userId,
    required String cartProductId,
  });

  Future<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  });

  Future<void> removeFromCart({
    required String userId,
    required String cartProductId,
  });

  Future<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  });

  Future<String> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  });
}

class CartRemoteDataSrcImpl implements CartRemoteDataSrc {
  const CartRemoteDataSrcImpl(this._client);

  final http.Client _client;

  /// Fetches the cart contents for a specific user.
  ///
  /// Sends a `GET` request to `/users/{userId}/cart` endpoint and returns a
  /// list of [CartProductModel].
  ///
  /// - [userId]: The ID of the user whose cart should be fetched.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<CartProductModel>> getCart(String userId) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}',
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
          .map((cartProduct) => CartProductModel.fromMap(cartProduct))
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

  /// Fetches the total number of items in a user's cart.
  ///
  /// Sends a `GET` request to `/users/{userId}/cart/count` endpoint and
  /// returns the item count as an [int].
  ///
  /// - [userId]: The ID of the user whose cart count should be fetched.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<int> getCartCount(String userId) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}/count',
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

      return (payload as num).toInt();
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

  /// Fetches a single cart product by its ID for a specific user.
  ///
  /// Sends a `GET` request to `/users/{userId}/cart/{cartProductId}` endpoint
  /// and returns a [CartProductModel] representing the requested cart item.
  ///
  /// - [userId]: The ID of the user who owns the cart.
  /// - [cartProductId]: The ID of the cart product to retrieve.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<CartProductModel> getCartProduct({
    required String userId,
    required String cartProductId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}/$cartProductId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
        throw ServerException(
          message: errorResponse.errorMessage,
          statusCode: response.statusCode,
        );
      }

      return CartProductModel.fromMap(payload);
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

  /// Adds a product to a user's cart.
  ///
  /// Sends a `POST` request to `/users/{userId}/cart` endpoint with product
  /// details such as product ID, quantity, and optional size/colour.
  ///
  /// - [userId]: The ID of the user who owns the cart.
  /// - [cartProduct]: The product to add, represented as a [CartProduct].
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200` or `201`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> addToCart({
    required String userId,
    required CartProduct cartProduct,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}',
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({
          'productId': cartProduct.productId,
          'quantity': cartProduct.quantity,
          if (cartProduct.selectedSize != null)
            'selectedSize': cartProduct.selectedSize,
          if (cartProduct.selectedColour != null)
            'selectedColour': cartProduct.selectedColour!.hex,
        }),
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

  /// Removes a specific product from a user's cart.
  ///
  /// Sends a `DELETE` request to `/users/{userId}/cart/{cartProductId}`
  /// endpoint to remove the given cart item.
  ///
  /// - [userId]: The ID of the user who owns the cart.
  /// - [cartProductId]: The ID of the cart product to remove.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200` or `204`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> removeFromCart({
    required String userId,
    required String cartProductId,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}/$cartProductId',
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

  /// Updates the quantity of a specific product in a user's cart.
  ///
  /// Sends a `PUT` request to `/users/{userId}/cart/{cartProductId}`
  /// endpoint with the new quantity.
  ///
  /// - [userId]: The ID of the user who owns the cart.
  /// - [cartProductId]: The ID of the cart product to update.
  /// - [newQuantity]: The updated quantity for the cart product.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> changeCartProductQuantity({
    required String userId,
    required String cartProductId,
    required int newQuantity,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}${_userCartEndpoint(userId)}/$cartProductId',
      );

      final response = await _client.put(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({'quantity': newQuantity}),
      );

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
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

  /// Builds the user-specific cart endpoint path.
  String _userCartEndpoint(String userId) => '/users/$userId/cart';

  /// Initiates the checkout process for a user's cart.
  ///
  /// Sends a `POST` request to `/checkout` endpoint with cart item details
  /// and returns a checkout URL provided by the backend (e.g., Stripe session URL).
  ///
  /// - [theme]: The checkout theme (e.g., "light" or "dark"), passed as a query parameter.
  /// - [cartItems]: The list of cart products to include in the checkout,
  ///   represented as [CartProduct].
  ///
  /// Returns a [String] representing the checkout URL to redirect the user.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `201`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<String> initiateCheckout({
    required String theme,
    required List<CartProduct> cartItems,
  }) async {
    try {
      final uri = Uri.http(
        NetworkConstants.authority,
        '${NetworkConstants.apiUrl}/checkout',
        {'theme': theme},
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({
          'cartItems': cartItems.map((cartProduct) {
            return {
              "name": cartProduct.productName,
              "images": [cartProduct.productImage],
              "price": cartProduct.productPrice,
              "productId": cartProduct.productId,
              "cartProductId": cartProduct.id,
              "quantity": cartProduct.quantity,
              if (cartProduct case CartProduct(:final selectedSize))
                "selectedSize": selectedSize,
              if (cartProduct case CartProduct(:final Color selectedColour))
                "selectedColour": selectedColour.hex,
            };
          }).toList(),
        }),
      );

      // Refreshes token if expired
      await NetworkUtils.renewToken(response);

      final payload = jsonDecode(response.body) as DataMap;
      if (response.statusCode != 201) {
        final errorResponse = ErrorResponse.fromMap(payload);
        debugPrint(response.body);
        debugPrintStack();
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
}
