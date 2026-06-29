// To parse this JSON data, do
//
//     final authResponse = authResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:tugas_api_crypto/models/user_model.dart';

part 'profile_response.g.dart';

AuthResponse authResponseFromJson(String str) =>
    AuthResponse.fromJson(json.decode(str));

String authResponseToJson(AuthResponse data) => json.encode(data.toJson());

@JsonSerializable()
class AuthResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  AuthData? data;

  AuthResponse({this.message, this.data});

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AuthResponseToJson(this);
}

@JsonSerializable()
class AuthData {
  @JsonKey(name: "token")
  String? token;
  @JsonKey(name: "user")
  UserModel? user;

  AuthData({this.token, this.user});

  factory AuthData.fromJson(Map<String, dynamic> json) =>
      _$AuthDataFromJson(json);

  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}
