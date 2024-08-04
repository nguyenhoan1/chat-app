import 'dart:convert';

import 'package:flutter_clean_architecture_bloc_template/domain/entities/authentication/auth_login_entity.dart';

AuthLoginResponse authLoginResponseFromJson(String str) =>
    AuthLoginResponse.fromJson(json.decode(str));

String authLoginResponseToJson(AuthLoginResponse data) =>
    json.encode(data.toJson());

class AuthLoginResponse extends AuthLoginEntity {
  const AuthLoginResponse({
    required super.accessToken,
    required super.refreshToken,
  });

  factory AuthLoginResponse.fromJson(Map<String, dynamic> json) =>
      AuthLoginResponse(
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
