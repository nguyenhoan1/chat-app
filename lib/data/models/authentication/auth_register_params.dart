import 'dart:convert';

AuthRegisterParams authRegisterParamsFromJson(String str) =>
    AuthRegisterParams.fromJson(json.decode(str));

String authRegisterParamsToJson(AuthRegisterParams data) =>
    json.encode(data.toJson());

class AuthRegisterParams {
  final String? name;
  final String? email;
  final String? password;

  AuthRegisterParams({
    this.name,
    this.email,
    this.password,
  });

  factory AuthRegisterParams.fromJson(Map<String, dynamic> json) =>
      AuthRegisterParams(
        name: json["name"],
        email: json["email"],
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "password": password,
      };
}
