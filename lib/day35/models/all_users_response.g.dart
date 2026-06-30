// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'all_users_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AllUsersResponse _$AllUsersResponseFromJson(Map<String, dynamic> json) =>
    AllUsersResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AllUsersResponseToJson(AllUsersResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
