// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Resultado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resultado _$ResultadoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['entradas', 'otras', 'palabra']);
  return Resultado(
    json['palabra'] == null
        ? null
        : Palabra.fromJson(json['palabra'] as Map<String, dynamic>),
    (json['entradas'] as List)
        ?.map((e) =>
            e == null ? null : Entrada.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['otras'] as List)?.map((e) => e as String)?.toList(),
    conjug: json['conjug'] == null
        ? null
        : Conjug.fromJson(json['conjug'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ResultadoToJson(Resultado instance) => <String, dynamic>{
      'entradas': instance.entradas?.map((e) => e?.toJson())?.toList(),
      'otras': instance.otras,
      'palabra': instance.palabra?.toJson(),
      'conjug': instance.conjug?.toJson(),
    };
