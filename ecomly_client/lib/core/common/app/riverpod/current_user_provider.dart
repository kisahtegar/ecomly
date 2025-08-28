import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ecomly_client/core/common/entities/user.dart';

part 'current_user_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  User? build() => null;

  void setUser(User? user) {
    if (state != user) state = user;
  }
}
