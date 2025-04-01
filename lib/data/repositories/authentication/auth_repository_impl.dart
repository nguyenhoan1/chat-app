import 'package:flutter_clean_architecture_bloc_template/data/data_source/remote/auth_remote_source.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_register_params.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_login_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_register_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/authentication/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteSource authRemoteSource;

  AuthRepositoryImpl({required this.authRemoteSource});
  @override
  // Future<AuthLoginEntity> login(AuthLoginParams params) {
  //   try {
  //     final authLogin = authRemoteSource.login(params);
  //     return authLogin;
  //   } catch (e) {
  //     throw Exception();
  //   }
  // }

  @override
  Future<AuthLoginEntity> register(AuthRegisterParams params) async {
    try {
      final response =
          await authRemoteSource.register(params);
      return response; 
    } catch (e) {
      throw Exception('Register failed: $e');
    }
  }
}
