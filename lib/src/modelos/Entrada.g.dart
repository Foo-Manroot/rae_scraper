// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Entrada.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Entrada _$EntradaFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const ['title', 'etim']);
  return Entrada(
    json['title'] as String,
    json['etim'] as String,
    id: json['id'] as String,
    definiciones: (json['definiciones'] as List)
            ?.map((e) =>
                e == null ? null : Definic.fromJson(e as Map<String, dynamic>))
            ?.toList() ??
        [],
  );
}

Map<String, dynamic> _$EntradaToJson(Entrada instance) => <String, dynamic>{
      'definiciones': instance.definiciones?.map((e) => e?.toJson())?.toList(),
      'title': instance.title,
      'etim': instance.etim,
      'id': instance.id,
    };
