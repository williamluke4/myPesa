import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

Uuid uuid = const Uuid();

Category defaultCategory = Category.none();

List<Category> defaultCategories = [
  defaultCategory,
];
const schemaVersion = 1;

@JsonSerializable()
class Category extends Equatable {
  Category({
    required this.name,
    this.emoji = '🦋',
    this.schema = schemaVersion,
    String? id,
    int? lastModified,
  })  : id = id ?? uuid.v4(),
        lastModified = lastModified ?? DateTime.now().millisecondsSinceEpoch;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.none() => Category(
        emoji: '😅',
        name: 'Uncategorized',
        id: 'dd978c2d-0d0c-4ebf-aa2d-b2032b6eb128',
      );

  /// Connect the generated [_$CategoryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
  final String id;
  final int lastModified;
  final String name;
  final String emoji;
  final int schema;
  @override
  List<Object?> get props => [id, name, emoji, schema];

  Category copyWith({
    String? name,
    String? emoji,
    int? schema,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      schema: schema ?? this.schema,
      lastModified: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
