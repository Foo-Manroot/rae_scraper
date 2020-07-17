// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Subjuntivo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Subjuntivo _$SubjuntivoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['presente', 'futuro', 'pret_imperf']);
  return Subjuntivo(
    json['presente'] == null
        ? null
        : TiempoVerbal.fromJson(json['presente'] as Map<String, dynamic>),
    json['futuro'] == null
        ? null
        : TiempoVerbal.fromJson(json['futuro'] as Map<String, dynamic>),
    json['pret_imperf'] == null
        ? null
        : TiempoVerbal.fromJson(json['pret_imperf'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$SubjuntivoToJson(Subjuntivo instance) =>
    <String, dynamic>{
      'presente': instance.presente?.toJson(),
      'futuro': instance.futuro?.toJson(),
      'pret_imperf': instance.pret_imperf?.toJson(),
    };
