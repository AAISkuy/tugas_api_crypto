// To parse this JSON data, do
//
//     final authService = authServiceFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'auth_service.g.dart';

AuthService authServiceFromJson(String str) =>
    AuthService.fromJson(json.decode(str));

String authServiceToJson(AuthService data) => json.encode(data.toJson());

@JsonSerializable()
class AuthService {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "errors")
  Errors? errors;

  AuthService({this.message, this.errors});

  factory AuthService.fromJson(Map<String, dynamic> json) =>
      _$AuthServiceFromJson(json);

  Map<String, dynamic> toJson() => _$AuthServiceToJson(this);
}

@JsonSerializable()
class Errors {
  @JsonKey(name: "name")
  List<String>? name;
  @JsonKey(name: "email")
  List<String>? email;
  @JsonKey(name: "password")
  List<String>? password;

  Errors({this.name, this.email, this.password});

  factory Errors.fromJson(Map<String, dynamic> json) => _$ErrorsFromJson(json);

  Map<String, dynamic> toJson() => _$ErrorsToJson(this);
}
