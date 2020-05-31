// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Resultado.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Resultado _$ResultadoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['entradas', 'otras']);
  return Resultado(
    (json['entradas'] as List)
        ?.map((e) =>
            e == null ? null : Entrada.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    (json['otras'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$ResultadoToJson(Resultado instance) => <String, dynamic>{
      'entradas': instance.entradas?.map((e) => e?.toJson())?.toList(),
      'otras': instance.otras,
    };
