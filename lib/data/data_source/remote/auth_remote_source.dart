import 'package:flutter_clean_architecture_bloc_template/core/constants/constants.dart';
import 'package:flutter_clean_architecture_bloc_template/core/network/call_api_services.dart';

import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_params.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_login_response.dart';
import 'package:flutter_clean_architecture_bloc_template/data/models/authentication/auth_register_params.dart';

abstract class AuthRemoteSource {
  // Future<AuthLoginResponse> login(AuthLoginParams params);
  Future<AuthLoginResponse> register(AuthRegisterParams params);
}

class AuthRemoteSourceImpl implements AuthRemoteSource {
  final CallApiService callApiService;

  AuthRemoteSourceImpl({required this.callApiService});
  @override
  // Future<AuthLoginResponse> login(AuthLoginParams params) async {
  //   return await callApiService.apiRequest(
  //     url: Constants.loginUrl,
  //     method: Constants.POST,
  //     fromJson: (json) => AuthLoginResponse.fromJson(json),
  //     params: params.toJson(),
  //   );
  // }

  @override
  Future<AuthLoginResponse> register(AuthRegisterParams params) async {
    return await callApiService.apiRequest(
      url: Constants.registerUrl, 
      method: Constants.POST,
      fromJson: (json) => AuthLoginResponse.fromJson(json),
      params: params.toJson(),
    );
  }
}