import 'package:ecomly_client/core/common/entities/user.dart';
import 'package:ecomly_client/core/utils/typedefs.dart';

abstract class UserRepository {
  const UserRepository();

  ResultFuture<User> getUser(String userId);

  ResultFuture<User> updateUser({
    required String userId,
    required DataMap updateData,
  });

  ResultFuture<String> getUserPaymentProfile(String userId);
}
