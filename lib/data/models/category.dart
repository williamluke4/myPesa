import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'category.g.dart';

Uuid uuid = const Uuid();

Category defaultCategory = Category.none();

const schemaVersion = 1;

@JsonSerializable()
class Category extends Equatable {
  Category({required this.name, this.schema = schemaVersion, String? id})
      : id = id ?? uuid.v4();

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  factory Category.none() => Category(
        name: 'Uncategorized',
        id: 'dd978c2d-0d0c-4ebf-aa2d-b2032b6eb128',
      );

  /// Connect the generated [_$CategoryToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$CategoryToJson(this);
  final String id;
  final String name;
  final int schema;
  @override
  List<Object?> get props => [id, name, schema];

  Category copyWith({
    String? name,
    int? schema,
  }) {
    return Category(
      id: id,
      name: name ?? this.name,
      schema: schema ?? this.schema,
    );
  }
}
