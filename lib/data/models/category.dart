import 'package:equatable/equatable.dart';

const unCategorized = Category(name: 'Uncategorized');

class Category extends Equatable {
  const Category({required this.name});

  factory Category.fromJson(dynamic json) {
    return Category(
      name: json['name'] is String ? json['name'] as String : 'None',
    );
  }
  Map<String, dynamic> toJson() {
    return <String, dynamic>{'name': name};
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
