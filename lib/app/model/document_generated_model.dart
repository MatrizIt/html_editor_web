import 'dart:convert';

import 'package:reportpad/app/model/topic_model.dart';

class DocumentGeneratedModel {
  String? key;
  final int idProcedure;
  final int idSurvey;
  final int html;
  final bool pdf;
  final List<TopicModel> topics;

  DocumentGeneratedModel({
    required this.topics,
    required this.html,
    required this.idProcedure,
    required this.idSurvey,
    this.key,
    required this.pdf,
  });

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'idProcedure': idProcedure,
      'idSurvey': idSurvey,
      'html': html,
      'pdf': pdf,
      'topics': topics.map((topic) => topic.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
