import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tugas_api_crypto/day35/models/user_model.dart';

part 'all_users_response.g.dart';

AllUsersResponse allUsersResponseFromJson(String str) =>
    AllUsersResponse.fromJson(json.decode(str));

String allUsersResponseToJson(AllUsersResponse data) => json.encode(data.toJson());

@JsonSerializable()
class AllUsersResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<UserModel>? data;

  AllUsersResponse({this.message, this.data});

  factory AllUsersResponse.fromJson(Map<String, dynamic> json) =>
      _$AllUsersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AllUsersResponseToJson(this);
}
