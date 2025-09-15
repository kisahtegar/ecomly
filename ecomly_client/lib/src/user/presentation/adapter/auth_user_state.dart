part of 'auth_user_provider.dart';

/// Represents all possible states for the authenticated user flow.
///
/// These states are used by the `AuthUserProvider` to reflect the current
/// operation (loading, success, error, etc.) related to the authenticated user.
sealed class AuthUserState extends Equatable {
  const AuthUserState();

  @override
  List<Object> get props => [];
}

/// Initial state before any user-related operation starts.
final class AuthUserInitial extends AuthUserState {
  const AuthUserInitial();
}

/// Indicates that user data is currently being fetched.
final class GettingUserData extends AuthUserState {
  const GettingUserData();
}

/// Indicates that the user's payment profile is currently being fetched.
final class GettingUserPaymentProfile extends AuthUserState {
  const GettingUserPaymentProfile();
}

/// Indicates that user data is currently being updated.
final class UpdatingUserData extends AuthUserState {
  const UpdatingUserData();
}

/// Represents the state when user data has been successfully fetched.
final class FetchedUser extends AuthUserState {
  const FetchedUser(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

/// Represents the state when user data has been successfully updated.
final class UserUpdated extends AuthUserState {
  const UserUpdated(this.user);

  final User user;

  @override
  List<Object> get props => [user];
}

/// Represents the state when the user's payment profile URL has been fetched.
final class FetchedUserPaymentProfile extends AuthUserState {
  const FetchedUserPaymentProfile(this.paymentProfileUrl);

  final String paymentProfileUrl;

  @override
  List<Object> get props => [paymentProfileUrl];
}

/// Represents an error state with the provided [message].
final class AuthUserError extends AuthUserState {
  const AuthUserError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
