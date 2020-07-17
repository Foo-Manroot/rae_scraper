// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Imperativo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Imperativo _$ImperativoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['presente']);
  return Imperativo(
    json['presente'] == null
        ? null
        : TiempoVerbal.fromJson(json['presente'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ImperativoToJson(Imperativo instance) =>
    <String, dynamic>{
      'presente': instance.presente?.toJson(),
    };
