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
  );
}

Map<String, dynamic> _$ExprToJson(Expr instance) => <String, dynamic>{
      'id': instance.id,
      'texto': instance.texto,
      'definiciones': instance.definiciones?.map((e) => e?.toJson())?.toList(),
    };
