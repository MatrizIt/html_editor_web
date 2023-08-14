import 'package:flutter/material.dart';

class PhraseEditingController extends TextEditingController {
  final String id;
  final String phrase;
  String? defaultValue;

  PhraseEditingController({
    required this.id,
    required this.phrase,
  }) {
    if (phrase.contains("select") || phrase.contains("multiselect")) {
      final text = phrase
          .replaceAll("!*select", "")
          .replaceAll("!*multiselect", "")
          .replaceAll("*!", "")
          .replaceAll("(", "")
          .replaceAll(")", "");
      defaultValue = text.split(",")[0];
    }
  }
}
