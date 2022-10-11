// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Category _$CategoryFromJson(Map<String, dynamic> json) => Category(
      name: json['name'] as String,
      emoji: json['emoji'] as String? ?? '🦋',
      schema: json['schema'] as int? ?? schemaVersion,
      id: json['id'] as String?,
      lastModified: json['lastModified'] as int?,
    );

Map<String, dynamic> _$CategoryToJson(Category instance) => <String, dynamic>{
      'id': instance.id,
      'lastModified': instance.lastModified,
      'name': instance.name,
      'emoji': instance.emoji,
      'schema': instance.schema,
    };
