import 'package:equatable/equatable.dart';

const unCategorized = Category(name: 'Uncategorized');

class Category extends Equatable {
  const Category({required this.name});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'] is String ? json['name'] as String : 'None',
    );
  }
  Map<String, String> toJson() {
    return <String, String>{'name': name};
  }

  final String name;

  @override
  List<Object?> get props => [name];

  Category copyWith({
    String? name,
  }) {
    return Category(name: name ?? this.name);
  }
}