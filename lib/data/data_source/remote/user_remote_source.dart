import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/network/call_api_services.dart';

import '../../models/users/profile_response.dart';

abstract class UserRemoteSource {
  Future<ProfileResponse> getProfileUser(String accessToken);
}

class UserRemoteSourceImpl implements UserRemoteSource {
  final CallApiService callApiService;

  UserRemoteSourceImpl({required this.callApiService});
  @override
  Future<ProfileResponse> getProfileUser(String accessToken) async {
    return await callApiService.apiRequest(
      url: Constants.getProfileUser,
      method: Constants.GET,
      fromJson: (json) => ProfileResponse.fromJson(json),
      headers: {"Authorization": "Bearer $accessToken"},
    );
  }
}
