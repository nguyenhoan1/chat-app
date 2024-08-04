import '../../entities/user/profile_entity.dart';

abstract class UserRepository {
  Future<ProfileEntity> getProfileUser (String accessToken);
}