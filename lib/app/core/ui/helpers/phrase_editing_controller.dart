import 'package:flutter/material.dart';

class PhraseEditingController extends TextEditingController {
  final String id;
  final String phrase;
  String? defaultValue;
  bool isRequired;

  PhraseEditingController({
    required this.id,
    required this.phrase,
    required this.isRequired,
  }) {
    if (phrase.contains("select") || phrase.contains("multiselect")) {
      final regexp = RegExp(r'!\*.*?\(.*?.*?\)=(.*?)\*!');
      final text = regexp.firstMatch(phrase);
      defaultValue = text?.group(1);
    }
  }
}
