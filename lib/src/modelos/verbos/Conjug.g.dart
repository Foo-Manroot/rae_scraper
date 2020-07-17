// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Conjug.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Conjug _$ConjugFromJson(Map<String, dynamic> json) {
  $checkKeys(json, requiredKeys: const [
    'infinitivo',
    'participio',
    'gerundio',
    'indicativo',
    'subjuntivo',
    'imperativo'
  ]);
  return Conjug(
    json['infinitivo'] as String,
    json['participio'] as String,
    json['gerundio'] as String,
    json['indicativo'] == null
        ? null
        : Indicativo.fromJson(json['indicativo'] as Map<String, dynamic>),
    json['subjuntivo'] == null
        ? null
        : Subjuntivo.fromJson(json['subjuntivo'] as Map<String, dynamic>),
    json['imperativo'] == null
        ? null
        : Imperativo.fromJson(json['imperativo'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ConjugToJson(Conjug instance) => <String, dynamic>{
      'infinitivo': instance.infinitivo,
      'participio': instance.participio,
      'gerundio': instance.gerundio,
      'indicativo': instance.indicativo?.toJson(),
      'subjuntivo': instance.subjuntivo?.toJson(),
      'imperativo': instance.imperativo?.toJson(),
    };
