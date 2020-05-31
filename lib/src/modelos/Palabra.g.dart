// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Palabra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Palabra _$PalabraFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['texto']);
  return Palabra(
    json['texto'] as String,
    dataId: json['data_id'] as String,
    abbr: json['abbr'] as String,
    enlaceRecurso: json['enlace_recurso'] as String,
  );
}

Map<String, dynamic> _$PalabraToJson(Palabra instance) => <String, dynamic>{
      'abbr': instance.abbr,
      'texto': instance.texto,
      'data_id': instance.dataId,
      'enlace_recurso': instance.enlaceRecurso,
    };
