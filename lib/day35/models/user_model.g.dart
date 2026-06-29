// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  role: json['role'] as String?,
  emailVerifiedAt: json['email_verified_at'],
  isActive: json['is_active'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  batchId: json['batch_id'] as String?,
  trainingId: json['training_id'] as String?,
  jenisKelamin: json['jenis_kelamin'],
  profilePhoto: json['profile_photo'] as String?,
  onesignalPlayerId: json['onesignal_player_id'] as String?,
  batch: json['batch'] == null
      ? null
      : Batch.fromJson(json['batch'] as Map<String, dynamic>),
  training: json['training'] == null
      ? null
      : Training.fromJson(json['training'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'role': instance.role,
  'email_verified_at': instance.emailVerifiedAt,
  'is_active': instance.isActive,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
  'jenis_kelamin': instance.jenisKelamin,
  'profile_photo': instance.profilePhoto,
  'onesignal_player_id': instance.onesignalPlayerId,
  'batch': instance.batch,
  'training': instance.training,
};

Batch _$BatchFromJson(Map<String, dynamic> json) => Batch(
  id: (json['id'] as num?)?.toInt(),
  batchKe: json['batch_ke'] as String?,
  startDate: json['start_date'] == null
      ? null
      : DateTime.parse(json['start_date'] as String),
  endDate: json['end_date'] == null
      ? null
      : DateTime.parse(json['end_date'] as String),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$BatchToJson(Batch instance) => <String, dynamic>{
  'id': instance.id,
  'batch_ke': instance.batchKe,
  'start_date': instance.startDate?.toIso8601String(),
  'end_date': instance.endDate?.toIso8601String(),
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};

Training _$TrainingFromJson(Map<String, dynamic> json) => Training(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'],
  participantCount: json['participant_count'],
  standard: json['standard'],
  duration: json['duration'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$TrainingToJson(Training instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'participant_count': instance.participantCount,
  'standard': instance.standard,
  'duration': instance.duration,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
};
