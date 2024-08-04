import 'package:flutter_clean_architecture_bloc_template/core/network/usecase.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/user/profile_entity.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/repositories/user/user_repository.dart';

class GetProfileUsecase implements UseCase<ProfileEntity, String> {
  final UserRepository userRepository;

  GetProfileUsecase({required this.userRepository});
  @override
  Future<ProfileEntity> call(String params) async {
    return await userRepository.getProfileUser(params);
  }
}
