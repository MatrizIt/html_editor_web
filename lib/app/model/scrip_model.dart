import 'dart:convert';

import 'package:reportpad/app/model/teaching_model.dart';

class ScripModel {
  final int id;
  final String title;
  final List<TeachingModel> teachings;
  final int leading;
  bool isVisible = true;
  int selectedTeaching = 0;
  ScripModel({
    required this.id,
    required this.title,
    required this.teachings,
    required this.leading,
  });

  String get selectedTeachingText => teachings[selectedTeaching].text;

  changeVisibility() {
    isVisible = !isVisible;
  }

  changeSelectedTeaching(int index) {
    selectedTeaching = index;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': {
        'titulo': title,
      },
      'ensinamentos': teachings.map((teaching) => teaching.toMap()).toList(),
    };
  }

  factory ScripModel.fromMap(Map<String, dynamic> map) {
    return ScripModel(
      id: map["titulo"]["id"] ?? 0,
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
