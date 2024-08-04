import 'dart:convert';

AuthLoginParams authLoginParamsFromJson(String str) => AuthLoginParams.fromJson(json.decode(str));

String authLoginParamsToJson(AuthLoginParams data) => json.encode(data.toJson());

class AuthLoginParams {
    final String? email;
    final String? password;

    AuthLoginParams({
        this.email,
        this.password,
    });

    factory AuthLoginParams.fromJson(Map<String, dynamic> json) => AuthLoginParams(
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "email": email,
        "password": password,
    };
}
