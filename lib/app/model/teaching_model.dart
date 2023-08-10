import 'dart:convert';

import 'package:reportpad/app/model/gatilho_model.dart';

class TeachingModel {
  final int id;
  final String name;
  String text;
  final List<GatilhoModel>? gatilhos;
  TeachingModel({
    required this.id,
    required this.name,
    required this.text,
    required this.gatilhos,
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
      gatilhos: map['gatilhos'] != null
          ? (map['gatilhos'] as List).map<GatilhoModel>((gatilho) {
              return GatilhoModel.fromMap(gatilho);
            }).toList()
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TeachingModel.fromJson(String source) =>
      TeachingModel.fromMap(json.decode(source));

  @override
  String toString() => 'TeachingModel(id: $id, name: $name, text: $text)';
}
