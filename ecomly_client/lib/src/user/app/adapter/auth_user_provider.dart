import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/core/common/app/riverpod/current_user_provider.dart';
import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/services/injection_container.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';
import 'package:ecomly_client/src/user/domain/usecases/get_user.dart';
import 'package:ecomly_client/src/user/domain/usecases/get_user_payment_profile.dart';
import 'package:ecomly_client/src/user/domain/usecases/update_user.dart';

part 'auth_user_provider.g.dart';
part 'auth_user_state.dart';

@riverpod
class AuthUser extends _$AuthUser {
  @override
  AuthUserState build([GlobalKey? familyKey]) {
    _getUser = sl<GetUser>();
    _updateUser = sl<UpdateUser>();
    _getUserPaymentProfile = sl<GetUserPaymentProfile>();
    return const AuthUserInitial();
  }

  late GetUser _getUser;
  late UpdateUser _updateUser;
  late GetUserPaymentProfile _getUserPaymentProfile;

  Future<void> getUserById(String userId) async {
    state = const GettingUserData();
    final result = await _getUser(userId);

    result.fold((failure) => state = AuthUserError(failure.errorMessage), (
      user,
    ) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = UserUpdated(user);
    });
  }

  Future<void> updateUser({
    required String userId,
    required DataMap updateData,
  }) async {
    state = const UpdatingUserData();
    final result = await _updateUser(
      UpdateUserParams(userId: userId, updateData: updateData),
    );

    result.fold((failure) => state = AuthUserError(failure.errorMessage), (
      user,
    ) {
      ref.read(currentUserProvider.notifier).setUser(user);
      state = UserUpdated(user);
    });
  }

  Future<void> getUserPaymentProfile(String userId) async {
    state = const GettingUserPaymentProfile();
    final result = await _getUserPaymentProfile(userId);

    result.fold(
      (failure) => state = AuthUserError(failure.errorMessage),
      (paymentProfileUrl) =>
          state = FetchedUserPaymentProfile(paymentProfileUrl),
    );
  }
}
