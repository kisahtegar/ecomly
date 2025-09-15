import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

/// Defines the contract for user-related data operations.
///
/// Implementations of this repository are responsible for handling user data,
/// either from remote APIs or local sources. Each method returns a [ResultFuture]
/// that contains either a successful result or a [Failure].
abstract class UserRepository {
  const UserRepository();

  /// Gets a [User] by the given [userId].
  ResultFuture<User> getUser(String userId);

  /// Updates a [User] identified by [userId] with [updateData].
  ResultFuture<User> updateUser({
    required String userId,
    required DataMap updateData,
  });

  /// Retrieves the payment profile ID linked to the given [userId].
  ResultFuture<String> getUserPaymentProfile(String userId);
}
