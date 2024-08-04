import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_login_entity.dart';

abstract class AuthRepository {
  Future<AuthLoginEntity> login(AuthLoginParams params);
}