import 'dart:convert';

class TopicModel {
  final String topic;
  final String text;
  TopicModel({
    required this.topic,
    required this.text,
  });

  Map<String, dynamic> toMap() {
    return {
      'topico': topic,
      'texto': text,
    };
  }

  String toJson() => json.encode(toMap());
}
