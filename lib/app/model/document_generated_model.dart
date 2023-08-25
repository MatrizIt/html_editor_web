import 'dart:convert';

import 'package:reportpad/app/model/topic_model.dart';

class DocumentGeneratedModel {
  final String key;
  final int idProcedure;
  final int idSurvey;
  final String html;
  final bool pdf;
  final List<TopicModel> topics;

  DocumentGeneratedModel({
    required this.topics,
    required this.html,
    required this.idProcedure,
    required this.idSurvey,
    required this.key,
    required this.pdf,
  });

  Map<String, dynamic> toMap() {
    return {
      'chave': key,
      'idProcedimento': idProcedure,
      'idAgendamento': idSurvey,
      'html': html,
      'convenio': 0,
      'pdf': pdf,
      'topicos': topics.map((topic) => topic.toMap()).toList(),
    };
  }

  String toJson() => json.encode(toMap());
}
