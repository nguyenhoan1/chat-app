import 'package:flutter_clean_architecture_bloc_template/core/network/usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_register_params.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_register_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/authentication/auth_repository.dart';

import '../../entities/authentication/auth_login_entity.dart';

class RegisterUseCase implements UseCase<AuthLoginEntity, AuthRegisterParams> {
  final AuthRepository authRepository;

  RegisterUseCase({required this.authRepository});

  @override
  Future<AuthLoginEntity> call(AuthRegisterParams params) async {
    return await authRepository.register(params);
  }
}
