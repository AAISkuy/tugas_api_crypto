import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
import 'package:tugas_api_crypto/day35/models/user_model.dart';

part 'trainings_response.g.dart';

TrainingsResponse trainingsResponseFromJson(String str) =>
    TrainingsResponse.fromJson(json.decode(str));

String trainingsResponseToJson(TrainingsResponse data) => json.encode(data.toJson());

@JsonSerializable()
class TrainingsResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<Training>? data;

  TrainingsResponse({this.message, this.data});

  factory TrainingsResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingsResponseToJson(this);
}

@JsonSerializable()
class TrainingDetailResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  Training? data;

  TrainingDetailResponse({this.message, this.data});

  factory TrainingDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainingDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingDetailResponseToJson(this);
}
