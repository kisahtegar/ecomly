// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_user_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentUserHash() => r'90c510432114c0ba028295c3b65ebe07deb0d466';

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
///
/// Copied from [CurrentUser].
@ProviderFor(CurrentUser)
final currentUserProvider = NotifierProvider<CurrentUser, User?>.internal(
  CurrentUser.new,
  name: r'currentUserProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentUserHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentUser = Notifier<User?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
