// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Acepc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Acepc _$AcepcFromJson(Map<String, dynamic> json) {
  $checkKeys(json,
      requiredKeys: const ['num_acep', 'gram', 'texto', 'palabras']);
  return Acepc(
    json['num_acep'] as int,
    json['gram'] as String,
    json['texto'] as String,
    (json['palabras'] as List)
        ?.map((e) =>
            e == null ? null : Palabra.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    clase: _$enumDecodeNullable(_$ClaseAcepcEnumMap, json['clase']) ??
        ClaseAcepc.manual,
    uso: (json['uso'] as List)
            ?.map((e) =>
                e == null ? null : Uso.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    id: json['id'] as String,
  );
}

Map<String, dynamic> _$AcepcToJson(Acepc instance) => <String, dynamic>{
      'id': instance.id,
      'clase': _$ClaseAcepcEnumMap[instance.clase],
      'num_acep': instance.num_acep,
      'gram': instance.gram,
      'uso': instance.uso?.map((e) => e?.toJson())?.toList(),
      'texto': instance.texto,
      'palabras': instance.palabras?.map((e) => e?.toJson())?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ClaseAcepcEnumMap = {
  ClaseAcepc.manual: 'manual',
  ClaseAcepc.normal: 'normal',
  ClaseAcepc.frase_hecha: 'frase_hecha',
  ClaseAcepc.enlace: 'enlace',
};
