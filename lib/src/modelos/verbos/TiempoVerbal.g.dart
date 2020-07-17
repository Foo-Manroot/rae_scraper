// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TiempoVerbal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TiempoVerbal _$TiempoVerbalFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'nombre',
    'sing_prim',
    'sing_seg',
    'sing_terc',
    'plural_prim',
    'plural_seg',
    'plural_terc'
  ]);
  return TiempoVerbal(
    json['nombre'] as String,
    (json['sing_seg'] as List)?.map((e) => e as String)?.toList(),
    (json['plural_seg'] as List)?.map((e) => e as String)?.toList(),
    sing_prim: json['sing_prim'] as String,
    sing_terc: json['sing_terc'] as String,
    plural_prim: json['plural_prim'] as String,
    plural_terc: json['plural_terc'] as String,
  );
}

Map<String, dynamic> _$TiempoVerbalToJson(TiempoVerbal instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'sing_prim': instance.sing_prim,
      'sing_seg': instance.sing_seg,
      'sing_terc': instance.sing_terc,
      'plural_prim': instance.plural_prim,
      'plural_seg': instance.plural_seg,
      'plural_terc': instance.plural_terc,
    };
