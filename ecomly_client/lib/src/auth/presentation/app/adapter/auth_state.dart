part of 'auth_adapter.dart';

/// Represents all possible states for the authentication flow.
///
/// These states are used by the `AuthAdapter` to reflect the current
/// operation (loading, success, error, etc.) in the authentication process.
sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any authentication action begins.
final class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Indicates an authentication-related process is in progress.
final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Represents the state when an OTP has been successfully sent.
final class OTPSent extends AuthState {
  const OTPSent();
}

/// Represents the state when the user has successfully logged in.
final class LoggedIn extends AuthState {
  const LoggedIn(this.user);

  final User user;

  @override
  List<Object?> get props => [user];
}

/// Represents the state when registration is successful.
final class Registered extends AuthState {
  const Registered();
}

/// Represents the state when the password reset is successful.
final class PasswordReset extends AuthState {
  const PasswordReset();
}

/// Represents the state when an OTP is successfully verified.
final class OTPVerified extends AuthState {
  const OTPVerified();
}

/// Represents the state when a token has been verified. [isValid] indicates
/// whether the token is valid or expired.
final class TokenVerified extends AuthState {
  const TokenVerified(this.isValid);

  final bool isValid;

  @override
  List<Object?> get props => [isValid];
}

/// Represents an error state with the provided [message].
final class AuthError extends AuthState {
  const AuthError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
