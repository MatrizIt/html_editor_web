import 'dart:convert';

class TeachingModel {
  final String name;
  final String text;
  TeachingModel({
    required this.name,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': name,
      'texto': text,
    };
  }

  factory TeachingModel.fromMap(Map<String, dynamic> map) {
    return TeachingModel(
      name: map['nome'] ?? '',
      text: map['texto'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TeachingModel.fromJson(String source) =>
      TeachingModel.fromMap(json.decode(source));

  @override
  String toString() => 'TeachingModel(name: $name, text: $text)';
}
