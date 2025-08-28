import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ecomly_client/core/common/app/cache_helper.dart';
import 'package:ecomly_client/src/auth/data/datasources/auth_remote_data_source.dart';
import 'package:ecomly_client/src/auth/data/repositories/auth_repository_implementation.dart';
import 'package:ecomly_client/src/auth/domain/repositories/auth_repository.dart';
import 'package:ecomly_client/src/auth/domain/usecases/forgot_password.dart';
import 'package:ecomly_client/src/auth/domain/usecases/login.dart';
import 'package:ecomly_client/src/auth/domain/usecases/register.dart';
import 'package:ecomly_client/src/auth/domain/usecases/reset_password.dart';
import 'package:ecomly_client/src/auth/domain/usecases/verify_o_t_p.dart';
import 'package:ecomly_client/src/auth/domain/usecases/verify_token.dart';
import 'package:ecomly_client/src/user/data/datasources/user_remote_data_source.dart';
import 'package:ecomly_client/src/user/data/repositories/user_repository_implementation.dart';
import 'package:ecomly_client/src/user/domain/repositories/user_repository.dart';
import 'package:ecomly_client/src/user/domain/usecases/get_user.dart';
import 'package:ecomly_client/src/user/domain/usecases/get_user_payment_profile.dart';
import 'package:ecomly_client/src/user/domain/usecases/update_user.dart';

part 'injection_container.main.dart';
