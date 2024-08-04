import 'package:flutter_clean_architecture_bloc_template/core/network/usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_login_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/authentication/auth_repository.dart';

class LoginUseCase implements UseCase<AuthLoginEntity, AuthLoginParams> {
  final AuthRepository authRepository;

  LoginUseCase({required this.authRepository});
  @override
  Future<AuthLoginEntity> call(AuthLoginParams params) async {
    return await authRepository.login(params);
  }
}
