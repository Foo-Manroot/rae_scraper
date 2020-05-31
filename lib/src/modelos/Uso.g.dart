// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Uso.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Uso _$UsoFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['abrev', 'significado']);
  return Uso(
    json['abrev'] as String,
    (json['significado'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$UsoToJson(Uso instance) => <String, dynamic>{
      'abrev': instance.abrev,
      'significado': instance.significado,
    };
