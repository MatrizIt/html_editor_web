import 'dart:convert';

class TeachingModel {
  final int id;
  final String name;
  String text;
  TeachingModel({
    required this.id,
    required this.name,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': name,
      'texto': text,
    };
  }

  factory TeachingModel.fromMap(Map<String, dynamic> map) {
    return TeachingModel(
      id: map['id'] ?? 0,
      name: map['nome'] ?? '',
      text: map['texto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TeachingModel.fromJson(String source) =>
      TeachingModel.fromMap(json.decode(source));

  @override
  String toString() => 'TeachingModel(id: $id, name: $name, text: $text)';
}
