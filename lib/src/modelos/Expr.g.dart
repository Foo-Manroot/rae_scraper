// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Expr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expr _$ExprFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['texto']);
  return Expr(
    json['texto'] as String,
    id: json['id'] as String,
    definiciones: (json['definiciones'] as List)
            ?.map((e) =>
                e == null ? null : Acepc.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
    clase: _$enumDecodeNullable(_$ClaseAcepcEnumMap, json['clase']) ??
        ClaseAcepc.manual,
  );
}

Map<String, dynamic> _$ExprToJson(Expr instance) => <String, dynamic>{
      'id': instance.id,
      'clase': _$ClaseAcepcEnumMap[instance.clase],
      'texto': instance.texto,
      'definiciones': instance.definiciones?.map((e) => e?.toJson())?.toList(),
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
