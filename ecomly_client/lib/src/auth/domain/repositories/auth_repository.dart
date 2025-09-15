import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

/// Contract for authentication-related operations.
///
/// Defines methods for registering, logging in, password management,
/// OTP verification, and token validation.
abstract class AuthRepository {
  const AuthRepository();

  /// Registers a new user with the given credentials.
  ResultFuture<void> register({
    required String name,
    required String password,
    required String email,
    required String phone,
  });

  /// Logs in a user with [email] and [password].
  ResultFuture<User> login({required String email, required String password});

  /// Initiates password reset flow for the given [email].
  ResultFuture<void> forgotPassword(String email);

  /// Verifies OTP sent to the given [email].
  ResultFuture<void> verifyOTP({required String email, required String otp});

  /// Resets password for the account associated with [email].
  ResultFuture<void> resetPassword({
    required String email,
    required String newPassword,
  });

  /// Validates the current authentication token.
  ResultFuture<bool> verifyToken();
}
