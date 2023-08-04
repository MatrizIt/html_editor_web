import 'dart:convert';

import 'package:html_editor_web/app/model/teaching_model.dart';

class ScripModel {
  final String title;
  final List<TeachingModel> teachings;
  final int leading;
  ScripModel({
    required this.title,
    required this.teachings,
    required this.leading,
  });

  Map<String, dynamic> toMap() {
    return {
      'titulo': {
        'titulo': title,
      },
      'ensinamentos': teachings.map((teaching) => teaching.toMap()).toList(),
    };
  }

  factory ScripModel.fromMap(Map<String, dynamic> map) {
    return ScripModel(
      title: map['titulo']['titulo'] ?? '',
      teachings: List<TeachingModel>.from(
        map['ensinamentos']
                ?.map((teaching) => TeachingModel.fromMap(teaching)) ??
            const [],
      ),
      leading: int.tryParse(map['entrelinhas'] ?? "0") ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ScripModel.fromJson(String source) =>
      ScripModel.fromMap(json.decode(source));

  @override
  String toString() => 'ScripModel(title: $title, teachings: $teachings)';
}
