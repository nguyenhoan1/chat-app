// To parse this JSON data, do
//
//     final profileResponse = profileResponseFromJson(jsonString);

import 'package:flutter_clean_architecture_bloc_template/domain/entities/user/profile_entity.dart';
import 'dart:convert';

ProfileResponse profileResponseFromJson(String str) =>
    ProfileResponse.fromJson(json.decode(str));

String profileResponseToJson(ProfileResponse data) =>
    json.encode(data.toJson());

class ProfileResponse extends ProfileEntity {
  const ProfileResponse({
    required super.id,
    required super.email,
    required super.password,
    required super.name,
    required super.role,
    required super.avatar,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      ProfileResponse(
        id: json["id"],
        email: json["email"],
        password: json["password"],
        name: json["name"],
        role: json["role"],
        avatar: json["avatar"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "name": name,
        "role": role,
        "avatar": avatar,
      };
}
