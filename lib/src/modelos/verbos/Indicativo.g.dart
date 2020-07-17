// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Indicativo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Indicativo _$IndicativoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'presente',
    'pret_imperf',
    'pret_perf_simple',
    'futuro',
    'condicional'
  ]);
  return Indicativo(
    json['presente'] == null
        ? null
        : TiempoVerbal.fromJson(json['presente'] as Map<String, dynamic>),
    json['pret_imperf'] == null
        ? null
        : TiempoVerbal.fromJson(json['pret_imperf'] as Map<String, dynamic>),
    json['pret_perf_simple'] == null
        ? null
        : TiempoVerbal.fromJson(
            json['pret_perf_simple'] as Map<String, dynamic>),
    json['futuro'] == null
        ? null
        : TiempoVerbal.fromJson(json['futuro'] as Map<String, dynamic>),
    json['condicional'] == null
        ? null
        : TiempoVerbal.fromJson(json['condicional'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$IndicativoToJson(Indicativo instance) =>
    <String, dynamic>{
      'presente': instance.presente?.toJson(),
      'pret_imperf': instance.pret_imperf?.toJson(),
      'pret_perf_simple': instance.pret_perf_simple?.toJson(),
      'futuro': instance.futuro?.toJson(),
      'condicional': instance.condicional?.toJson(),
    };
