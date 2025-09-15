// ignore_for_file: constant_identifier_names

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
import 'package:ecomly_client/src/product/data/models/category_model.dart';
import 'package:ecomly_client/src/product/data/models/product_model.dart';
import 'package:ecomly_client/src/product/data/models/review_model.dart';

abstract interface class ProductRemoteDataSrc {
  const ProductRemoteDataSrc();

  Future<List<ProductModel>> getProducts(int page);

  Future<ProductModel> getProduct(String productId);

  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
  });

  Future<List<ProductModel>> getNewArrivals({
    required int page,
    String? categoryId,
  });

  Future<List<ProductModel>> getPopular({
    required int page,
    String? categoryId,
  });

  Future<List<ProductModel>> searchAllProducts({
    required String query,
    required int page,
  });

  Future<List<ProductModel>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  });

  Future<List<ProductModel>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  });

  Future<List<ProductCategoryModel>> getCategories();

  Future<ProductCategoryModel> getCategory(String categoryId);

  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  });

  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    required int page,
  });
}

const GET_PRODUCTS_ENDPOINT = '/products';
const SEARCH_PRODUCTS_ENDPOINT = '$GET_PRODUCTS_ENDPOINT/search';
const GET_CATEGORIES_ENDPOINT = '/categories';
const GET_PRODUCT_REVIEWS_ENDPOINT = '/reviews';

class ProductRemoteDataSrcImpl implements ProductRemoteDataSrc {
  const ProductRemoteDataSrcImpl(this._client);

  final http.Client _client;

  /// Fetches all available product categories.
  ///
  /// Sends a `GET` request to `/categories` endpoint and returns a list of
  /// [ProductCategoryModel] objects representing available categories.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_CATEGORIES_ENDPOINT',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((category) => ProductCategoryModel.fromMap(category))
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

  /// Fetches details of a specific product category by its ID.
  ///
  /// Sends a `GET` request to `/categories/{categoryId}` endpoint and returns
  /// a [ProductCategoryModel] containing details such as the category's name,
  /// colour, and image.
  ///
  /// - [categoryId]: The ID of the category to fetch.
  ///
  /// Returns a [ProductCategoryModel] on success.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<ProductCategoryModel> getCategory(String categoryId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_CATEGORIES_ENDPOINT/$categoryId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;

      // Refresh token if expired
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

      return ProductCategoryModel.fromMap(payload);
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

  /// Fetches a paginated list of newly arrived products.
  ///
  /// Sends a `GET` request to `/products` with query parameters:
  /// - `criteria=newArrivals` (to filter for new arrivals).
  /// - `category` (optional, if provided filters by category).
  /// - `page` (for pagination).
  ///
  /// - [page]: The page number of results to fetch.
  /// - [categoryId]: (Optional) The ID of the category to filter new arrivals by.
  ///
  /// Returns a list of [ProductModel] representing newly added products.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> getNewArrivals({
    required int page,
    String? categoryId,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {
        'criteria': 'newArrivals',
        if (categoryId != null) 'category': categoryId,
        'page': '$page',
      };

      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Fetches a paginated list of popular products.
  ///
  /// Sends a `GET` request to `/products` with query parameters:
  /// - `criteria=popular` (to filter for popular products).
  /// - `category` (optional, if provided filters by category).
  /// - `page` (for pagination).
  ///
  /// - [page]: The page number of results to fetch.
  /// - [categoryId]: (Optional) The ID of the category to filter popular products by.
  ///
  /// Returns a list of [ProductModel] representing the most popular products.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> getPopular({
    required int page,
    String? categoryId,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {
        'criteria': 'popular',
        if (categoryId != null) 'category': categoryId,
        'page': '$page',
      };

      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Fetches detailed information about a specific product.
  ///
  /// Sends a `GET` request to `/products/{productId}` endpoint and returns
  /// the corresponding [ProductModel].
  ///
  /// - [productId]: The unique ID of the product to retrieve.
  ///
  /// Returns a [ProductModel] containing detailed product data including
  /// name, description, price, stock, category, and more.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<ProductModel> getProduct(String productId) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_PRODUCTS_ENDPOINT/$productId',
      );

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body) as DataMap;

      // Refresh token if expired
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

      return ProductModel.fromMap(payload);
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

  /// Fetches reviews for a specific product.
  ///
  /// Sends a `GET` request to `/products/{productId}/reviews` endpoint and
  /// returns a paginated list of [ReviewModel].
  ///
  /// - [productId]: The unique ID of the product whose reviews should be fetched.
  /// - [page]: The page number for paginated review results.
  ///
  /// Returns a list of [ReviewModel] containing user feedback, ratings,
  /// comments, and review metadata.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ReviewModel>> getProductReviews({
    required String productId,
    required int page,
  }) async {
    try {
      final endpoint =
          '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT'
          '/$productId$GET_PRODUCT_REVIEWS_ENDPOINT';

      final queryParams = {'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((review) => ReviewModel.fromMap(review))
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

  /// Fetches a paginated list of all products.
  ///
  /// Sends a `GET` request to `/products` endpoint and returns a
  /// list of [ProductModel].
  ///
  /// - [page]: The page number for paginated product results.
  ///
  /// Returns a list of [ProductModel] containing product details such as
  /// name, description, price, stock availability, category, and images.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> getProducts(int page) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Fetches products filtered by category with pagination support.
  ///
  /// Sends a `GET` request to `/products` endpoint with query parameters
  /// for category and page number, returning a list of [ProductModel].
  ///
  /// - [categoryId]: The ID of the category to filter products by.
  /// - [page]: The page number for paginated product results.
  ///
  /// Returns a list of [ProductModel] containing products that belong
  /// to the specified category.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> getProductsByCategory({
    required String categoryId,
    required int page,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$GET_PRODUCTS_ENDPOINT';

      final queryParams = {'category': categoryId, 'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );
      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Submits a review for a specific product.
  ///
  /// Sends a `POST` request to `/products/{productId}/reviews` endpoint with
  /// the review details. The request body contains the user ID, comment, and rating.
  ///
  /// - [productId]: The ID of the product being reviewed.
  /// - [userId]: The ID of the user submitting the review.
  /// - [comment]: The review text provided by the user.
  /// - [rating]: The rating score given by the user (e.g., 1.0–5.0).
  ///
  /// Does not return any data on success, only ensures the review was submitted.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200` or `201`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<void> leaveReview({
    required String productId,
    required String userId,
    required String comment,
    required double rating,
  }) async {
    try {
      final uri = Uri.parse(
        '${NetworkConstants.baseUrl}$GET_PRODUCTS_ENDPOINT'
        '/$productId$GET_PRODUCT_REVIEWS_ENDPOINT',
      );

      final response = await _client.post(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
        body: jsonEncode({
          'user': userId,
          'comment': comment,
          'rating': rating,
        }),
      );

      // Refresh token if expired
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

  /// Searches across all products with a given query.
  ///
  /// Sends a `GET` request to `/products/search` endpoint with the provided
  /// [query] string and pagination [page].
  ///
  /// - [query]: The search term entered by the user (e.g., "shoes").
  /// - [page]: The page number for pagination, starting from 1.
  ///
  /// Returns a list of [ProductModel] matching the search term across all
  /// available categories.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> searchAllProducts({
    required String query,
    required int page,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {'q': query, 'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Searches products by category with a given query.
  ///
  /// Sends a `GET` request to `/products/search` endpoint with the provided
  /// [query] string, restricted to the specified [categoryId], and supports
  /// pagination via [page].
  ///
  /// - [query]: The search term entered by the user (e.g., "jacket").
  /// - [categoryId]: The ID of the category to narrow down the search.
  /// - [page]: The page number for pagination, starting from 1.
  ///
  /// Returns a list of [ProductModel] that match the query within the given
  /// category.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> searchByCategory({
    required String query,
    required String categoryId,
    required int page,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {'q': query, 'category': categoryId, 'page': '$page'};
      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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

  /// Searches products by category and gender/age category with a given query.
  ///
  /// Sends a `GET` request to `/products/search` endpoint with the provided
  /// [query], restricted to both [categoryId] and [genderAgeCategory], and
  /// supports pagination via [page].
  ///
  /// - [query]: The search term entered by the user (e.g., "running shoes").
  /// - [categoryId]: The ID of the category to narrow down the search.
  /// - [genderAgeCategory]: An additional filter such as "men", "women",
  ///   "kids", etc., used to refine search results by audience.
  /// - [page]: The page number for pagination, starting from 1.
  ///
  /// Returns a list of [ProductModel] that match the query filtered by the
  /// given category and gender/age group.
  ///
  /// Throws a [ServerException] if:
  /// - The API response status code is not `200`.
  /// - The response body contains an error message.
  /// - Any unexpected error occurs (rethrows as `ServerException`).
  @override
  Future<List<ProductModel>> searchByCategoryAndGenderAgeCategory({
    required String query,
    required String categoryId,
    required String genderAgeCategory,
    required int page,
  }) async {
    try {
      final endpoint = '${NetworkConstants.apiUrl}$SEARCH_PRODUCTS_ENDPOINT';

      final queryParams = {
        'q': query,
        'category': categoryId,
        'genderAgeCategory': genderAgeCategory,
        'page': '$page',
      };

      final uri = NetworkConstants.baseUrl.startsWith('https')
          ? Uri.https(NetworkConstants.authority, endpoint, queryParams)
          : Uri.http(NetworkConstants.authority, endpoint, queryParams);

      final response = await _client.get(
        uri,
        headers: Cache.instance.sessionToken!.toAuthHeaders,
      );

      final payload = jsonDecode(response.body);

      // Refresh token if expired
      await NetworkUtils.renewToken(response);

      if (response.statusCode != 200) {
        final errorResponse = ErrorResponse.fromMap(payload as DataMap);
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
          .map((product) => ProductModel.fromMap(product))
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
}
