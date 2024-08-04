import 'package:flutter_clean_architecture_bloc_template/data/data_source/remote/user_remote_source.dart';
import 'package:flutter_clean_architecture_bloc_template/domain/entities/user/profile_entity.dart';

import '../../../domain/repositories/user/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteSource userRemoteSource;

  UserRepositoryImpl({required this.userRemoteSource});
  @override
  Future<ProfileEntity> getProfileUser(String accessToken) async {
    return await userRemoteSource.getProfileUser(accessToken);
  }
}