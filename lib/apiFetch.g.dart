// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiFetch.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
  json['uuid'] as String,
  json['username'] as String,
  json['email'] as String,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'username': instance.username,
  'email': instance.email,
};
