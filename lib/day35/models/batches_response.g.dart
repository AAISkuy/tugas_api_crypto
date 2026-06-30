// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batches_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchesResponse _$BatchesResponseFromJson(Map<String, dynamic> json) =>
    BatchesResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Batch.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BatchesResponseToJson(BatchesResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
