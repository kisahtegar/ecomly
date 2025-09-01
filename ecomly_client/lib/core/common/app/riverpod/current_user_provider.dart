import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/core/common/entities/user.dart';

part 'current_user_provider.g.dart';

/// A Riverpod provider that manages the current authenticated [User] across
/// the application lifecycle.
///
/// This provider uses Riverpod's code generation with `@Riverpod` and is marked
/// with `keepAlive: true` to ensure the state remains available even when not
/// actively listened to. It exposes the current [User] object (or `null` if no
/// user is logged in) and provides a `setUser` method to update the state.
///
/// Centralizing the user state in this provider allows the rest of the app to
/// easily react to authentication changes, ensuring that user-dependent
/// features remain consistent.
///
/// ## Example:
/// ```dart
/// // Watch the current user
/// final user = ref.watch(currentUserProvider);
///
/// // Update the current user
/// ref.read(currentUserProvider.notifier).setUser(newUser);
/// ```
@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  /// Updates the current [User] state if the new user differs from the
  /// existing one. Pass `null` to represent a logged-out state.
  void setUser(User? user) {
    if (state != user) state = user;
  }
}
